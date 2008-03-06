Return-Path: <linux-kernel-owner+w=401wt.eu-S1762464AbYCFKYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762464AbYCFKYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761149AbYCFKYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:24:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38701 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761000AbYCFKYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:24:22 -0500
Date: Thu, 6 Mar 2008 11:24:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-boot: don't request VBE2 information
Message-ID: <20080306102403.GC13391@elte.hu>
References: <1204797405-18059-1-git-send-email-jacmet@sunsite.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204797405-18059-1-git-send-email-jacmet@sunsite.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Korsgaard <jacmet@sunsite.dk> wrote:

> The new x86 setup code (4fd06960f120) broke booting on an old 
> P3/500MHz with an onboard Voodoo3 of mine. After debugging it, it 
> turned out to be caused by the fact that the vesa probing now asks for 
> VBE2 data.
> 
> Disassembing the video BIOS shows that it overflows the 
> vesa_general_info structure when VBE2 data is requested because the 
> source addresses for the information strings which get strcpy'ed to 
> the buffer lie outside the 32K BIOS code (and hence contain long 
> sequences of 0xff's).
> 
> E.G.:
> 
> get_vbe_controller_info:
> 00002A9C  60                pushaw
> 00002A9D  1E                push ds
> 00002A9E  0E                push cs
> 00002A9F  1F                pop ds
> 00002AA0  2BC9              sub cx,cx
> 00002AA2  6626813D56424532  cmp dword [es:di],0x32454256 ; "VBE2"
> 00002AAA  7501              jnz .1
> 00002AAC  41                inc cx
> .1:
> 00002AAD  51                push cx
> 00002AAE  B91400            mov cx,0x14
> 00002AB1  BED47F            mov si, controller_header
> 00002AB4  57                push di
> 00002AB5  F3A4              rep movsb ; copy vbe1.2 header
> 
> 00002AB7  B9EC00            mov cx,0xec
> 00002ABA  2AC0              sub al,al
> 00002ABC  F3AA              rep stosb ; zero pad remainder
> 
> 00002ABE  5F                pop di
> 00002ABF  E8EB0D            call word get_memory
> 00002AC2  C1E002            shl ax,0x2
> 00002AC5  26894512          mov [es:di+0x12],ax ; total memory
> 00002AC9  26C745040003      mov word [es:di+0x4],0x300 ; VBE version
> 00002ACF  268C4D08          mov [es:di+0x8],cs
> 00002AD3  268C4D10          mov [es:di+0x10],cs
> 00002AD7  59                pop cx
> 00002AD8  E361              jcxz .done ; VBE2 requested?
> 00002ADA  8D9D0001          lea bx,[di+0x100]
> 00002ADE  53                push bx
> 00002ADF  87DF              xchg bx,di ; di now points to 2nd half
> 00002AE1  26C747140001      mov word [es:bx+0x14],0x100 ; sw rev
> 
> 00002AE7  26897F06          mov [es:bx+0x6],di		; oem string
> 00002AEB  268C4708          mov [es:bx+0x8],es
> 00002AEF  BE5280            mov si,0x8052 ; oem string
> 00002AF2  E87A1B            call word strcpy
> 
> 00002AF5  26897F0E          mov [es:bx+0xe],di ; video mode list
> 00002AF9  268C4710          mov [es:bx+0x10],es
> 00002AFD  B91E00            mov cx,0x1e
> 00002B00  BEE87F            mov si,vidmodes
> 00002B03  F3A5              rep movsw
> 
> 00002B05  26897F16          mov [es:bx+0x16],di ; oem vendor
> 00002B09  268C4718          mov [es:bx+0x18],es
> 00002B0D  BE2480            mov si,0x8024 ; oem vendor
> 00002B10  E85C1B            call word strcpy
> 
> 00002B13  26897F1A          mov [es:bx+0x1a],di ; oem product
> 00002B17  268C471C          mov [es:bx+0x1c],es
> 00002B1B  BE3880            mov si,0x8038 ; oem product
> 00002B1E  E84E1B            call word strcpy
> 
> 00002B21  26897F1E          mov [es:bx+0x1e],di ; oem product rev
> 00002B25  268C4720          mov [es:bx+0x20],es
> 00002B29  BE4580            mov si,0x8045 ; oem product rev
> 00002B2C  E8401B            call word strcpy
> 
> 00002B2F  58                pop ax
> 00002B30  B90001            mov cx,0x100
> 00002B33  2BCF              sub cx,di
> 00002B35  03C8              add cx,ax
> 00002B37  2AC0              sub al,al
> 00002B39  F3AA              rep stosb ; zero pad
> .done:
> 00002B3B  1F                pop ds
> 00002B3C  61                popaw
> 00002B3D  B84F00            mov ax,0x4f
> 00002B40  C3                ret
> 
> (The full BIOS can be found at http://peter.korsgaard.com/vgabios.bin
> if interested).
> 
> The old setup code didn't ask for VBE2 info, and the new code doesn't 
> actually do anything with the extra information, so the fix is to 
> simply not request it. Other BIOS'es might have the same problem.

thanks Peter, very nice debugging! I've applied your fix.

	Ingo
