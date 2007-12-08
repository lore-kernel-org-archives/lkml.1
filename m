Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbXLHXNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbXLHXNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 18:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbXLHXM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 18:12:57 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:62246 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbXLHXM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 18:12:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=w67eAtf+UQLtDguad2IAKErF2T/I6a7ClOicFGeIYYDkYeSTSOOVFdfM+r83FQsMYZymRBrDpuGpILoAEl/oRvaRy2lqHg8JBVBJKFlc1vahOSGQfq40MBKQZdSY9vu/uqBybWpzNMhMQ7iedvMy1gmUKnEkRcwuch5gqtPRUdE=
Message-ID: <475B24F4.3090904@gmail.com>
Date: Sun, 09 Dec 2007 00:12:52 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47595A0A.5000502@gmail.com> <20071207151150.GB24254@elte.hu> <20071207175134.GA18916@elte.hu> <475A5188.6070809@gmail.com> <20071208083939.GD30997@elte.hu> <475A629C.7010408@gmail.com> <20071208152447.GA30270@elte.hu>
In-Reply-To: <20071208152447.GA30270@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2007 04:24 PM, Ingo Molnar wrote:
> i'm wondering why it had no effect now

diff --git a/kernel/cpu.c b/kernel/cpu.c
index e0d3a4f..a46c252 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -47,15 +47,21 @@ void __init cpu_hotplug_init(void)
 }

 #ifdef CONFIG_HOTPLUG_CPU
-
+#include <asm/io.h>
 void get_online_cpus(void)
 {
+       outb(0x20, 0x80);
        might_sleep();
+       outb(0x21, 0x80);
        if (cpu_hotplug.active_writer == current)
                return;
+       outb(0x22, 0x80);
        mutex_lock(&cpu_hotplug.lock);
+       outb(0x23, 0x80);
        cpu_hotplug.refcount++;
+       outb(0x24, 0x80);
        mutex_unlock(&cpu_hotplug.lock);
+       outb(0x25, 0x80);

 }
 EXPORT_SYMBOL_GPL(get_online_cpus);

produces 0x22 on the LCD (called from watchdog kthread).

Going to catch some sleep,
--js
