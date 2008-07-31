Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYGaMuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYGaMuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYGaMu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:50:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48186 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYGaMuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:50:25 -0400
Date: Thu, 31 Jul 2008 21:50:06 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Halesh <halesh.s@india.com>
Subject: Re: mlock() return value issue in kernel 2.6.23.17
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <loom.20080731T100441-892@post.gmane.org>
References: <loom.20080731T100441-892@post.gmane.org>
Message-Id: <20080731211811.3CA9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This testcase results with mlock failure with errno 14 that is EFAULT, but this 
> has been no where reported that mlock will give EFAULT, When i tested the same 
> on older kernel like 2.6.18, I got the correct result i.e errno 12 (ENOMEM).
> 
> 
> I think in source code mlock(2),  setting errno ENOMEM has been missed in 
> do_mlock() , on mlock_fixup() failure.
> 
> Let me know if my understanding is wrong!

Hi Halesh,

Could you try to following patch?

-----------------------------------------------------
SUSv3 require following behavior to mlock(2).

[ENOMEM]
    Some or all of the address range specified by the addr and
    len arguments does not correspond to valid mapped pages 
    in the address space of the process.

[EAGAIN]
    Some or all of the memory identified by the operation could not 
    be locked when the call was made. 


This rule isn't so nice and slighly strange.
but many people think POSIX/SUS compliance is important.


---
 mm/memory.c |   16 +++++++++++++---
 mm/mlock.c  |    2 --
 2 files changed, 13 insertions(+), 5 deletions(-)

Index: b/mm/memory.c
===================================================================
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2736,16 +2736,26 @@ int make_pages_present(unsigned long add
 
 	vma = find_vma(current->mm, addr);
 	if (!vma)
-		return -1;
+		return -ENOMEM;
 	write = (vma->vm_flags & VM_WRITE) != 0;
 	BUG_ON(addr >= end);
 	BUG_ON(end > vma->vm_end);
 	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
 	ret = get_user_pages(current, current->mm, addr,
 			len, write, 0, NULL, NULL);
-	if (ret < 0)
+	if (ret < 0) {
+		/*
+		   SUS require strange return value to mlock
+		    - invalid addr generate to ENOMEM.
+		    - out of memory should generate EAGAIN.
+		*/
+		if (ret == -EFAULT)
+			ret = -ENOMEM;
+		else if (ret == -ENOMEM)
+			ret = -EAGAIN;
 		return ret;
-	return ret == len ? 0 : -1;
+	}
+	return ret == len ? 0 : -ENOMEM;
 }
 
 #if !defined(__HAVE_ARCH_GATE_AREA)
Index: b/mm/mlock.c
===================================================================
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -78,8 +78,6 @@ success:
 
 	mm->locked_vm -= pages;
 out:
-	if (ret == -ENOMEM)
-		ret = -EAGAIN;
 	return ret;
 }
 


