Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbZJMPkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbZJMPkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759495AbZJMPkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:40:51 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40271 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbZJMPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:40:51 -0400
Date: Tue, 13 Oct 2009 11:39:42 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Greg Ungerer <gerg@snapgear.com>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v3 4/7] m68knommu: Use more macros inside the .init
 section.
In-Reply-To: <4AD4166C.5090306@snapgear.com>
Message-ID: <alpine.DEB.1.10.0910131131230.2868@dr-wily.mit.edu>
References: <4AD3BFD8.90408@snapgear.com> <1255397413-4862-1-git-send-email-tabbott@ksplice.com> <1255397413-4862-2-git-send-email-tabbott@ksplice.com> <1255397413-4862-3-git-send-email-tabbott@ksplice.com> <1255397413-4862-4-git-send-email-tabbott@ksplice.com>
 <1255397413-4862-5-git-send-email-tabbott@ksplice.com> <4AD4166C.5090306@snapgear.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Greg Ungerer wrote:

> Hi Tim,
> 
> Tim Abbott wrote:
> > Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> > ---
> >  arch/m68knommu/kernel/vmlinux.lds.S |   23 +++++------------------
> >  1 files changed, 5 insertions(+), 18 deletions(-)
> > 
> > diff --git a/arch/m68knommu/kernel/vmlinux.lds.S
> > b/arch/m68knommu/kernel/vmlinux.lds.S
> > index 153569b..f7df82a 100644
> > --- a/arch/m68knommu/kernel/vmlinux.lds.S
> > +++ b/arch/m68knommu/kernel/vmlinux.lds.S
> > @@ -161,25 +161,12 @@ SECTIONS {
> >  		INIT_TEXT
> >  		_einittext = .;
> >  		INIT_DATA
> > -		. = ALIGN(16);
> > -		__setup_start = .;
> > -		*(.init.setup)
> > -		__setup_end = .;
> > -		__initcall_start = .;
> > +		INIT_SETUP(16)
> > +		INIT_CALL
>                 ^^^^^^^^^^
> I take it this should be INIT_CALLS?

Oops, yes.  Also the INITCALLS on the following line should be deleted.  
So it should look like the below patch.

> With this patch applied the kernel no longer boots. All previous
> patches (so 1, 2 and 3) applied run fine.

Hopefully this is because we had INIT_CALLS followed by INITCALLS.  If it 
doesn't boot using the patch below instead, then that would be surprising 
to me.

	-Tim Abbott

m68knommu: Use more macros inside the .init section.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/m68knommu/kernel/vmlinux.lds.S |   24 +++++-------------------
 1 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index 153569b..ac7e785 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -161,25 +161,11 @@ SECTIONS {
 		INIT_TEXT
 		_einittext = .;
 		INIT_DATA
-		. = ALIGN(16);
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-		__security_initcall_start = .;
-		*(.security_initcall.init)
-		__security_initcall_end = .;
-#ifdef CONFIG_BLK_DEV_INITRD
-		. = ALIGN(4);
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-#endif
+		INIT_SETUP(16)
+		INIT_CALLS
+		CON_INITCALL
+		SECURITY_INITCALL
+		INIT_RAM_FS
 		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
 	} > INIT
-- 
1.6.4.3

