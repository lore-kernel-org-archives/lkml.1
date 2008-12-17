Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759440AbYLQKnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYLQKnA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 05:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbYLQKmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 05:42:50 -0500
Received: from science.horizon.com ([192.35.100.1]:12301 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752634AbYLQKmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 05:42:49 -0500
Message-ID: <20081217104247.28440.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Wed, 17 Dec 2008 05:42:47 -0500
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, linux@horizon.com
Subject: [RFC] globmatch() helper function
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was just noticing that the latest libata drive blacklist update
(libbata: fix Seagate NCQ+FLUSH blacklist) is suffering an NxM explosion
of model numbers and firmware versions:

Any of the 6 models
	"ST31500341AS"
	"ST31000333AS"
	"ST3640623AS"
	"ST3640323AS"
	"ST3320813AS"
	"ST3320613AS"
	
With any of the 5 firmware versions
	"SD15"
	"SD16"
	"SD17"
	"SD18"
	"SD19"

Requires 30 entries in ata_device_blacklist[].

With some simple globbing, that could be reduced to four entries:
	"ST31500341AS", "SD1[5-9]"
	"ST31000333AS", "SD1[5-9]"
	"ST3640?23AS", "SD1[5-9]"
	"ST3320?13AS", "SD1[5-9]"

There's already a trailing-* special case in the matching code, but
a generic helper in lib/ might be more useful.

So I whipped up the following.  This code uses shell globbing for
compactness; a full regexp engine doesn't seem called for.

This has to be turned into a patch with a header file, but any comments
on the following code?  (MODULE_LICSENSE("Public domain"))


Other places it could be used:
drivers/acpi/blacklist.c: 
        {
        .callback = dmi_enable_osi_linux,
        .ident = "Lenovo ThinkPad x61",
        .matches = {
                     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
                     DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad [RTX]61"),
                },
        },

drivers/ata/pata_hpt366.c:
drivers/ata/pata_hpt37x.c:
static const char * const bad_ata33[] = {
	"Maxtor 90256D2", "Maxtor 90288D2", "Maxtor 90340D2", "Maxtor 90432D2", "Maxtor 90500D4",
	"Maxtor 90510D3", "Maxtor 90576D4", "Maxtor 90625D5", "Maxtor 90648D3", "Maxtor 90648D5",
	"Maxtor 90650U2", "Maxtor 90680D4", "Maxtor 90720D5", "Maxtor 90750D6", "Maxtor 90840D[67]",
	"Maxtor 90845D[456]", "Maxtor 90845U3", "Maxtor 90875D7", "Maxtor 90910D8", "Maxtor 91008D7",
	"Maxtor 91020D6", "Maxtor 91020U3", "Maxtor 91080D5", "Maxtor 91190D7", "Maxtor 91303D6",
	"Maxtor 91360U4", "Maxtor 91512D7", "Maxtor 92040U6", "Maxtor 90432D3", "Maxtor 90510D4",
	"Maxtor 91000D8", "Maxtor 91152D8", "Maxtor 91360D8", "Maxtor 91728D8", "Maxtor 92720U8",
	NULL
};

static const char * const bad_ata66_4[] = {
        "IBM-DTLA-3050[234]0",
        "IBM-DTLA-3070[147]5",
        "IBM-DTLA-3070[236]0",
        "IC35L0[1-46]0AVER07-0",
        "WDC AC310200R",
        NULL
};

drivers/ide/ide-pio-blacklist.c: ide_pio_blacklist[]

And possibly drivers/scsi/scsi_devinfo.c

--- Code starts here ---

#include <stdbool.h>
#include <string.h>	/* For strchr */

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
 *
 * Perform shell-style glob matching, returning true if the match succeeds.
 * Like !fnmatch(@pat, @str, 0) and unlike the shell, this does NOT treat / or
 * leading . specially; it isn't actually used for pathnames.
 *
 * This is small and simple implementation intended for device blacklists
 * where the pattern is part of the kernel.  It recurses on each * in
 * the pattern (although the stack frame is small), so shouldn't be
 * fed pathological patterns with many *s.
 */
static bool __pure
globmatch(char const *pat, char const *str)
{
	/*
	 * Loop over each token (character or class) in pat, matching
	 * it against the remaining unmatched tail of str.  Return false
	 * on mismatch, or true after matching the trailing nul bytes.
	 *
	 */
	do {
		char const *end;
		bool inv;

		/*
		 * (To handle * properly, which may match zero bytes, each case is
		 * required to increment the str pointer itself.
		 */
		switch (pat[0]) {
		case '?':
			if (!*str++)
				return false;
			break;
		case '*':
			if (pat[1] == '\0')	/* Optimize trailing * case */
				return true;
			/* Recurse on each possible tail of str */
			while (!globmatch(pat+1, str))
				if (!*str++)
					return false;
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
				return false;
			pat = end;
			break;
		case '\\':
			pat++;
			/* FALLLTHROUGH */
		default:
def:
			if (*pat != *str++)
				return false;
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
	test("*abcd*", "abcabcabcabcdefg", true);
	test("*abcd*", "abcabcabcabcefg", false);
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
