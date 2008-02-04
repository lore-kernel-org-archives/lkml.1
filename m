Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYBDFzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYBDFzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 00:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYBDFzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 00:55:37 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:48147 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYBDFzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 00:55:36 -0500
Date: Mon, 4 Feb 2008 06:55:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch: kernel/workqueue.c
Message-ID: <20080204055540.GA11435@uranus.ravnborg.org>
References: <804dabb00802031857l73a02b87jcad9cc2a89d19f81@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00802031857l73a02b87jcad9cc2a89d19f81@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 10:57:18AM +0800, Peter Teoh wrote:
> During compilation of the linus tree the following warnings are encountered:
> 
> WARNING: kernel/built-in.o(.data+0x2480): Section mismatch in
> reference from the variable workqueue_cpu_callback_nb.14223 to the
> function .devinit.text:workqueue_cpu_callback()
> The variable workqueue_cpu_callback_nb.14223 references
> the function __devinit workqueue_cpu_callback()
> If the reference is valid then annotate the
> variable with __init* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> This fix is to correct the following warning during compilation.
> Based on my "elementary" analysis, as it is called from other
> non-__init functions, this function cannot be declared as __devinit(),
> correct?   Please comment.   Thanks :-).
> 
> Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>

Hi Peter.
I changed this and the following warning from relay using following
patch.

	Sam


>From 5fc28317ea634483360c43b015f230c68ad2c0f4 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 31 Jan 2008 21:16:16 +0100
Subject: [PATCH] cpu: silence section mismatch warnings for hotcpu notifies

The hotcpu_notifier is used to create notifiers to be called later.
It really looks like the functions that are registered are only
relevant in a HOTPLUG_CPU configuration and the correct fix was
to wrap them in an #ifdef / #endif or similar.
But for now just tell modpost to silence the warning by annotating
the static variable with __refdata.

This silences the following warnings in kernel/:
WARNING: o-x86_64/kernel/built-in.o(.data+0x960): Section mismatch in reference from the variable profile_cpu_callback_nb.17240 to the function .devinit.text:profile_cpu_callback()
WARNING: o-x86_64/kernel/built-in.o(.data+0x3fa0): Section mismatch in reference from the variable workqueue_cpu_callback_nb.14663 to the function .devinit.text:workqueue_cpu_callback()
WARNING: o-x86_64/kernel/built-in.o(.data+0xe280): Section mismatch in reference from the variable relay_hotcpu_callback_nb.19247 to the function .cpuinit.text:relay_hotcpu_callback()

Additional warnings are silenced with this change but
they are left put.

This patch is just a workaround for the bad practice
to use __cpuinit to annotate code solely used for
HOTPLUG_CPU.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
---
 include/linux/cpu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 0be8d65..cebb8c0 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -109,7 +109,7 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
-	static struct notifier_block fn##_nb =			\
+	static struct notifier_block fn##_nb __refdata =	\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_cpu_notifier(&fn##_nb);			\
 }
-- 
1.5.4.rc3.14.g44397

