Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYLRVxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYLRVxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYLRVxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:53:16 -0500
Received: from science.horizon.com ([192.35.100.1]:14384 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752174AbYLRVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:53:15 -0500
Message-ID: <20081218215308.30730.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Thu, 18 Dec 2008 16:53:08 -0500
To: linux@horizon.com, cdahlin@redhat.com
Cc: tj@kernel.org, srostedt@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: Re: [RFC] globmatch() helper function
References: <20081217104247.28440.qmail@science.horizon.com>
 <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins>
 <1229528856.30177.4.camel@localhost.localdomain>
 <20081218080027.27011.qmail@science.horizon.com>
 <20081218085524.12622.qmail@science.horizon.com>
 <494AAA4C.8070906@redhat.com>
In-Reply-To: <494AAA4C.8070906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Dahlin <cdahlin@redhat.com> wrote:
> George Spelvin wrote:
>> Eureka!
>>
>> Never mind all of this angst; I've figured out a non-recursive way
>> to do it.  Thanks for pushing me to think a bit harder and find it.
>
> Yours is better, but I may as well post my solution:

Interesting.  You can see how complex that gets.

Here's my solution, currently a stand-alone executable:

#include <stdbool.h>
#include <string.h>	/* For strchr */
#include <assert.h>

#define WARN_ON(x) assert(!(x))

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
 * globmatch - Shell-style pattern matching, like !fnmatch(pat, str, 0)
 * @pat: Pattern to match.  Metacharacters are ?, *, [ and \.
 * @str: String to match.  the pattern must match the entire string.
 * @maxdepth: Maximum number of (non-trailing) * permitted in pattern.
 *
 * Perform shell-style glob matching, returning true if it matches.
 * 
 * Like !fnmatch(@pat, @str, 0) and unlike the shell, this does NOT
 * treat / or leading . specially; it isn't actually used for pathnames.
 *
 * This is small and simple implementation intended for device blacklists
 * where a string is matched against a number of patterns.  Thus,
 * it does not proprocess the patterns.  Run-time is at most quadratic
 * in strlen(@str).
 */
static bool __pure
globmatch(char const *pat, char const *str)
{
	/*
	 * Backtrack to previous * on mismatch nad retry starting one
	 * character later in the string.  It can be proved that there's
	 * never a need to backtrack multiple levels.
	 */
	char const *back_pat = 0, *back_str = back_str;

	/*
	 * Loop over each token (character or class) in pat, matching
	 * it against the remaining unmatched tail of str.  Return false
	 * on mismatch, or true after matching the trailing nul bytes.
	 */
	do {
		/*
		 * (To handle * properly, which may match zero bytes, each
		 * case is required to increment the str pointer itself.)
		 */
		switch (pat[0]) {
			char c;
		case '?':	/* Wildcard: anything but nul */
			if (!*str++)
				return false;
			break;
		case '*':	/* Any-length wildcard */
			/* This doesn't loop... */
			if (pat[1] == '\0')	/* Optimize trailing * case */
				return true;
			back_pat = pat;
			back_str = str;
			break;
		case '[': {	/* Character class */
			/* Is it an inverted character class? */
			bool inv = (pat[1] == '^' || pat[1] == '!');
			/* If no terminating ], interpret as plain text. */
			char const *end = strchr(pat+2+inv, ']');
			if (!end)
				goto def;	/* Or return -1 for malformed pattern? */
			pat += 1 + inv;
			c = *str++;
			if (is_in_class(c, pat) == inv)
				goto backtrack;
			pat = end;
			}
			break;
		case '\\':
			pat++;
			/* FALLLTHROUGH */
		default:	/* Literal character */
def:
			c = *str++;
			if (*pat == c)
				break;
backtrack:
			if (c == '\0' || !back_pat)
				return false;	/* No point continuing */
			/* Try again from last *, one character later in str. */
			pat = back_pat;
			str = ++back_str;
			break;
		}
	} while (*pat++);
	return true;
}

/* Test code */
#include <stdio.h>
#include <stdlib.h>

static void
test(char const *pat, char const *str, bool expected)
{
	bool match = globmatch(pat, str);
	printf("\"%s\" vs. \"%s\": %s %s\n", pat, str, match ? "match" : "mismatch",
		match == expected ? "OK" : "*** ERROR ***");
	if (match != expected)
		exit(1);
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
	test("*ac*", "abacadaeafag", true);
	test("*ac*ae*ag*", "abacadaeafag", true);
	test("*a*b*[bc]*[ef]*g*", "abacadaeafag", true);
	test("*a*b*[ef]*[cd]*g*", "abacadaeafag", false);
	test("*abcd*", "abcabcabcabcdefg", true);
	test("*ab*cd*", "abcabcabcabcdefg", true);
	test("*abcd*abcdef*", "abcabcdabcdeabcdefg", true);
	test("*abcd*", "abcabcabcabcefg", false);
	test("*ab*cd*", "abcabcabcabcefg", false);
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
	test("[!]a-ceg-ik[]", "f", true);

	return 0;
}
