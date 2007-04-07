Return-Path: <linux-kernel-owner+w=401wt.eu-S965692AbXDGJYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692AbXDGJYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965699AbXDGJYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:24:55 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:51049 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965692AbXDGJYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:24:53 -0400
Date: Sat, 7 Apr 2007 11:24:52 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070407092451.GA8779@uhulinux.hu>
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4616A2C7.3030000@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 12:43:03PM -0700, H. Peter Anvin wrote:

Hi,

> I strongly disagree.  First of all, you're changing the semantics of a 
> 13-year-old API.  The semantics of the Linux console is that by 
> specifying U+FFFD SUBSTITUTION GLYPH in your unicode table, you have 
> specified the fallback glyph.

OK, I'm not against using U+FFFD for missing glyphs. In the mean time I
think it's still a good idea to clearly separate the two cases in the code
(that is, the case of invalid sequence from the case of missing glyph), but
we can still use the same replacement character in these two cases. I'll
send an updated patch after Easter if it sounds good for you.


> What's worse, you've hard-coded the uses of specific visual 
> representations.  That is completely unacceptable.

Now that we've dropped the idea of "dot" for missing glyphs, the other thing
that remains is the hard-coded '?' if and only if U+FFFD is not present in
the font. It is even hardcoded in the current code and I have no better
idea, there must be a last-resort hardcoded fallback. The only thing I
changed is that I inverted the color attributes for this question mark. Do
you think that the old behavior, a normal question mark would be better? No
problem, I'll adjust the code in this case. Just please tell me what the
expected behavior is, I'm not sure I clearly understand your thoughts.


> >  - Another possible thing the current code may do (for latin1-compatible
> >    characters) is to simply display the glyph loaded in that position.
> >    Suppose I have loaded a latin2 font. In latin2, 0xFB is an "u with
> >    double accent". An applications prints U+00FB, which is an "u with
> >    circumflex". Since this glyph is not present in latin2, it cannot be
> >    printed with the current font. Still, the current code falls back to
> >    printing the glyph from the 0xFB position of the glyph table. Hence my
> >    app asked to print "u with circumflex" but an "u with double accent"
> >    appears on the screen. This is totally contrary to the goals of Unicode
> >    and shouldn't ever happen.
> 
> When does that happen?  That is clearly a bug.

I think I've (mostly) described it above. Set everything to UTF-8, load a
latin2 font (containing 256 glyphs, e.g. "setfont lat2-16"), make an
application print U+00FB (alt + numpad 251 is one trivial way), you'll see
an "u with double accent", though the symbol to be displayed is "u with
circumflex". This isn't present in the current font, so the replacement
character should appear, not a different letter.


> >- The replacement character for invalid UTF-8 sequences is U+FFFD, falling
> >  back to a question mark. I've changed the fallback version to an inverted
> >  question mark. This way it's more similar to the common glyph of U+FFFD,
> >  and it's more trivial to the user that it's not a literal question mark
> >  but rather some erroneous situation.
> 
> Brilliant.  You've picked a fallback glyph which is unlikely to exist in 
> all fonts.  The whole point of falling back to ? is that it's an ASCII 
> character, which means that if the font designer failed to designate a 
> fallback glyph -- which is an error!!! -- there is at least some hope of 
> conveying the error back to the user.

Sorry, I wasn't clear enough and I think you misunderstood me. The symbol I
choose for fallback is still '?' (the ASCII question mark), I just invert
the color attributes of the cell where this is printed. This way it becomes
visually distinguisable from the literal question mark. Using the current
kernel you just cannot know whether the character printed is a real question
mark, or a replacement glyph. Still, should you stongly disagree with this
decision, the color inverting part can easily be removed.

> >- There's no concept of double-width characters. It's way beyond the scope
> >  of my patch to try to display them, but at least I think it's important
> >  for the cursor to jump two positions when printing such characters, since
> >  this is what applications (such as text editors) expect. If the cursor
> >  didn't jump two positions, applications would suffer from displaying and
> >  refreshing problems, and editing some English letters that are preceded 
> >  by
> >  some CJK characters in the same line became a nightmare. With my patch an
> >  inverted dot followed by an inverted space is displayed for double-width
> >  characters so it's quite easy to see that they are tied together.
> 
> To be able to do CJK you need something like Kon anyway.  This feels 
> like bloat.

I don't want CJK support. All that I want is to be able to edit English
words within a file that contains mixture of English and CJK, with a text
editor like vim or joe. Just try it with the current kernel, and with my
patch. Suppose that within a line some CJK text is followed by an English
word, and you want to edit the latter one. It's going to be a huge headache
with the current kernel. Where you see the cursor is not where the text
editor thinks it is. You try to delete a letter and actually another letter
gets deleted, for example.

The only thing my patch does here is that it inserts an extra space to
guarantee that the cursor goes to the correct position, where applications
expect it to be. I can't see any reason why this behavior could be worse
than the current one. Is there any?

> >- There's no concept of zero-width characters (such as combining accents)
> >  either. Yet again it's beyond the scope of my patch to properly handle
> >  them. Instead of the current behavior (write a replacement character) I
> >  just ignore them so that full-screen applications can keep track of the
> >  cursor position correctly.
> 
> There is a concept of combining sequences.  Anything else, I suspect 
> it's better to let the user know that something bad is happening.

There are two choices. Either let the user know that something bad is
happening, and then he'll face the same cursor-mispositioning issues in his
editor that we've just discussed with CJK, or we silently drop them and text
editing will work correctly. It's a harder decision than CJK, I can see pros
and cons for both approaches. I accept if you say the former one is the
desirable way; but still I'd prefer the source to be structured in a way
that it's easy to change (doesn't need complete rewrite, only a two-line
patch) if someone wants the other behaviour. Actually all you have to do is
that if wcwidth() returns 0 then pretend it was 1, instead of skipping the
whole glyph displaying part. Please confirm that the desirable way is to
print the glyph (or replacement) instead of ignoring these characters, I'll
adjust the patch.


> >I hope you like it. :)
> 
> Please see above comments.

Rewording: I hope that after some discussion we'll come to a patch that you
like :-)))))


-- 
Egmont
