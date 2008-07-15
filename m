Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbYGOIJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbYGOIJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYGOIJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:09:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:42359 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYGOIJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=j8Mr8LneUV/B+cVmNEj+pf0FpL7Q4sLERBHXenGkk0UR81B8pMW7A01gV6wFWRR2GG
         kjgA/Or5PMT/3h1RWZxZNUajnWeQR6hrUeEOYkjX7AMpcWjL3/veVaklZ0sj8LUsRYGK
         /3ddfzgo7PiQ6iEbLTQA1999NQYxmWxMCxDzU=
Date: Tue, 15 Jul 2008 17:09:03 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] intel_cacheinfo: fix use-after-free cache_kobject
Message-ID: <20080715080903.GA22068@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids calling kobject_uevent() with cache_kobject that has
already been deallocated in an error path.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: 2.6-mmotm/arch/x86/kernel/cpu/intel_cacheinfo.c
===================================================================
--- 2.6-mmotm.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ 2.6-mmotm/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -780,15 +780,14 @@ static int __cpuinit cache_add_dev(struc
 			}
 			kobject_put(per_cpu(cache_kobject, cpu));
 			cpuid4_cache_sysfs_exit(cpu);
-			break;
+			return retval;
 		}
 		kobject_uevent(&(this_object->kobj), KOBJ_ADD);
 	}
-	if (!retval)
-		cpu_set(cpu, cache_dev_map);
+	cpu_set(cpu, cache_dev_map);
 
 	kobject_uevent(per_cpu(cache_kobject, cpu), KOBJ_ADD);
-	return retval;
+	return 0;
 }
 
 static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
