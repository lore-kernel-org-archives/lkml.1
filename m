Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYICTFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYICTFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYICTFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:05:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227AbYICTFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:05:00 -0400
Date: Wed, 3 Sep 2008 12:04:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2] Add a SYSTEM_PANIC state
Message-Id: <20080903120423.9e00557c.akpm@linux-foundation.org>
In-Reply-To: <20080902134922.9401F3E6A00@basil.firstfloor.org>
References: <20080902349.573187695@firstfloor.org>
	<20080902134922.9401F3E6A00@basil.firstfloor.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Sep 2008 15:49:22 +0200 (CEST)
Andi Kleen <andi@firstfloor.org> wrote:

> --- linux.orig/include/linux/kernel.h
> +++ linux/include/linux/kernel.h
> @@ -248,6 +248,7 @@ extern enum system_states {
>  	SYSTEM_POWER_OFF,
>  	SYSTEM_RESTART,
>  	SYSTEM_SUSPEND_DISK,
> +	SYSTEM_PANIC,
>  } system_state;

system_state is such a crock.  I wonder what other random code all over
the place is looking at system_state and will get unexpectedly broken
by other "unrelated" changes such as this..


It's not a heck of a lot nicer, but we could do this:

--- a/kernel/panic.c~a
+++ a/kernel/panic.c
@@ -80,7 +80,6 @@ NORET_TYPE void panic(const char * fmt, 
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
-	bust_spinlocks(0);
 
 	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
@@ -97,6 +96,7 @@ NORET_TYPE void panic(const char * fmt, 
 	 */
 	smp_send_stop();
 #endif
+	bust_spinlocks(0);
 
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
_

then test oops_in_progress down in the IPI code.  This has the
advantage of not introducing any additional global states and is a bit
more logical, I think.  Need to check whether crash_kexec() would be
affected by the above change.


Bear in mind that the oops-handling code can call panic(), if
panic_on_oops==1.  I can't think of any adverse or special consequences
of this, but it needs to be thought about.

