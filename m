Return-Path: <linux-kernel-owner+w=401wt.eu-S934135AbXCVRI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135AbXCVRI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 13:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934138AbXCVRI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 13:08:57 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:49658 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934137AbXCVRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 13:08:54 -0400
Date: Thu, 22 Mar 2007 18:02:01 +0100
From: Mattia Dongili <malattia@linux.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Dave Jones <davej@redhat.com>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix cpufreq_stats attrs removal
Message-ID: <20070322170201.GP4108@inferi.kami.home>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Greg KH <gregkh@suse.de>, Dave Jones <davej@redhat.com>,
	Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
References: <20070319153013.GA6814@localhost.sw.ru> <20070319204125.GA5598@suse.de> <20070320100634.GA6811@localhost.sw.ru> <20070322030753.GB5728@suse.de> <20070322035104.GA17159@redhat.com> <20070322040006.GA6892@suse.de> <20070321201042.f1cbf4d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321201042.f1cbf4d8.akpm@linux-foundation.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.21-rc3-mm2-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 08:10:42PM -0800, Andrew Morton wrote:
> On Wed, 21 Mar 2007 21:00:06 -0700 Greg KH <gregkh@suse.de> wrote:
> 
> > On Wed, Mar 21, 2007 at 11:51:04PM -0400, Dave Jones wrote:
> > > On Wed, Mar 21, 2007 at 08:07:53PM -0700, Greg KH wrote:
> > >  
> > >  > > After modprobe/rmmod cpufreq/stats directory appears but doesn't get
> > >  > > removed. Should it?
> > >  > Well, one can argue that those stats should never be in sysfs at all
> > >  > anyway, I mean come on, a histogram in sysfs?  That's, not ok.
> > > 
> > > Meh, it's only a cheesy debug thing, so it's not really that big a deal imo.
> > > it could probably move to debugfs (we didn't have that when it was merged iirc)
> > > I doubt anyone really cares enough to bother though I wouldn't
> > > be averse to a patch.
> > 
> > Yeah, I realize this, I'm not trying to find fault, sorry if it came
> > across that way.  And yes, it should move to debugfs some day, but if it
> > does, I'll loose my "what not to put in sysfs" example I use in
> > presentations :)
> > 
> 
> I ain't picky, but as a short-term thing it'd be kinda nice if it didn't
> oops the kernel.

There are other symptoms to this same bug:

1. unload p4-clockmod: /sys/.../cpu0/cpufreq is removed all together
2. load p4-clockmod: /sys/.../cpu0/cpufreq appears but no 'stats' subdir
   (yes, cpufreq_stats is loaded)
3. rmmod cpufreq_stats: Ooops!

Call Trace:
 [<c0183f5b>] remove_dir+0x33/0xc4
 [<c0184fca>] remove_files+0x1a/0x28
 [<c018503b>] sysfs_remove_group+0x63/0x71
 [<f898c38d>] cpufreq_stat_cpu_callback+0x51/0x8a [cpufreq_stats]
 [<f898c477>] cpufreq_stats_exit+0x47/0x4b [cpufreq_stats]
 [<c012f145>] sys_delete_module+0x190/0x1b7
 [<c0140073>] do_wp_page+0x231/0x3e7
 [<c0102e17>] syscall_call+0x7/0xb

The problem is cpufreq_stats doesn't know when a cpufreq driver is
removed and doesn't cleanup. I guess this affects any setup with
cpufreq_stats.
The attached patch seems to solve both symptoms and yes... it's quite
invasive as it introduce one more cpufreq policy notification (REMOVED).

BTW: the patch is against .21-rc4-mm1 but applies with some fuzz to
2.6.20 too

diff -rup linux-2.6.20/drivers/cpufreq/cpufreq.c linux-2.6.20.dirty/drivers/cpufreq/cpufreq.c
--- linux-2.6.20/drivers/cpufreq/cpufreq.c	2007-03-22 17:00:38.000000000 +0100
+++ linux-2.6.20.dirty/drivers/cpufreq/cpufreq.c	2007-03-22 16:51:09.000000000 +0100
@@ -989,6 +989,10 @@ static int __cpufreq_remove_dev (struct 
 
 	unlock_policy_rwsem_write(cpu);
 
+	/* notify of policy cancellation */
+	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
+			CPUFREQ_REMOVE, data);
+
 	kobject_unregister(&data->kobj);
 
 	kobject_put(&data->kobj);
diff -rup linux-2.6.20/drivers/cpufreq/cpufreq_stats.c linux-2.6.20.dirty/drivers/cpufreq/cpufreq_stats.c
--- linux-2.6.20/drivers/cpufreq/cpufreq_stats.c	2007-03-22 17:00:38.000000000 +0100
+++ linux-2.6.20.dirty/drivers/cpufreq/cpufreq_stats.c	2007-03-22 17:06:24.000000000 +0100
@@ -257,18 +257,23 @@ static int
 cpufreq_stat_notifier_policy (struct notifier_block *nb, unsigned long val,
 		void *data)
 {
-	int ret;
+	int ret = 0;
 	struct cpufreq_policy *policy = data;
 	struct cpufreq_frequency_table *table;
 	unsigned int cpu = policy->cpu;
-	if (val != CPUFREQ_NOTIFY)
-		return 0;
-	table = cpufreq_frequency_get_table(cpu);
-	if (!table)
-		return 0;
-	if ((ret = cpufreq_stats_create_table(policy, table)))
-		return ret;
-	return 0;
+	switch (val) {
+	case CPUFREQ_NOTIFY:
+		table = cpufreq_frequency_get_table(cpu);
+		if (!table)
+			break;
+		ret = cpufreq_stats_create_table(policy, table);
+		break;
+
+	case CPUFREQ_REMOVE:
+		cpufreq_stats_free_table(cpu);
+		break;
+	}
+	return ret;
 }
 
 static int
@@ -371,8 +376,7 @@ __exit cpufreq_stats_exit(void)
 			CPUFREQ_TRANSITION_NOTIFIER);
 	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
-		cpufreq_stat_cpu_callback(&cpufreq_stat_cpu_notifier,
-						CPU_DEAD, (void *)(long)cpu);
+		cpufreq_stats_free_table(cpu);
 	}
 }
 
--- linux-2.6.20/include/linux/cpufreq.h	2007-03-22 17:00:47.000000000 +0100
+++ linux-2.6.20.dirty/include/linux/cpufreq.h	2007-03-22 16:10:37.000000000 +0100
@@ -96,6 +96,7 @@ struct cpufreq_policy {
 #define CPUFREQ_ADJUST		(0)
 #define CPUFREQ_INCOMPATIBLE	(1)
 #define CPUFREQ_NOTIFY		(2)
+#define CPUFREQ_REMOVE		(3)
 
 #define CPUFREQ_SHARED_TYPE_NONE (0) /* None */
 #define CPUFREQ_SHARED_TYPE_HW	 (1) /* HW does needed coordination */
