Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbYJGAxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbYJGAxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYJGAo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:44:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757564AbYJGAo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:44:27 -0400
Date: Mon, 6 Oct 2008 17:38:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Raz <raziebe@gmail.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, the arch/x86 maintainers <x86@kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Vegard Nossum <vegard.nossum@gmail.com>, carlos@strangeworlds.co.uk,
       Pekka Paalanen <pq@iki.fi>, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 35/71] x86: fix SMP alternatives: use mutex instead of
	spinlock, text_poke is sleepable
Message-ID: <20081007003855.GJ3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-smp-alternatives-use-mutex-instead-of-spinlock-text_poke-is-sleepable.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Pekka Paalanen <pq@iki.fi>

commit 2f1dafe50cc4e58a239fd81bd47f87f32042a1ee upstream

text_poke is sleepable.
The original fix by Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/alternative.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1,6 +1,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/kprobes.h>
 #include <linux/mm.h>
@@ -279,7 +279,7 @@ struct smp_alt_module {
 	struct list_head next;
 };
 static LIST_HEAD(smp_alt_modules);
-static DEFINE_SPINLOCK(smp_alt);
+static DEFINE_MUTEX(smp_alt);
 static int smp_mode = 1;	/* protected by smp_alt */
 
 void alternatives_smp_module_add(struct module *mod, char *name,
@@ -312,12 +312,12 @@ void alternatives_smp_module_add(struct 
 		__func__, smp->locks, smp->locks_end,
 		smp->text, smp->text_end, smp->name);
 
-	spin_lock(&smp_alt);
+	mutex_lock(&smp_alt);
 	list_add_tail(&smp->next, &smp_alt_modules);
 	if (boot_cpu_has(X86_FEATURE_UP))
 		alternatives_smp_unlock(smp->locks, smp->locks_end,
 					smp->text, smp->text_end);
-	spin_unlock(&smp_alt);
+	mutex_unlock(&smp_alt);
 }
 
 void alternatives_smp_module_del(struct module *mod)
@@ -327,17 +327,17 @@ void alternatives_smp_module_del(struct 
 	if (smp_alt_once || noreplace_smp)
 		return;
 
-	spin_lock(&smp_alt);
+	mutex_lock(&smp_alt);
 	list_for_each_entry(item, &smp_alt_modules, next) {
 		if (mod != item->mod)
 			continue;
 		list_del(&item->next);
-		spin_unlock(&smp_alt);
+		mutex_unlock(&smp_alt);
 		DPRINTK("%s: %s\n", __func__, item->name);
 		kfree(item);
 		return;
 	}
-	spin_unlock(&smp_alt);
+	mutex_unlock(&smp_alt);
 }
 
 void alternatives_smp_switch(int smp)
@@ -359,7 +359,7 @@ void alternatives_smp_switch(int smp)
 		return;
 	BUG_ON(!smp && (num_online_cpus() > 1));
 
-	spin_lock(&smp_alt);
+	mutex_lock(&smp_alt);
 
 	/*
 	 * Avoid unnecessary switches because it forces JIT based VMs to
@@ -383,7 +383,7 @@ void alternatives_smp_switch(int smp)
 						mod->text, mod->text_end);
 	}
 	smp_mode = smp;
-	spin_unlock(&smp_alt);
+	mutex_unlock(&smp_alt);
 }
 
 #endif

-- 
