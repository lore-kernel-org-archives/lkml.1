Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbZIOXY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbZIOXY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZIOXYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:24:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019AbZIOXYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:24:24 -0400
Date: Tue, 15 Sep 2009 16:23:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, lenb@kernel.org,
       mingo@elte.hu, yanmin_zhang@linux.intel.com, jens.axboe@oracle.com,
       ink@jurassic.park.msu.ru, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO
 performance
Message-Id: <20090915162306.66c5ce9d.akpm@linux-foundation.org>
In-Reply-To: <20090915054259.5282e5ba@infradead.org>
References: <20090915054259.5282e5ba@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 05:42:59 +0200
Arjan van de Ven <arjan@infradead.org> wrote:

> Fix the menu idle governor which balances power savings, energy efficiency
> and performance impact.

This patch clashes a bit with
cpuidle-menu-governor-reduce-latency-on-exit.patch (which was sent to
the ACPI maintainers a month ago and ignored).

<im-fed-up-with-this-crap-ill-just-merge-it-and-if-it-breaks-dont-blame-me>


I restaged cpuidle-menu-governor-reduce-latency-on-exit.patch so it
goes after cpuidle-fix-the-menu-governor-to-boost-io-performance.patch.
perhaps you could take a look at Corrado's change?

 

From: Corrado Zoccolo <czoccolo@gmail.com>

Move the state residency accounting and statistics computation off the hot
exit path.

On exit, the need to recompute statistics is recorded, and new statistics
will be computed when menu_select is called again.

The expected effect is to reduce processor wakeup latency from sleep
(C-states).  We are speaking of few hundreds of cycles reduction out of a
several microseconds latency (determined by the hardware transition), so
it is difficult to measure.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Adam Belay <abelay@novell.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-menu-governor-reduce-latency-on-exit drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-menu-governor-reduce-latency-on-exit
+++ a/drivers/cpuidle/governors/menu.c
@@ -96,6 +96,7 @@
 
 struct menu_device {
 	int		last_state_idx;
+	int             needs_update;
 
 	unsigned int	expected_us;
 	u64		predicted_us;
@@ -166,6 +167,8 @@ static inline int performance_multiplier
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
+static void menu_update(struct cpuidle_device *dev);
+
 /**
  * menu_select - selects the next idle state to enter
  * @dev: the CPU
@@ -180,6 +183,11 @@ static int menu_select(struct cpuidle_de
 	data->last_state_idx = 0;
 	data->exit_us = 0;
 
+	if (data->needs_update) {
+		menu_update(dev);
+		data->needs_update = 0;
+	}
+
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0))
 		return 0;
@@ -231,7 +239,7 @@ static int menu_select(struct cpuidle_de
 }
 
 /**
- * menu_reflect - attempts to guess what happened after entry
+ * menu_reflect - records that data structures need update
  * @dev: the CPU
  *
  * NOTE: it's important to be fast here because this operation will add to
@@ -240,6 +248,16 @@ static int menu_select(struct cpuidle_de
 static void menu_reflect(struct cpuidle_device *dev)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
+	data->needs_update = 1;
+}
+
+/**
+ * menu_update - attempts to guess what happened after entry
+ * @dev: the CPU
+ */
+static void menu_update(struct cpuidle_device *dev)
+{
+	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int last_idx = data->last_state_idx;
 	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
 	struct cpuidle_state *target = &dev->states[last_idx];
_

