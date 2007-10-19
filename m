Return-Path: <linux-kernel-owner+w=401wt.eu-S1763597AbXJSHrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763597AbXJSHrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934741AbXJSHrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:47:25 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:11340 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934717AbXJSHrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:47:22 -0400
Subject: Re: 2.6.23-mm1 s390 driver problem
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       cornelia.huck@de.ibm.com, heiko.carstens@de.ibm.com, sam@ravnborg.org
In-Reply-To: <20071018203151.GA15382@vino.hallyn.com>
References: <20071018200148.GA14234@vino.hallyn.com>
	 <200710182215.56428.borntraeger@de.ibm.com>
	 <20071018203151.GA15382@vino.hallyn.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 19 Oct 2007 09:47:16 +0200
Message-Id: <1192780036.25150.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-18 at 15:31 -0500, Serge E. Hallyn wrote:
> Quoting Christian Borntraeger (borntraeger@de.ibm.com):
> > Am Donnerstag, 18. Oktober 2007 schrieb Serge E. Hallyn:
> > > Sigh, well this turned out less informative than I'd liked.
> > > After bisecting 2.6.23 to 2.6.23-mm1, I found that
> > > git-s390.patch is the one breaking my s390 boot :(
> > > (Frown bc it's a conglomeration of patches0
> > > 
> > > Symptom is:
> > > 	"Cannot open root device "dasdd2" or unknown-block(94,14)"
> > > even though dasdd2 appeared to be found earlier in the boot.  I also
> > > get
> > 
> > Can you post the full console output from IPL to the unsuccessful end?
> 
> Yeah, sorry, appended below.
> 
> I had thought that the line
> 	sysctl table check failed: /sunrpc/transports .7249.14 Missing strategy
> meant that the fix referenced in http://lkml.org/lkml/2007/10/11/48
> would fix it, but it appeared to have no effect.

This is the vmlinux.lds.S problem. The cleanup patch from Sam Ravnborg
moved the __initramfs_start and __initramfs_end symbols into
the .init.ramfs section. This is in itself not a problem, but it
surfaced a bug: there is no *(.init.initramfs), that needs to be
*(init.ramfs). I corrected this in the upstream patch but 2.6.23-mm1 has
the older one that still causes the "Cannot open root device". For
2.6.23-mm1 use the patch below.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.

---
diff -urpN linux-2.6/arch/s390/kernel/vmlinux.lds.S linux-2.6-patched/arch/s390/kernel/vmlinux.lds.S
--- linux-2.6/arch/s390/kernel/vmlinux.lds.S	2007-10-19 09:41:57.000000000 +0200
+++ linux-2.6-patched/arch/s390/kernel/vmlinux.lds.S	2007-10-19 09:42:29.000000000 +0200
@@ -128,7 +128,7 @@ SECTIONS
 	. = ALIGN(0x100);
 	.init.ramfs : {
 		__initramfs_start = .;
-		*(.init.initramfs)
+		*(.init.ramfs)
 		. = ALIGN(2);
 		__initramfs_end = .;
 	}


