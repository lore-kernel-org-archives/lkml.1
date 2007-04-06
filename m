Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbXDFTnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbXDFTnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932319AbXDFTnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:43:11 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35063 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbXDFTnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:43:09 -0400
Message-ID: <4616A2C7.3030000@zytor.com>
Date: Fri, 06 Apr 2007 12:43:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Egmont Koblinger <egmont@uhulinux.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
References: <20070406191245.GA11974@uhulinux.hu>
In-Reply-To: <20070406191245.GA11974@uhulinux.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Egmont Koblinger wrote:
> 
> - If a certain (otherwise valid UTF-8) character is not found in the glyph
>   table, the current code does one of these two (depending on other
>   circumstances):
> 
>   - Either it displays the replacement character U+FFFD, falling back to a
>     simple question mark. Note that the Unicode replacement character U+FFFD
>     is to be used for invalid sequences. However, it shouldn't necessarily
>     be used when replacing a valid but undisplayable character. Think of
>     Pango for example that renders these as four hex digits inside a square.
>     To be able to visually distinguish between illegal sequences and legal
>     but undisplayable characters, I think U+FFFD or the question mark are
>     bad choices. In fact, any symbol that may normally occur in the text is
>     a bad choice if is displayed simply. Hence I chose to display an
>     inverted dot.
> 

I strongly disagree.  First of all, you're changing the semantics of a 
13-year-old API.  The semantics of the Linux console is that by 
specifying U+FFFD SUBSTITUTION GLYPH in your unicode table, you have 
specified the fallback glyph.

What's worse, you've hard-coded the uses of specific visual 
representations.  That is completely unacceptable.

>   - Another possible thing the current code may do (for latin1-compatible
>     characters) is to simply display the glyph loaded in that position.
>     Suppose I have loaded a latin2 font. In latin2, 0xFB is an "u with
>     double accent". An applications prints U+00FB, which is an "u with
>     circumflex". Since this glyph is not present in latin2, it cannot be
>     printed with the current font. Still, the current code falls back to
>     printing the glyph from the 0xFB position of the glyph table. Hence my
>     app asked to print "u with circumflex" but an "u with double accent"
>     appears on the screen. This is totally contrary to the goals of Unicode
>     and shouldn't ever happen.

When does that happen?  That is clearly a bug.

> - The replacement character for invalid UTF-8 sequences is U+FFFD, falling
>   back to a question mark. I've changed the fallback version to an inverted
>   question mark. This way it's more similar to the common glyph of U+FFFD,
>   and it's more trivial to the user that it's not a literal question mark
>   but rather some erroneous situation.

Brilliant.  You've picked a fallback glyph which is unlikely to exist in 
all fonts.  The whole point of falling back to ? is that it's an ASCII 
character, which means that if the font designer failed to designate a 
fallback glyph -- which is an error!!! -- there is at least some hope of 
conveying the error back to the user.

> - Overlong sequences are not caught currently, they're displayed as if these
>   were valid representations. This may even have security impacts.
> 
> - Lone continuation bytes (section 3.1 of the UTF-8 stress test) are
>   currently displayed as some "random" glyphs rather than the replacement
>   character.
> 
> - Incomplete sequences (sections 3.2 and 3.3) emit no replacement character,
>   but rather cause the subsequent valid character to be displayed more
>   times(!).

These are valid issues.

> - There's no concept of double-width characters. It's way beyond the scope
>   of my patch to try to display them, but at least I think it's important
>   for the cursor to jump two positions when printing such characters, since
>   this is what applications (such as text editors) expect. If the cursor
>   didn't jump two positions, applications would suffer from displaying and
>   refreshing problems, and editing some English letters that are preceded by
>   some CJK characters in the same line became a nightmare. With my patch an
>   inverted dot followed by an inverted space is displayed for double-width
>   characters so it's quite easy to see that they are tied together.

To be able to do CJK you need something like Kon anyway.  This feels 
like bloat.

> - There's no concept of zero-width characters (such as combining accents)
>   either. Yet again it's beyond the scope of my patch to properly handle
>   them. Instead of the current behavior (write a replacement character) I
>   just ignore them so that full-screen applications can keep track of the
>   cursor position correctly.

There is a concept of combining sequences.  Anything else, I suspect 
it's better to let the user know that something bad is happening.

> - I believe (at least I do hope) that my code is cleaner, more
>   straightforward, easier to understand, and is slightly better documented
>   than the current version. The current code doesn't separate UTF-8 decoding
>   and glyph displaying parts. I clearly separated them. First I perform
>   UTF-8 decoding (this emits U+FFFD for invalid sequences), then check for
>   the width of the resulting character, change it to U+FFFD if it's
>   unprintable (e.g. an UTF-16 surrogate), and finally comes the part that
>   does its best in displaying the character on the screen.
> 
> I hope you like it. :)

Please see above comments.

	-hpa
