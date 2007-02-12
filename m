Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXBLDmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXBLDmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932954AbXBLDmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:42:24 -0500
Received: from ozlabs.org ([203.10.76.45]:50944 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950AbXBLDmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:42:23 -0500
Subject: [PATCH 1/2] lguest preparation: EXPORT_SYMBOL_GPL 5 functions
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <1171251578.10409.17.camel@localhost.localdomain>
References: <1171251120.10409.2.camel@localhost.localdomain>
	 <1171251185.10409.4.camel@localhost.localdomain>
	 <1171251258.10409.7.camel@localhost.localdomain>
	 <1171251335.10409.10.camel@localhost.localdomain>
	 <1171251406.10409.13.camel@localhost.localdomain>
	 <1171251471.10409.15.camel@localhost.localdomain>
	 <1171251578.10409.17.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:41:38 +1100
Message-Id: <1171251698.10409.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lguest does some fairly lowlevel things to support a host, which
normal modules don't need:

math_state_restore:
	When the guest triggers a Device Not Available fault, we need
	to be able to restore the FPU

__put_task_struct:
	We need to hold a reference to another task for inter-guest
	I/O, and put_task_struct() is an inline function which calls
	__put_task_struct.

access_process_vm:
	We need to access another task for inter-guest I/O.

map_vm_area & __get_vm_area:
	We need to map the switcher shim (ie. monitor) at 0xFFC01000.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

===================================================================
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -1054,6 +1054,7 @@ asmlinkage void math_state_restore(void)
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
+EXPORT_SYMBOL_GPL(math_state_restore);
 
 #ifndef CONFIG_MATH_EMULATION
 
===================================================================
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -126,6 +126,7 @@ void __put_task_struct(struct task_struc
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
+EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init fork_init(unsigned long mempages)
 {
===================================================================
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2692,3 +2692,4 @@ int access_process_vm(struct task_struct
 
 	return buf - old_buf;
 }
+EXPORT_SYMBOL_GPL(access_process_vm);
===================================================================
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -159,6 +159,7 @@ int map_vm_area(struct vm_struct *area, 
 	flush_cache_vmap((unsigned long) area->addr, end);
 	return err;
 }
+EXPORT_SYMBOL_GPL(map_vm_area);
 
 static struct vm_struct *__get_vm_area_node(unsigned long size, unsigned long flags,
 					    unsigned long start, unsigned long end,
@@ -237,6 +238,7 @@ struct vm_struct *__get_vm_area(unsigned
 {
 	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL);
 }
+EXPORT_SYMBOL_GPL(__get_vm_area);
 
 /**
  *	get_vm_area  -  reserve a contingous kernel virtual area


