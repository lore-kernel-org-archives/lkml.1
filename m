Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYAGKZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYAGKZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYAGKZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:25:47 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52378 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbYAGKZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:25:47 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: bcrl@kvack.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       David Miller <davem@davemloft.net>
Subject: Re: regression: sysctl_check changes in 2.6.24 are O(n) resulting in slow creation of 10000 network interfaces
References: <20080106220307.GU28570@kvack.org>
	<m1ir26ktqi.fsf@ebiederm.dsl.xmission.com>
	<20080106.231040.222338659.davem@davemloft.net>
Date: Mon, 07 Jan 2008 03:25:00 -0700
In-Reply-To: <20080106.231040.222338659.davem@davemloft.net> (David Miller's
	message of "Sun, 06 Jan 2008 23:10:40 -0800 (PST)")
Message-ID: <m1tzlqj5kz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Sun, 06 Jan 2008 23:57:57 -0700
>
>> Why do we need 10000 interfaces?  Why isn't network device creation a
>> slow path?
>
> Because people create virtual devices like mad.
>
>> So is this a bug report telling me that there are users with
>> 10k or 100k interfaces that care.  So we need to fix sysctl.
>
> Unquestionably, we do, it's a major regression.
>
> People create thousands of VLAN devices, as one of many examples, all
> the time.
>
> That's why we even bother hashing network devices in the network code.

Cool thanks.  Although I think that was only a 256 way hash.  So it
is a bit stretched at 10,000 chain length of 39 and approaching ugly
at 100,000.  Still it should perform much better the sysctl.

I think someone failed to notice that using /proc/sys slowed to a crawl
in that event, and now that I am doing a lookup on register it seems to
showing up in the benchmarks.

At 256 or fewer that we that the network device hash is optimized for
the sysctl data structures didn't look to be falling over to badly.
2s vs .2s if I read Benjamin numbers right.

Given that it is late in the release cycle (so we can't do the
surgery that it appears the internal sysctl data structures need)
I propose doing something like the patch below.

Benjamin can you test the patch below and tell me if it also
keeps the network device performance at acceptable levels.

I really don't want to remove the check for invalid binary sysctl names
or the other ones if I can help it.  But that should be a small constant
cost and not make things progressively worse.

Eric

diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index a68425a..d69ef6d 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -1343,6 +1343,7 @@ static void sysctl_repair_table(struct ctl_table *table)
 	}
 }
 
+#if 0
 static struct ctl_table *sysctl_check_lookup(struct ctl_table *table)
 {
 	struct ctl_table_header *head;
@@ -1385,6 +1386,7 @@ out:
 	sysctl_head_finish(head);
 	return ref;
 }
+#endif
 
 static void set_fail(const char **fail, struct ctl_table *table, const char *str)
 {
@@ -1397,6 +1399,10 @@ static void set_fail(const char **fail, struct ctl_table *table, const char *str
 	*fail = str;
 }
 
+#if 0 
+/* Temporarily disabled to improve network device creation speed
+ * Reenable after we have fixed the sysctl data structures.
+ */
 static int sysctl_check_dir(struct ctl_table *table)
 {
 	struct ctl_table *ref;
@@ -1436,6 +1442,15 @@ static void sysctl_check_leaf(struct ctl_table *table, const char **fail)
 	if (ref && (ref != table))
 		set_fail(fail, table, "Sysctl already exists");
 }
+#else
+static int sysctl_check_dir(struct ctl_table *table)
+{
+	return 0;
+}
+static void sysctl_check_leaf(struct ctl_table *table, const char **fail)
+{
+}
+#endif
 
 static void sysctl_check_bin_path(struct ctl_table *table, const char **fail)
 {
