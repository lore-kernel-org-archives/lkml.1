Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398Ab0AKVa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab0AKVa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312Ab0AKV11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:34876 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0AKV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=v4GPxSYd/8d7D4/Px62k6hktYukcbU7yyWOUVSTCyNjJVVxZ+lrdImJEfR+M+/b0ID
         //EeP7zohpudJcTXUPDAndleBgRbLylXr8iZD+yVfLYJA6Br2w3Zjm0W4GZRgRrjuynt
         MnFMdBCM+fmp2Q28PMxfiXKSz2ccGMSLwVO8Q=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 12/26] printk: Convert lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:42 +0100
Message-Id: <1263245216-14754-13-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-12-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks that cannot sleep in preempt-rt to raw_spinlocks.

See also: 0835f1f82a88e366d8dd20874c94133915dcccdb

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/ratelimit.h |    4 ++--
 kernel/printk.c           |   42 +++++++++++++++++++++---------------------
 lib/ratelimit.c           |    4 ++--
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 668cf1b..7596e38 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -8,7 +8,7 @@
 #define DEFAULT_RATELIMIT_BURST		10
 
 struct ratelimit_state {
-	spinlock_t	lock;		/* protect the state */
+	raw_spinlock_t	lock;		/* protect the state */
 
 	int		interval;
 	int		burst;
@@ -20,7 +20,7 @@ struct ratelimit_state {
 #define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
 									\
 	struct ratelimit_state name = {					\
-		.lock		= __SPIN_LOCK_UNLOCKED(name.lock),	\
+		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
 		.interval	= interval_init,			\
 		.burst		= burst_init,				\
 	}
diff --git a/kernel/printk.c b/kernel/printk.c
index 17463ca..4ebb6e0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -102,7 +102,7 @@ static int console_locked, console_suspended;
  * It is also used in interesting ways to provide interlocking in
  * release_console_sem().
  */
-static DEFINE_SPINLOCK(logbuf_lock);
+static DEFINE_RAW_SPINLOCK(logbuf_lock);
 
 #define LOG_BUF_MASK (log_buf_len-1)
 #define LOG_BUF(idx) (log_buf[(idx) & LOG_BUF_MASK])
@@ -181,7 +181,7 @@ static int __init log_buf_len_setup(char *str)
 			goto out;
 		}
 
-		spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		log_buf_len = size;
 		log_buf = new_log_buf;
 
@@ -195,7 +195,7 @@ static int __init log_buf_len_setup(char *str)
 		log_start -= offset;
 		con_start -= offset;
 		log_end -= offset;
-		spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 		printk(KERN_NOTICE "log_buf_len: %d\n", log_buf_len);
 	}
@@ -305,18 +305,18 @@ int do_syslog(int type, char __user *buf, int len)
 		if (error)
 			goto out;
 		i = 0;
-		spin_lock_irq(&logbuf_lock);
+		raw_spin_lock_irq(&logbuf_lock);
 		while (!error && (log_start != log_end) && i < len) {
 			c = LOG_BUF(log_start);
 			log_start++;
-			spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&logbuf_lock);
 			error = __put_user(c,buf);
 			buf++;
 			i++;
 			cond_resched();
-			spin_lock_irq(&logbuf_lock);
+			raw_spin_lock_irq(&logbuf_lock);
 		}
-		spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&logbuf_lock);
 		if (!error)
 			error = i;
 		break;
@@ -337,7 +337,7 @@ int do_syslog(int type, char __user *buf, int len)
 		count = len;
 		if (count > log_buf_len)
 			count = log_buf_len;
-		spin_lock_irq(&logbuf_lock);
+		raw_spin_lock_irq(&logbuf_lock);
 		if (count > logged_chars)
 			count = logged_chars;
 		if (do_clear)
@@ -354,12 +354,12 @@ int do_syslog(int type, char __user *buf, int len)
 			if (j + log_buf_len < log_end)
 				break;
 			c = LOG_BUF(j);
-			spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&logbuf_lock);
 			error = __put_user(c,&buf[count-1-i]);
 			cond_resched();
-			spin_lock_irq(&logbuf_lock);
+			raw_spin_lock_irq(&logbuf_lock);
 		}
-		spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&logbuf_lock);
 		if (error)
 			break;
 		error = i;
@@ -542,7 +542,7 @@ static void zap_locks(void)
 	oops_timestamp = jiffies;
 
 	/* If a crash is occurring, make sure we can't deadlock */
-	spin_lock_init(&logbuf_lock);
+	raw_spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
 	init_MUTEX(&console_sem);
 }
@@ -646,7 +646,7 @@ static int acquire_console_semaphore_for_printk(unsigned int cpu)
 		}
 	}
 	printk_cpu = UINT_MAX;
-	spin_unlock(&logbuf_lock);
+	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 static const char recursion_bug_msg [] =
@@ -704,7 +704,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	}
 
 	lockdep_off();
-	spin_lock(&logbuf_lock);
+	raw_spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
 	if (recursion_bug) {
@@ -1053,14 +1053,14 @@ void release_console_sem(void)
 	console_may_schedule = 0;
 
 	for ( ; ; ) {
-		spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		wake_klogd |= log_start - log_end;
 		if (con_start == log_end)
 			break;			/* Nothing to print */
 		_con_start = con_start;
 		_log_end = log_end;
 		con_start = log_end;		/* Flush */
-		spin_unlock(&logbuf_lock);
+		raw_spin_unlock(&logbuf_lock);
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(_con_start, _log_end);
 		start_critical_timings();
@@ -1068,7 +1068,7 @@ void release_console_sem(void)
 	}
 	console_locked = 0;
 	up(&console_sem);
-	spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 	if (wake_klogd)
 		wake_up_klogd();
 }
@@ -1286,9 +1286,9 @@ void register_console(struct console *newcon)
 		 * release_console_sem() will print out the buffered messages
 		 * for us.
 		 */
-		spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		con_start = log_start;
-		spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 	}
 	release_console_sem();
 
@@ -1496,10 +1496,10 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 	/* Theoretically, the log could move on after we do this, but
 	   there's not a lot we can do about that. The new messages
 	   will overwrite the start of what we dump. */
-	spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
 	end = log_end & LOG_BUF_MASK;
 	chars = logged_chars;
-	spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 	if (logged_chars > end) {
 		s1 = log_buf + log_buf_len - logged_chars + end;
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 09f5ce1..39588b3 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -34,7 +34,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 	 * in addition to the one that will be printed by
 	 * the entity that is holding the lock already:
 	 */
-	if (!spin_trylock_irqsave(&rs->lock, flags))
+	if (!raw_spin_trylock_irqsave(&rs->lock, flags))
 		return 1;
 
 	if (!rs->begin)
@@ -55,7 +55,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 		rs->missed++;
 		ret = 0;
 	}
-	spin_unlock_irqrestore(&rs->lock, flags);
+	raw_spin_unlock_irqrestore(&rs->lock, flags);
 
 	return ret;
 }
-- 
1.6.5.2

