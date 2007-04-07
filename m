Return-Path: <linux-kernel-owner+w=401wt.eu-S966219AbXDGR7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966219AbXDGR7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966221AbXDGR7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:59:30 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966219AbXDGR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:59:29 -0400
Message-ID: <4617DBF7.5060009@zytor.com>
Date: Sat, 07 Apr 2007 10:59:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Egmont Koblinger <egmont@uhulinux.hu>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com> <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr> <20070407172603.GA25351@uhulinux.hu>
In-Reply-To: <20070407172603.GA25351@uhulinux.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Egmont Koblinger wrote:
> On Sat, Apr 07, 2007 at 01:00:48PM +0200, Jan Engelhardt wrote:
> 
> Hi,
> 
>> Please, no dot, and no inverse color.
>> Imagine someone had the following bitmap for <unknown glyph/illegal sequence>:
> 
> No dot, I'm already convinced. To clarify the inverse thingy:
> 
> This is what the current kernel does:
>   1) tries to display the desired symbol
>   2) if it fails, tries to display U+FFFD (which usually looks similar to an
>      inverted question mark)
>   3) if this fails again then displays a normal '?'
>      (or a different symbol due to a bug discussed below)
> 
> Here's my proposal. This only alters the 3rd step, not the first two:
>   1) tries to display the desired symbol
>   2) if it fails, tries to display U+FFFD, still with _normal_ attributes
>   3) if this fails then display an ascii '?' with inverted attributes
> 
> So you won't get "double" inversion. If you do have U+FFFD in your font then
> this will introduce no chance. If you don't have U+FFFD, you'll see inverse
> question marks instead of normal ones.
> 

This seems fine.

> 
>> I blame your latin2 unicode map. (See above about 'Û'.)
> 
> There's nothing wrong with my latin2 unicode map, and I've located and
> changed the part _in the kernel_ that displays a false glyph using the
> algorithm I've outlined. It just uses "the glyph at that code position
> within the glyph table" as a fallback, which might be okay in 8-bit mode
> (and I haven't modified the behavior in that case), but I got rid of this
> behavior in UTF-8 mode since it's definitely a fault in the world of
> Unicode.
> 
>> It should perhaps display a regular 'u' if it cannot display 'û',
> 
> I rather think it should display U+FFFD but YMMV.

That's a policy decision for the maker of the Unicode map.  The kernel 
cannot by default know that a pre-composed ű is a modified u; obviously, 
if the ű is send in decomposed form the kernel probably will display it 
as u? or some such.

>> but definitely not 'ü' (which is not called a double accent, btw).
> 
> This is not the character I've been talking about, I actually _did_ talk
> about u with double acute accent (ű - you might not have seen this character
> so far, AFAIK it's only used in Hungarian, no other languages). But we agree
> that the kernel definitely shouldn't display a character with a different
> accent on it. This is one of the bugs my patch addresses.

As far as width handling -- in order to make all the text line up under 
all circumstances you need more than width handling.  The wcwidth() 
stuff is specific to CJK -- a character set which is totally implausible 
to display on the builtin console.  You also need bidir support (in case 
you encounter Hebrew or Arabic), you need Indic shape handling (Indic 
langauges have some *very* odd composing rules), etc, and this is just 
to know how much space to take up on the screen.

is is ridiculous.  It's much better to draw a line in the sand and say 
that this is beyond the scope of the in-kernel Linux console.

	-hpa

