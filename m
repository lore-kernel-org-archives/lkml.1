Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbXLUQHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbXLUQHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXLUQH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:07:29 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:48707 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbXLUQH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:07:28 -0500
Date: Fri, 21 Dec 2007 17:07:18 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Yuusei KUWANA <kuwana@nyanyan.to>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, mikael.starvik@axis.com
Subject: Re: [PATCH] arch/cris/arch-v10/vmlinux.lds.S fix boot problem
Message-ID: <20071221160718.GO10888@axis.com>
References: <47636D45.6010006@nyanyan.to> <20071221151404.GM10888@axis.com> <20071221155446.GN10888@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221155446.GN10888@axis.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh. Not my day, hopefully this is the last revision of the patch.

Best regards,

/Jesper

diff --git a/arch/cris/arch-v10/vmlinux.lds.S b/arch/cris/arch-v10/vmlinux.lds.S
index 9859d49..2afe1bd 100644
--- a/arch/cris/arch-v10/vmlinux.lds.S
+++ b/arch/cris/arch-v10/vmlinux.lds.S
@@ -23,7 +23,7 @@ SECTIONS
 	_stext = .;
 	__stext = .;
 	.text : {
-		*(.text)
+		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
 		*(.fixup)
@@ -66,13 +66,7 @@ SECTIONS
   	__setup_end = .;
   	.initcall.init : {
 		__initcall_start = .;
-		*(.initcall1.init);
-		*(.initcall2.init);
-		*(.initcall3.init);
-		*(.initcall4.init);
-		*(.initcall5.init);
-		*(.initcall6.init);
-		*(.initcall7.init);
+		INITCALLS
 		__initcall_end = .;	
 	}
 
@@ -88,16 +82,21 @@ SECTIONS
 		__initramfs_start = .;
 		*(.init.ramfs)
 		__initramfs_end = .;
-		/* We fill to the next page, so we can discard all init
-		   pages without needing to consider what payload might be
-		   appended to the kernel image.  */
-		FILL (0); 
-		. = ALIGN (8192);
 	}
 #endif
-	
 	__vmlinux_end = .;            /* last address of the physical file */
-  	__init_end = .;
+
+	/*
+	 * We fill to the next page, so we can discard all init
+	 * pages without needing to consider what payload might be
+	 * appended to the kernel image.
+	 */
+	.init.fill : {
+		FILL (0);
+		. = ALIGN (8192);
+	}
+
+	__init_end = .;
 
 	__data_end = . ;              /* Move to _edata ? */
 	__bss_start = .;              /* BSS */

> On Fri, Dec 21, 2007 at 04:14:04PM +0100, Jesper Nilsson wrote:
> > 
> > On Sat, Dec 15, 2007 at 02:59:33PM +0900, Yuusei KUWANA wrote:
> > > arch/cris/arch-v10/vmlinux.lds.S
> > >  fix boot problem
> > > * too old initcall style. replace INITCALLS macro
> > > * __init_begin, __init_end move for free_initmem()
> > 
> > Hi,
> > 
> > The conversion to INITCALLS is ok (I have the same change here),
> > but I'm curious what problem you are solving with moving __init_begin and
> > __init_end to only include the .init.data.
> > 
> > If there is use of initcalls/data outside init then that is a bug and
> > should be fixed, not worked around.
> > 
> > There might however be another problem that Mikael Starvik told me about,
> > the padding between initdata and the next section had gone AWOL,
> > which made the free_initmem() destroy useful data.
> > 
> > With the attached patch (and a lot of other patches) I am successful in
> > booting an Axis Devboard82+.
> > Could you please try the included patch and see if that solves your problem?
> > 
> > > Note: with this patch kernel boot and mount root,
> > > but after init done,  kernel panic at do_signal() ...
> > 
> > I have a patch in the pipe that should fix this, will send it in just
> > a small while.
> > 
> > > ryu
> > 
> > Thank you for your help!
> > 
> > Best regards,
> > 
> > /Jesper
> 
> /^JN - Jesper Nilsson
> --
>                Jesper Nilsson -- jesper.nilsson@axis.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
