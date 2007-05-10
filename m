Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXEJDSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXEJDSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 23:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbXEJDSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 23:18:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:58739 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbXEJDSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 23:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QEMrFmSyD4MAznt7PjFlwIA9Vw33H7rO97Zt3mgJofiEqnpmGAVLeWCbF1qTq6ILF5ibKUYaCmd4Tg39w/MbFdm1jwPjmYjngQ+JeKyGXnC32vngCoEYaYiC2KnTk7k/fcRIQzUZDkEp7jhtfBhlK0n5xDBLlFWCiJ/Y6YirCpg=
Message-ID: <a781481a0705092018v489b712dxa377aeb502b66fef@mail.gmail.com>
Date: Thu, 10 May 2007 08:48:35 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Sripathi Kodi" <sripathik@in.ibm.com>
Subject: Re: [PATCH 1/2] Introduce write_trylock_irqsave
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <200705091411.54774.sripathik@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705091411.54774.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Sripathi Kodi <sripathik@in.ibm.com> wrote:
> Hi,
>
> I am trying to fix the BUG I mentioned here:
> http://lkml.org/lkml/2007/04/20/41. I noticed that an elegant way to solve
> this problem is to have a write_trylock_irqsave helper function. Since we
> don't have this now, the code in ptrace_attach  implements it using
> local_irq_disable and write_trylock. I wish to add write_trylock_irqsave to
> mainline kernel and then fix the -rt specific problem using this.
>
> The patch below adds write_trylock_irqsave function.

Why not implement this as follows? That way we're able to (1) be
consistent in style with spin_trylock_irqsave, (2) type fewer lines,
(3) touch fewer files, and (4) not add extra bulk to kernel text size
either.

For the sake of completeness of the API, we could also add a
read_trylock_irqsave, but I'd be against the _irq variants (or should
we call them hazards) that don't save / restore.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

---

 include/linux/spinlock.h |    7 +++++++
 1 file changed, 7 insertions(+)

---

diff -ruNp a/include/linux/spinlock.h b/include/linux/spinlock.h
--- a/include/linux/spinlock.h	2007-04-26 08:38:32.000000000 +0530
+++ b/include/linux/spinlock.h	2007-05-10 08:43:32.000000000 +0530
@@ -282,6 +282,13 @@ do {						\
 	1 : ({ local_irq_restore(flags); 0; }); \
 })

+#define write_trylock_irqsave(lock, flags) \
+({ \
+	local_irq_save(flags); \
+	write_trylock(lock) ? \
+	1 : ({ local_irq_restore(flags); 0; }); \
+})
+
 /*
  * Locks two spinlocks l1 and l2.
  * l1_first indicates if spinlock l1 should be taken first.
