Return-Path: <linux-kernel-owner+w=401wt.eu-S1161022AbXBPOju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161022AbXBPOju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964945AbXBPOju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:39:50 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:8580 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932AbXBPOjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:39:49 -0500
Date: Fri, 16 Feb 2007 06:39:45 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
In-reply-to: <20070215230243.515ec6b3.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Tobias Hain <tobias.hain@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <Pine.LNX.4.64.0702160500210.31650@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
 <20070215205658.56096f97.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702152134190.12571@montezuma.fsmlabs.com>
 <20070215214506.f795acc4.akpm@linux-foundation.org>
 <20070215215125.9161e3dc.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702152158210.12571@montezuma.fsmlabs.com>
 <20070215230243.515ec6b3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Andrew Morton wrote:

> It's not an X problem - the screen is black immediately upon loading the
> kernel.
> 
> But I guess you knew that and you're just after display info:
> http://userweb.kernel.org/~akpm/Xorg.0.log.txt

Thanks, the X log told me your VBE version. I tried to reproduce it on my 
thinkpad which seems to have a very similar video setup to no avail, Could 
you test the following on the VAIO? If this isn't the case, i suspect i'm 
corrupting your modelist.

P.s. Thanks for the vga=0x263!

Index: linux-2.6.20-mm1/arch/i386/boot/video.S
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-mm1/arch/i386/boot/video.S,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 video.S
--- linux-2.6.20-mm1/arch/i386/boot/video.S	15 Feb 2007 17:35:57 -0000	1.1.1.1
+++ linux-2.6.20-mm1/arch/i386/boot/video.S	16 Feb 2007 12:58:20 -0000
@@ -1945,6 +1945,25 @@ store_edid:
 	rep
 	stosl
 
+	pushw	%es
+	pushw	%ds
+	popw	%es
+	leaw	modelist+1024, %di
+	movw    $0x02b3, %ax
+	movw    %ax, (%di)
+	movw    $0x9d4a, %ax
+	movw    %ax, 2(%di)                     # set signature to "vbe2"
+
+	movw	$0x4f00, %ax
+	int	$0x10
+	popw	%es
+
+	cmpw	$0x004f, %ax
+	jne	no_edid
+
+	cmpw	$0x0200, 4(%di)			# only do EDID on >= VBE2.0
+	jl	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
Index: linux-2.6.20-mm1/arch/x86_64/boot/video.S
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-mm1/arch/x86_64/boot/video.S,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 video.S
--- linux-2.6.20-mm1/arch/x86_64/boot/video.S	15 Feb 2007 17:36:18 -0000	1.1.1.1
+++ linux-2.6.20-mm1/arch/x86_64/boot/video.S	16 Feb 2007 12:57:57 -0000
@@ -1945,6 +1945,25 @@ store_edid:
 	rep
 	stosl
 
+	pushw	%es
+	pushw	%ds
+	popw	%es
+	leaw	modelist+1024, %di
+	movw    $0x02b3, %ax
+	movw    %ax, (%di)
+	movw    $0x9d4a, %ax
+	movw    %ax, 2(%di)                     # set signature to "vbe2"
+
+	movw	$0x4f00, %ax
+	int	$0x10
+	popw	%es
+
+	cmpw	$0x004f, %ax
+	jne	no_edid
+
+	cmpw	$0x0200, 4(%di)			# only do EDID on >= VBE2.0
+	jl	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
