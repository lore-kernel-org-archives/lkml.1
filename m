Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZA3W2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZA3W2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZA3W2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:28:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbZA3W2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:28:34 -0500
Date: Fri, 30 Jan 2009 14:28:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Grant Erickson <gerickson@nuovations.com>
Cc: linux-kernel@vger.kernel.org, wd@denx.de
Subject: Re: [RFC] Add Alternative Log Buffer Support for printk Messages
Message-Id: <20090130142825.e63ee797.akpm@linux-foundation.org>
In-Reply-To: <C5A8B8CD.143B5%gerickson@nuovations.com>
References: <20090130115108.592ba38d.akpm@linux-foundation.org>
	<C5A8B8CD.143B5%gerickson@nuovations.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 14:01:49 -0800
Grant Erickson <gerickson@nuovations.com> wrote:

> Your summary is precisely the intent. As I
> mentioned in check-in notice, this isn't my work per se, but a fix of prior
> unsubmitted work. Consequently, I can only speculate on the original
> implementation choices of the primary authors (Yuri Tikhonov
> <yur@emcraft.com> on behalf of Denx from what I can ascertain from GIT
> logs). I've added Wolfgang in the event he can add background where
> appropriate.
> 
> I believe this to be a useful feature for the embedded system space;
> however, I am not wedded in any way to the current implementation and am
> happy to evolve it as needed to meet the needs of key stakeholders.
> 
> > Why not just copy the external buffer's contents into the normal buffer during
> > bootup?  ie: printk("%s", external_buffer).
> 
> Again, conjecturing, I suspect the goal was to ensure that the boot messages
> appear on the console or in the syslog before kernel messages of that
> particular boot cycle. Depending on the board and architecture in question,
> the kernel log buffer may have several messages in it by the time the log
> coalescing code runs. For example, on the board I tested this on:
> 
>     # dmesg
>     U-Boot 1.3.3 (Jan  9 2009 - 10:24:45)
>     POST memory PASSED
>     POST ecc PASSED
>     POST cache PASSED
>     POST ethernet PASSED
>     Using Kilauea machine description
>     log_buf=fdffc000
>     Linux version 2.6.27.7 (gerickson@ubuntu-fusion) (gcc version 4.0.0
> (DENX ELDK 4.1 4.0.0)) #1 Fri Jan 9 10:30:30 PST 2009

It shouldn't be too hard to cook up some way of copying some data into
th log buffer before the kernel itself has put anything in there, if
that's all which is needed.


something similar to this?

 include/linux/kernel.h |    2 ++
 init/main.c            |    6 ++++++
 kernel/printk.c        |    8 ++++++++
 3 files changed, 16 insertions(+)

diff -puN init/main.c~a init/main.c
--- a/init/main.c~a
+++ a/init/main.c
@@ -535,11 +535,17 @@ void __init __weak thread_info_cache_ini
 {
 }
 
+void __init __weak arch_copy_boot_messages(void)
+{
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
 	extern struct kernel_param __start___param[], __stop___param[];
 
+	arch_copy_boot_messages();
+
 	smp_setup_processor_id();
 
 	/*
diff -puN kernel/printk.c~a kernel/printk.c
--- a/kernel/printk.c~a
+++ a/kernel/printk.c
@@ -493,6 +493,14 @@ static void emit_log_char(char c)
 		logged_chars++;
 }
 
+void emit_log_string(const char *s)
+{
+	spin_lock_irqsave(&logbuf_lock);
+	while (*s)
+		emit_log_char(*s++);
+	spin_unlock_irqsave(&logbuf_lock);
+}
+
 /*
  * Zap console related locks when oopsing. Only zap at most once
  * every 10 seconds, to leave time for slow consoles to print a
diff -puN include/linux/kernel.h~a include/linux/kernel.h
--- a/include/linux/kernel.h~a
+++ a/include/linux/kernel.h
@@ -257,6 +257,8 @@ static inline bool printk_timed_ratelimi
 
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
+extern void __init arch_copy_boot_messages(void);
+extern void emit_log_string(const char *s);
 
 extern void asmlinkage __attribute__((format(printf, 1, 2)))
 	early_printk(const char *fmt, ...);
_

