Return-Path: <linux-kernel-owner+w=401wt.eu-S965764AbXDGLCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965764AbXDGLCf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 07:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965791AbXDGLCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 07:02:35 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:37740 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965764AbXDGLCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 07:02:33 -0400
Date: Sat, 7 Apr 2007 13:00:48 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Egmont Koblinger <egmont@uhulinux.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
In-Reply-To: <20070407092451.GA8779@uhulinux.hu>
Message-ID: <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr>
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com>
 <20070407092451.GA8779@uhulinux.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I just wanted to give my opinion on things...

(and enable utf8 to read this properly)

On Apr 7 2007 11:24, Egmont Koblinger wrote:
>
>> I strongly disagree.  First of all, you're changing the semantics of a 
>> 13-year-old API.  The semantics of the Linux console is that by 
>> specifying U+FFFD SUBSTITUTION GLYPH in your unicode table, you have 
>> specified the fallback glyph.
>
>OK, I'm not against using U+FFFD for missing glyphs. In the mean time I
>think it's still a good idea to clearly separate the two cases in the code
>(that is, the case of invalid sequence from the case of missing glyph), but
>we can still use the same replacement character in these two cases. I'll
>send an updated patch after Easter if it sounds good for you.

I am quite ok with the way things are right now.

 - vc displays <?> for illegal sequences

 - vc displays e.g. "U" (latin capital U) in place when Û (latin capital
   U with accent circumflex) is not available in this font 
   (determined by the unicodemap) (I do use an unicode map, because I
   use a 4096-byte cp437 "DOS" font which requires one)

 - vc displays <?> for sequences it does not know how to print

 - xterm displays <?> for illegal sequences

 - xterm seems to display <?> on undefined glyphs (U+DFFF for ex.,
   using the "Unicode Best" font from the xterm menu)

 - xterm seems to display nothing on undefined glyphs (U+E000 for ex.,
   "Unicode Best" again)

>> What's worse, you've hard-coded the uses of specific visual 
>> representations.  That is completely unacceptable.
>
>Now that we've dropped the idea of "dot" for missing glyphs, the other thing
>
>[...]
>
>Sorry, I wasn't clear enough and I think you misunderstood me. The symbol I
>choose for fallback is still '?' (the ASCII question mark), I just invert
>the color attributes of the cell where this is printed. This way it becomes
>visually distinguisable from the literal question mark. Using the current
>kernel you just cannot know whether the character printed is a real question
>mark, or a replacement glyph. Still, should you stongly disagree with this
>decision, the color inverting part can easily be removed.

Please, no dot, and no inverse color.
Imagine someone had the following bitmap for <unknown glyph/illegal sequence>:

################
################
################
####........####
##....####....##
##....####....##
########....####
######....######
######....######
################
######....######
######....######
################
################
################
################

Then inverting that again would be susceptible to confusion with
the regular '?' at 0x3F. 

(cp437 for example maps unknown/illegal to 0xFD which happens to be the
block graphic '■', but YMMV depending on font.)

>I think I've (mostly) described it above. Set everything to UTF-8, load a
>latin2 font (containing 256 glyphs, e.g. "setfont lat2-16"), make an
>application print U+00FB (alt + numpad 251 is one trivial way), you'll see
>an "u with double accent", though the symbol to be displayed is "u with
>circumflex". This isn't present in the current font, so the replacement
>character should appear, not a different letter.

I blame your latin2 unicode map. (See above about 'Û'.)
It should perhaps display a regular 'u' if it cannot display 'û',
but definitely not 'ü' (which is not called a double accent, btw).

>> To be able to do CJK you need something like Kon anyway.  This feels 
>> like bloat.
>
>I don't want CJK support. All that I want is to be able to edit English
>words within a file that contains mixture of English and CJK, with a text
>editor like vim or joe.

+1 for this one :)

xterm## echo "韓国と日本にようこそ!" >/tmp/foobar.txt
vc## cat foobar.txt

currently gets things not so right, because multibyte characters are not
displayed with as many <?> as they are wide.


Jan
-- 
