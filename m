Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbZKMTtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbZKMTtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbZKMTtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:49:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:35979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435AbZKMTtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:49:12 -0500
Date: Fri, 13 Nov 2009 19:48:44 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       linus.walleij@stericsson.com, johnstul@us.ibm.com, mikpe@it.uu.se,
       ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linus.walleij@stericsson.com, johnstul@us.ibm.com, mikpe@it.uu.se,
       ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20091111134229.725664788@linutronix.de>
References: <20091111134229.725664788@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents: Use u32 for mult and shift factors
Message-ID: <tip-23af368e9a904f59256c27d371ce223d6cee0430@git.kernel.org>
Git-Commit-ID: 23af368e9a904f59256c27d371ce223d6cee0430
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23af368e9a904f59256c27d371ce223d6cee0430
Gitweb:     http://git.kernel.org/tip/23af368e9a904f59256c27d371ce223d6cee0430
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Nov 2009 14:05:25 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 13 Nov 2009 20:46:23 +0100

clockevents: Use u32 for mult and shift factors

The mult and shift factors of clock events differ in their data type
from those of clock sources for no reason. u32 is sufficient for
both. shift is always <= 32 and mult is limited to 2^32-1 to avoid
64bit multiplication overflows in the conversion.

Preparatory patch for a generic mult/shift factor calculation
function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mikael Pettersson <mikpe@it.uu.se>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20091111134229.725664788@linutronix.de>
---
 include/linux/clockchips.h |    4 ++--
 kernel/time/timer_list.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 3a1dbba..3b58410 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -79,8 +79,8 @@ struct clock_event_device {
 	unsigned int		features;
 	unsigned long		max_delta_ns;
 	unsigned long		min_delta_ns;
-	unsigned long		mult;
-	int			shift;
+	u32			mult;
+	u32			shift;
 	int			rating;
 	int			irq;
 	const struct cpumask	*cpumask;
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 1b5b7aa..fa00da1 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -206,8 +206,8 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 	SEQ_printf(m, "%s\n", dev->name);
 	SEQ_printf(m, " max_delta_ns:   %lu\n", dev->max_delta_ns);
 	SEQ_printf(m, " min_delta_ns:   %lu\n", dev->min_delta_ns);
-	SEQ_printf(m, " mult:           %lu\n", dev->mult);
-	SEQ_printf(m, " shift:          %d\n", dev->shift);
+	SEQ_printf(m, " mult:           %u\n", dev->mult);
+	SEQ_printf(m, " shift:          %u\n", dev->shift);
 	SEQ_printf(m, " mode:           %d\n", dev->mode);
 	SEQ_printf(m, " next_event:     %Ld nsecs\n",
 		   (unsigned long long) ktime_to_ns(dev->next_event));
