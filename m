Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbXAXRYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbXAXRYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 12:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXAXRYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 12:24:49 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:40257 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbXAXRYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 12:24:48 -0500
Date: Wed, 24 Jan 2007 12:24:45 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Richard J Moore <richardj_moore@uk.ibm.com>,
       linux-kernel@vger.kernel.org, "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>,
       Douglas Niehaus <niehaus@eecs.ku.edu>, Ingo Molnar <mingo@redhat.com>,
       ltt-dev@shafik.org, systemtap@sources.redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] order of lockdep off/on in vprintk() should be changed
Message-ID: <20070124172445.GA1145@Krystal>
References: <20061220235216.GA28643@Krystal> <OFAB3D8A6C.1643F2D3-ON80257262.000581E4-80257262.00088F04@uk.ibm.com> <20070116175624.GA16022@Krystal> <20070123202637.970e467b.akpm@osdl.org> <20070124165150.GC4979@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070124165150.GC4979@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 12:16:56 up 154 days, 14:24,  4 users,  load average: 0.70, 0.74, 0.74
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The order of locking between lockdep_off/on() and local_irq_save/restore() in
vprintk() should be changed.
  
* In kernel/printk.c :

vprintk() does : 

preempt_disable()
local_irq_save()
lockdep_off()
spin_lock(&logbuf_lock)
spin_unlock(&logbuf_lock)
if(!down_trylock(&console_sem))
   up(&console_sem)
lockdep_on()
local_irq_restore() 
preempt_enable()
    
The goals here is to make sure we do not call printk() recursively from
kernel/lockdep.c:__lock_acquire() (called from spin_* and down/up) nor from
kernel/lockdep.c:trace_hardirqs_on/off() (called from local_irq_restore/save).
It can then potentially call printk() through mark_held_locks/mark_lock.
  
It correctly protects against the spin_lock call and the up/down call, but it
does not protect against local_irq_restore. It could cause infinite recursive
printk/trace_hardirqs_on() calls when printk() is called from the
mark_lock() error handing path.

We should change the locking so it becomes correct :

preempt_disable()
lockdep_off()
local_irq_save()
spin_lock(&logbuf_lock)
spin_unlock(&logbuf_lock)
if(!down_trylock(&console_sem))
   up(&console_sem)
local_irq_restore()
lockdep_on()
preempt_enable()


Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -530,8 +530,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		zap_locks();
 
 	/* This stops the holder of console_sem just where we want him */
-	local_irq_save(flags);
 	lockdep_off();
+	local_irq_save(flags);
 	spin_lock(&logbuf_lock);
 	printk_cpu = smp_processor_id();
 
@@ -640,8 +640,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 			console_locked = 0;
 			up(&console_sem);
 		}
-		lockdep_on();
 		local_irq_restore(flags);
+		lockdep_on();
 	} else {
 		/*
 		 * Someone else owns the drivers.  We drop the spinlock, which
@@ -650,8 +650,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		 */
 		printk_cpu = UINT_MAX;
 		spin_unlock(&logbuf_lock);
-		lockdep_on();
 		local_irq_restore(flags);
+		lockdep_on();
 	}
 
 	preempt_enable();
-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
