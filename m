Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752765AbYLRTxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbYLRTxk (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYLRTxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:53:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36790 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYLRTx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:53:29 -0500
Message-ID: <494AAA4C.8070906@redhat.com>
Date: Thu, 18 Dec 2008 14:53:48 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: srostedt@redhat.com, peterz@infradead.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: Re: [RFC] globmatch() helper function
References: <20081217104247.28440.qmail@science.horizon.com> <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins> <1229528856.30177.4.camel@localhost.localdomain> <20081218080027.27011.qmail@science.horizon.com> <20081218085524.12622.qmail@science.horizon.com>
In-Reply-To: <20081218085524.12622.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George Spelvin wrote:
> Eureka!
>
> Never mind all of this angst; I've figured out a non-recursive way
> to do it.  Thanks for pushing me to think a bit harder and find it.
> (I was actually looking for an example of the exponential pathology I
> kept referring to when it dawned on me that it's actually impossible
> without the additional expressive power of regexps.)
>
> Somewhat abusing TeX's line-breaking terminology, consider a shell glob to
> consist of a series of "boxes" and "glue"  A box is a run of character
> classes (of which literal characters and ? are degenerate cases).  The
> point is, a box has a well-defined width, the number of characters in the
> string that it must match.
>   
Yours is better, but I may as well post my solution:

--code starts--
#include <stdbool.h>
#include <string.h>    /* For strchr */

#ifndef __pure
/* Kernel compatibility #define */
#define __pure __attribute__((pure))
#endif

/**
 * is_in_class - globmatch() helper, returns true if character is in class.
 * @c: Character to be tested.
 * @pat: Character class to test for inclusion in, terminated by ']'.
 *
 * Evaluate the "body" of a character class.  Given the class "[!a-z]",
 * this expects @pat to point to the a, and proceeds until the closing ].
 * The caller must skip the opening bracket and the complement character.
 *
 * The caller must verify that a terminating ] exists; this will NOT
 * stop at a trailing nul byte.  Also, the first character may be ];
 * that is not taken as a terminator.
 *
 * Comparison is done using unsigned bytes, 0...255.
 */
static bool __pure
is_in_class(unsigned char c, char const *pat)
{
    /*
     * Iterate over each span in the character class.
     * a span is either a single character x, or a
     * range x-y.
     */
    do {
        unsigned char c1 = *pat++, c2 = c1;

        if (pat[0] == '-' && pat[1] != ']') {
            c2 = pat[1];
            pat += 2;
        }
        /* Any special action if c1 > c2? */
        if (c1 <= c && c <= c2)
            return true;
    } while (*pat != ']');
    return false;
}

/**
 * given a pattern, find the minimum string length that would match it
 **/
static int __pure
patsize(char const *pat)
{
    int retval = 0;
    int grouplen = 0;

    for(;*pat;pat++) {
        if (*pat == '*') {
            continue;
        } else if ((grouplen > 2 || (grouplen == 2 && *(pat-1) != '^' &&
                      *(pat-1) != '!')) && *pat == ']') {
            grouplen = 0;
        } else if (grouplen) {
            grouplen++;
        } else {
            if (*pat == '[') {
                grouplen++;
            }
            retval++;
        }
    }
    return retval;
}

/**
 * Generates the next balls-and-boxes sequence of integer pattern widths
 */
static bool
next_arrangement(int *buckets, int found, int total)
{
    int i;
    bool retval = false;

    if (!found || total == 1)
        return false;

    for (i = found; i < total-1; i++) {
        buckets[total-1] += buckets[i];
        buckets[i] = 0;
    }

    for (i = total - 2; i >= 0; i--) {
        if (!buckets[i])
            continue;
        retval = true;
        buckets[i]--;
        buckets[i+1]++;
        if ((i < total-2) && total > 2) {
            buckets[i+1] += buckets[total-1];
            buckets[total-1] = 0;
        }
        break;
    }

    return retval;
}

/**
 * globmatch - Shell-style pattern matching, like !fnmatch(pat, str, 0)
 * @pat: Pattern to match.  Metacharacters are ?, *, [ and \.
 * @str: String to match.  the pattern must match the entire string.
 *
 * Perform shell-style glob matching, returning true if the match succeeds.
 * Like !fnmatch(@pat, @str, 0) and unlike the shell, this does NOT 
treat / or
 * leading . specially; it isn't actually used for pathnames.
 *
 * This is small and simple implementation intended for device blacklists
 * where the pattern is part of the kernel.  It recurses on each * in
 * the pattern (although the stack frame is small), so shouldn't be
 * fed pathological patterns with many *s.
 */
static bool __pure
globmatch(char const *in_pat, char const *in_str)
{
    int star_width[10] = { 0,0,0,0,0,0,0,0,0,0 };
    int stars_found = 0;
    int stars_total = 0;
    char const *str = in_str;
    char const *pat = in_pat;
    int i;

    char const *loc;
    for (loc = pat; *loc; stars_total += (*(loc++) == '*'));
    if (stars_total > 10)
        return false;

    for (loc = str; *loc; loc++, star_width[0]++);
    star_width[0] -= patsize(pat);

    if (star_width[stars_total-1] < 0)
        return false;

    /*
     * Loop over each token (character or class) in pat, matching
     * it against the remaining unmatched tail of str.  Return false
     * on mismatch, or true after matching the trailing nul bytes.
     *
     */
   
repeat:    do {
        char const *end;
        bool inv;
        int i;

        /*
         * (To handle * properly, which may match zero bytes, each case is
         * required to increment the str pointer itself.
         */
        switch (pat[0]) {
        case '?':
            if (!*str++)
                goto rearrange;
            break;
        case '*':
            if (pat[1] == '\0')    /* Optimize trailing * case */
                return true;
            for (i = 0; *str && i < star_width[stars_found];
                 i++, str++);
            stars_found++;
            break;
        case '[':
            /* Character class */
            /* Is it an inverted character class? */
            inv = (pat[1] == '^' || pat[1] == '!');
            /* If no terminating ], interpret as plain text. */
            end = strchr(pat+2+inv, ']');
            if (!end)
                goto def;
            pat += 1 + inv;
            if (is_in_class(*str++, pat) == inv)
                goto rearrange;
            pat = end;
            break;
        case '\\':
            pat++;
            /* FALLLTHROUGH */
        default:
def:
            if (*pat != *str++)
                goto rearrange;
            break;
        }
    } while (*pat++);
    return true;

rearrange:
    if (next_arrangement(star_width, stars_found, stars_total)) {
        stars_found = 0;
        str = in_str;
        pat = in_pat;
        goto repeat;
    }

    return false;
}

/* Test code */
#include <stdio.h>
#include <stdlib.h>

static void
test(char const *pat, char const *str, bool expected)
{
    bool match = globmatch(pat, str);
    printf("\"%s\" vs. \"%s\": %s %s\n", pat, str, match ? "match" : 
"mismatch",
        match == expected ? "OK" : "*** ERROR ***");
    /*if (match != expected)
        exit(1);*/
}

int
main(void)
{
    test("a", "a", true);
    test("a", "b", false);
    test("a", "aa", false);
    test("a", "", false);
    test("", "", true);
    test("", "a", false);
    test("?", "a", true);
    test("?", "aa", false);
    test("??", "a", false);
    test("?x?", "axb", true);
    test("?x?", "abx", false);
    test("?x?", "xab", false);
    test("*??", "a", false);
    test("*??", "ab", true);
    test("*??", "abc", true);
    test("??*", "a", false);
    test("??*", "ab", true);
    test("??*", "abc", true);
    test("?*?", "a", false);
    test("?*?", "ab", true);
    test("?*?", "abc", true);
    test("*b", "b", true);
    test("*b", "ab", true);
    test("*b", "aab", true);
    test("*bc", "abbc", true);
    test("*bc", "bc", true);
    test("*bc", "bbc", true);
    test("*abcd*", "abcabcabcabcdefg", true);
    test("*abcd*", "abcabcabcabcefg", false);
    test("*abcd*q*r*", "abcabcabcabcdefgqabrcd", true);
    test("[a]", "a", true);
    test("[^a]", "a", false);
    test("[!a]", "a", false);
    test("[!a]", "b", true);
    test("[ab]", "a", true);
    test("[ab]", "b", true);
    test("[ab]", "c", false);
    test("[^ab]", "c", true);
    test("[a-c]", "b", true);
    test("[a-c]", "d", false);
    test("[]a-ceg-ik[]", "a", true);
    test("[]a-ceg-ik[]", "]", true);
    test("[]a-ceg-ik[]", "[", true);
    test("[]a-ceg-ik[]", "h", true);
    test("[]a-ceg-ik[]", "f", false);
    test("[!]a-ceg-ik[]", "h", false);
    test("[!]a-ceg-ik[]", "]", false);
    test("[!]a-ceg-ik[]", "f", true);

    return 0;
}

