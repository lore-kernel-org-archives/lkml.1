Return-Path: <linux-kernel-owner+w=401wt.eu-S1762129AbXGPNb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129AbXGPNb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXGPNbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:31:47 -0400
Received: from web26915.mail.ukl.yahoo.com ([217.146.177.82]:23491 "HELO
	web26915.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756869AbXGPNbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:31:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=VtG/oo8WLegeFcFo5DgbhUAeLDN59yTKQLSOmL/ZFEQpu3E0L7R7/sYisHbeNNTlhDfN/kSPq5suXvJmdPvs+vfjD3Mj+dZNCA/MLMveTNSKsv84EPlVAgHfWifyZj5NNX8pKwPIzk+sW7MccdBokaF1CRd3SlwsNNRTP6aWbvg=;
X-YMail-OSG: VJsVJtEVM1ma3c83T2S8pxNRE.ulR9wH5rOd8m5UGVW0AaKHbUPgALLU7Jull0mDG0QedoLTrM_lMfFk3jN.vfVLurX2dGZ6hVjS6BwU68xrPjxe.0dy48c-
Date: Mon, 16 Jul 2007 15:31:44 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: x86 setup code rewrite in C - revised
To: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4697FB6D.9060700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <739046.56993.qm@web26915.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- "H. Peter Anvin" <hpa@zytor.com> wrote:
> >>  - The VGA recalc has the same bug as the assembly version where a VGA
> >> write protected register is written (Overflow register) without setting
> >> the enable bit (see VGA docs).
> 
> I dug into this, and it turns out you're incorrect.  Both the assembly
> code and the C code are, in fact, 100% correct:
> 
> The only instance of writing the vertical overflow register is this code
> in vga_set_480_scanlines():
> 
> 	out_idx(0x0c, crtc, 0x11); /* Vertical sync end, unlock CR0-7 */
> 	out_idx(0x0b, crtc, 0x06); /* Vertical total */
> 	out_idx(0x3e, crtc, 0x07); /* Vertical overflow */
> 	out_idx(0xea, crtc, 0x10); /* Vertical sync start */
> 	out_idx(end,  crtc, 0x12); /* Vertical display end */
> 	out_idx(0xe7, crtc, 0x15); /* Vertical blank start */
> 	out_idx(0x04, crtc, 0x16); /* Vertical blank end */
> 
> Register 0x11 has the Protect (not enable!) bit in it, it is bit 7.  As
> you can see, it is cleared (meaning writable) at the beginning of this
> sequence, and the fact that it's being done is even documented.

  The only time I ever needed this "end line recalculation" was when the heigh in
 graphic lines was not a multiple of the character heigh - i.e. 640x350 with 8x16
 or 8x8 chars - some VGA adapters do not hide the bottom graphic lines.
  The function vga_set_480_scanlines() is not called, and the protect bit is never
 cleared - the video BIOS leaving those low index register protected.
  The function vga_recalc_vertical() (or its assembler equivalent) is probably
 perfectly called but because the protect bit is never cleared, the few graphic
 line are displayed during the whole Linux text session...
  I have myself never seen any other problems when the graphic heigh is a multiple
 of the character heigh - tested on ~40 video boards.

  Etienne.




	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
