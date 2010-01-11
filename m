Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197Ab0AKUIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0AKUIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143Ab0AKUIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:08:14 -0500
Received: from mailout-venus.uni-duesseldorf.de ([134.99.128.32]:48131 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754045Ab0AKUIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:08:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 11 Jan 2010 21:08:07 +0100 (CET)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: "m68k: Cleanup linker scripts using new linker script macros." and
 old binutils (was: Re: [PATCH] m68k: Atari EtherNAT - Nicolas Pitre has a new
 email address)
In-reply-to: <m2wrzpk81j.fsf@igel.home>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <alpine.DEB.2.00.1001112040120.31572@zirkon.biophys.uni-duesseldorf.de>
References: <10f740e81001100128q644cae1eg61c12b64f22e8398@mail.gmail.com>
 <alpine.DEB.1.10.1001101100540.1326@dr-wily.mit.edu>
 <alpine.DEB.2.00.1001102020420.19754@zirkon.biophys.uni-duesseldorf.de>
 <m2wrzpk81j.fsf@igel.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

> > FWIW: when stripping the new kernel, I get this warning:
> >
> > BFD: st7CwWnM: warning: allocated section `.init_end' not in segment
> 
> This is actually your problem.  The .init_end section is kind of special
> because it only contains an ALIGN.  What do you get from running
> "readelf -l vmlinux"?

Followup on this: You are absolutely right - the problem appears to be related 
to the the .init_end section _only_ having the ALIGN, and nothing else (i.e. 
no actual section content). 

Placing the align in the .m68k_fixup section like such:

--- arch/m68k/kernel/vmlinux-std.lds.org	2010-01-09 11:01:05.000000000 
+1300
+++ arch/m68k/kernel/vmlinux-std.lds	2010-01-12 08:43:07.000000000 +1300
@@ -42,6 +42,7 @@
 	__start_fixup = .;
 	*(.m68k_fixup)
 	__stop_fixup = .;
+        . = ALIGN(PAGE_SIZE);
   }
   NOTES
   .init_end : {

still puts .init_end, __init_end and _end on a page boundary, but also extends
the load section up to that page boundary. (Unfortunately, it also extends the 
kernel file size by a bit). 

Can the same be achieved in a more elegant way? The reason why the old script 
worked with my binutils appears to be the placement of the initramfs data right 
at the end - the start of initramfs is page aligned, and the size of the 
initramfs is an integer number of pages, so the end of initramfs data, 
__init_end and _end all are on a page boundary. With the fixup section now 
placed after the initramfs explicitly, this no longer happens by accident...

Cheers,

	Michael


