Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXAXR4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXAXR4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 12:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXAXR4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 12:56:01 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:35162 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbXAXR4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 12:56:00 -0500
Date: Wed, 24 Jan 2007 12:55:57 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Richard J Moore <richardj_moore@uk.ibm.com>,
       linux-kernel@vger.kernel.org, "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>,
       Douglas Niehaus <niehaus@eecs.ku.edu>, Ingo Molnar <mingo@redhat.com>,
       ltt-dev@shafik.org, systemtap@sources.redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] minimize lockdep_on/off side-effect
Message-ID: <20070124175557.GA160@Krystal>
References: <20061220235216.GA28643@Krystal> <OFAB3D8A6C.1643F2D3-ON80257262.000581E4-80257262.00088F04@uk.ibm.com> <20070116175624.GA16022@Krystal> <20070123202637.970e467b.akpm@osdl.org> <20070124165150.GC4979@Krystal> <20070124172445.GA1145@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070124172445.GA1145@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 12:52:33 up 154 days, 14:59,  4 users,  load average: 0.74, 0.54, 0.51
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Minimize lockdep_on/off side-effect on irq tracing in vprintk by using
raw_local_irq_save/restore _around_ lockdep_off/on().

It applies on the previous patch. It has the advantage of not losing the IRQ
events coming between the lockdep disabling and the irq disabling.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

 
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -530,8 +530,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		zap_locks();
 
 	/* This stops the holder of console_sem just where we want him */
+	raw_local_irq_save(flags);
 	lockdep_off();
-	local_irq_save(flags);
 	spin_lock(&logbuf_lock);
 	printk_cpu = smp_processor_id();
 
@@ -640,8 +640,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 			console_locked = 0;
 			up(&console_sem);
 		}
-		local_irq_restore(flags);
 		lockdep_on();
+		raw_local_irq_restore(flags);
 	} else {
 		/*
 		 * Someone else owns the drivers.  We drop the spinlock, which
@@ -650,8 +650,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		 */
 		printk_cpu = UINT_MAX;
 		spin_unlock(&logbuf_lock);
-		local_irq_restore(flags);
 		lockdep_on();
+		raw_local_irq_restore(flags);
 	}
 
 	preempt_enable();
-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
