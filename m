Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbZGHPwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbZGHPwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 11:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbZGHPvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 11:51:55 -0400
Received: from mail-px0-f181.google.com ([209.85.216.181]:50229 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbZGHPvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 11:51:55 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2009 11:51:55 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=I9/u7SIPN8luZKDEtvL53h+gLIS6K2L5+qrm0taZngmCRvyzG5m+fA9wFVAJGGC7nr
         j9w0ZdmHNQhB1T7wecwgXDGZEIvcaZNUwEAkfYS3W1OVedGt5BSRDDlT0+79s/lt369h
         GAA7EloZslUWhXJyT7mouCcs/cse7CbvHDL+w=
Date: Wed, 8 Jul 2009 11:46:02 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: Amerigo Wang <xiyou.wangcong@gmail.com>
cc: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       teawater@gmail.com, mingo@elte.hu, tj@kernel.org
Subject: Re: [PATCH] elfcore.h : Fix UML build breakage
In-Reply-To: <20090708043036.GA5917@cr0.nay.redhat.com>
Message-ID: <alpine.DEB.2.00.0907081141500.4155@parag-desktop>
References: <alpine.DEB.2.00.0907072226140.24195@parag-desktop> <20090708043036.GA5917@cr0.nay.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-239073423-1247067972=:4155"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-239073423-1247067972=:4155
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Wed, 8 Jul 2009, Amerigo Wang wrote:

> On Tue, Jul 07, 2009 at 10:41:50PM -0400, Parag Warudkar wrote:
> >Commit a65e7bfcd74e4c0939f235d2bf9f48ddb3a57991 breaks UML build with 
> >below error - 
> >
> >In file included from fs/proc/kcore.c:17:
> >include/linux/elfcore.h: In function ‘elf_core_copy_task_regs’:
> >include/linux/elfcore.h:129: error: implicit declaration of function 
> >‘task_pt_regs’
> >
> >Fix this by restoring the previous behavior of returning 0 for all arches 
> >like UML that don't define task_pt_regs.

> #elif defined doesn't match #ifdef well, how about:
> 
> #if defined (ELF_CORE_COPY_TASK_REGS)
> ...
> #elif defined (task_pt_regs)
> ...
> #endif

Updated patch below -

Fix UML build breakage due to commit 
a65e7bfcd74e4c0939f235d2bf9f48ddb3a57991.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 03ec167..00d6a68 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -122,10 +122,9 @@ static inline void elf_core_copy_kernel_regs(elf_gregset_t *elfregs, struct pt_r
 
 static inline int elf_core_copy_task_regs(struct task_struct *t, elf_gregset_t* elfregs)
 {
-#ifdef ELF_CORE_COPY_TASK_REGS
-	
+#if defined (ELF_CORE_COPY_TASK_REGS)
 	return ELF_CORE_COPY_TASK_REGS(t, elfregs);
-#else
+#elif defined (task_pt_regs)
 	elf_core_copy_regs(elfregs, task_pt_regs(t));
 #endif
 	return 0;
--8323329-239073423-1247067972=:4155--
