Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbZD1M5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbZD1M5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbZD1M5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:57:17 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:60340 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030AbZD1M5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:57:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAAWa9klMQW1W/2dsb2JhbACBUM1Ig3MF
Date: Tue, 28 Apr 2009 08:57:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: gregkh@suse.de, stable@kernel.org, cpufreq@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rjw@sisk.pl,
       Ben Slusky <sluskyb@paranoiacs.org>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -stable] cpufreq fix timer teardown in conservative
	governor (2.6.28.x, 2.6.29.1)
Message-ID: <20090428125709.GA26600@Krystal>
References: <20090423140002.GA12852@Krystal> <20090423164638.3b5769c6.akpm@linux-foundation.org> <20090424043416.GA8091@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090424043416.GA8091@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:54:49 up 59 days,  9:21,  2 users,  load average: 0.54, 0.72,
	0.59
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am re-posting the following patch for -stable, as it fell between the
cracks. Andrew picked up the patch for 2.6.30-rc in his tree, but this
one has been forgotten.

commit 8217e4f4c93e5fb59bb3cd1e6135213889349f86
Author: Ben Slusky <sluskyb@paranoiacs.org>
Date:   Mon Jul 7 13:16:20 2008 -0400

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 23 Apr 2009 10:00:02 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi,
> > 
> > I got the following warning on my Thinkpad T43p laptop (single-core
> > 32-bits x86). I run the 2.6.29.1 tree, plus LTTng patchset applied. It
> > seems to come from cpufreq. Any idea what is going on here ?
> > 
> > 
> > ------------[ cut here ]------------
> > WARNING: at lib/debugobjects.c:217 debug_print_object+0x5a/0x70()
> > Hardware name: 2687D5U
> > ODEBUG: init active object type: timer_list
> > Modules linked in: irda parport nsc_ircc irtty_sir parport_pc psmouse snd_seq sn
> > d_seq_midi_event hid_logitech ac unix floppy output battery sir_dev nvram snd_ra
> > wmidi pcmcia x_tables ip_tables joydev snd_seq_midi evdev video snd_page_alloc s
> > oundcore led_class i2c_i801 cryptoloop snd snd_seq_dummy rfkill thinkpad_acpi sn
> > d_seq_oss snd_mixer_oss loop ipw2200 blowfish aes_i586 snd_pcm_oss ac97_bus snd_
> > seq_device agpgart snd_pcm ide_cd_mod snd_timer intel_agp snd_ac97_codec ide_gen
> > eric button snd_intel8x0 edd acpi_cpufreq ltt_statedump ipc_trace usbhid thermal
> >  mm_trace snd_intel8x0m fs_trace pcmcia_core rcu_trace lib80211 syscall_trace rs
> > rc_nonstatic libphy serio_raw kernel_trace tg3 trap_trace libipw crc_ccitt net_t
> > race dm_mod dm_log dm_region_hash dm_mirror yenta_socket dm_snapshot fat vfat nl
> > s_cp437 nls_iso8859_1 lp ppdev af_packet drm ntfs ipv6 auth_rpcgss binfmt_misc r
> > adeon lockd sunrpc nfs
> > Pid: 3628, comm: cpufreqd Not tainted 2.6.29.1-trace #28
> > Call Trace:
> >  [<c1044123>] warn_slowpath+0x73/0xd0
> >  [<c1069c28>] ? mark_held_locks+0x48/0x90
> >  [<c13313f5>] ? __mutex_unlock_slowpath+0xd5/0x150
> >  [<c1069f39>] ? trace_hardirqs_on_caller+0x199/0x1f0
> >  [<c1331478>] ? mutex_unlock+0x8/0x10
> >  [<c1331478>] ? mutex_unlock+0x8/0x10
> >  [<c1107b76>] ? sysfs_addrm_finish+0x16/0x230
> >  [<c1107671>] ? sysfs_find_dirent+0x21/0x30
> >  [<c116d71a>] debug_print_object+0x5a/0x70
> >  [<c116e054>] __debug_object_init+0x254/0x340
> >  [<c126533f>] ? cpufreq_governor_dbs+0x10f/0x210
> >  [<c116e187>] debug_object_init+0x17/0x20
> >  [<c104de70>] init_timer+0x10/0x30
> >  [<c104de9b>] init_timer_deferrable+0xb/0x20
> >  [<c12653fd>] cpufreq_governor_dbs+0x1cd/0x210
> >  [<c126205b>] __cpufreq_governor+0xab/0x120
> >  [<c12621cb>] __cpufreq_set_policy+0xfb/0x140
> >  [<c1262c24>] store_scaling_governor+0xa4/0x220
> >  [<c1263550>] ? handle_update+0x0/0x10
> >  [<c1262b80>] ? store_scaling_governor+0x0/0x220
> >  [<c126343e>] store+0x4e/0x70
> >  [<c1106b9c>] sysfs_write_file+0x9c/0x100
> >  [<c10b825c>] vfs_write+0x9c/0x140
> >  [<c1106b00>] ? sysfs_write_file+0x0/0x100
> >  [<c10b8447>] sys_write+0x47/0xe0
> >  [<c1021dde>] syscall_call+0x7/0xb
> >  [<c1020000>] ? sys_vfork+0x20/0x30
> > 
> 
> It seems to be complaining that cpufreq_governor_dbs() is running
> init_timer() against a timer which has already been initialised once.
> 

In cpufreq_conservative.c, we have :

static inline void dbs_timer_init(void)
{
        init_timer_deferrable(&dbs_work.timer);
        schedule_delayed_work(&dbs_work,
                        usecs_to_jiffies(dbs_tuners_ins.sampling_rate));
        return;
}

static inline void dbs_timer_exit(void)
{
        cancel_delayed_work(&dbs_work);
        return;
}

Called respectively upon CPUFREQ_GOV_START and CPUFREQ_GOV_STOP.

commit 8217e4f4c93e5fb59bb3cd1e6135213889349f86
adds init_timer_deferrable(&dbs_work.timer);

The problem is that dbs_timer_exit() uses cancel_delayed_work() when it should
use cancel_delayed_work_sync(). cancel_delayed_work() does not wait for the
workqueue handler to exit. Therefore, the work can reschedule itself if the
correct race happens (do_dbs_timer() executing before holding the mutex, work
cancelled, do_dbs_timer() scheduled again, work rescheduled).

This leads to a timer list corruption when the conservative governor is
restarted, because the timer is still active.

However, we _cannot_ use cancel_delayed_work_sync() here because we would
deadlock between wait for workqueue and the fact that this workqueue may hold
the dbs_mutex (which we also hold).

The ondemand governor does not seem to be affected because the
"if (!dbs_info->enable)" check at the beginning of the workqueue handler returns
immediately without rescheduling the work. The conservative governor in
2.6.30-rc has the same check as the ondemand governor, which makes this problem
go away. However, if the governor is quickly stopped and then started, this
could lead to the following race :

Given that dbs_timer_exit cannot wait for the workqueue handler to exit because
it would otherwise deadlock on the dbs_mutex, making sure we don't reschedule
the work by testing the dbs_enable count seems to work most of the time.
However, there is still a potential problem if the governor is stopped and then
started while a do_dbs_timer workqueue is still active : dbs_enable could be
reenabled and multiple do_dbs_timer workqueue would run.  This is why a
synchronized teardown is required, and also why we need to use a different mutex
for do_dbs_timer so we don't deadlock.

The following patch applies to kernels 2.6.29.1 and 2.6.28.x. The problem was
there before, but it seems to really hurt with deferrable timers, which have
been introduced in the conservative governor only between 2.6.27 and 2.6.28.

Ingo : I would not be surprised if this was the mysterious memory
corruption bug I encountered on my laptop starting with kernel 2.6.28.
Back then, I switched to 2.6.27, waiting for 2.6.29 to fix it. Whenever my
computer switched between the performance and the conservative cpufreq modes,
more than once, it ended up corrupting the timer list. Given I don't switch
between battery and AC very often, and given that this bug is caused by a
preemption race on a UP machine, it explains why it was so hard to reproduce.

This would therefore close (for real this time) bug ID :

http://bugzilla.kernel.org/show_bug.cgi?id=12660

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: gregkh@suse.de
CC: stable@kernel.org
CC: cpufreq@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>
CC: rjw@sisk.pl
CC: Ben Slusky <sluskyb@paranoiacs.org>
CC: Dave Jones <davej@redhat.com>
CC: Chris Wright <chrisw@sous-sol.org>
---
 drivers/cpufreq/cpufreq_conservative.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng.git/drivers/cpufreq/cpufreq_conservative.c
===================================================================
--- linux-2.6-lttng.git.orig/drivers/cpufreq/cpufreq_conservative.c	2009-04-23 23:18:14.000000000 -0400
+++ linux-2.6-lttng.git/drivers/cpufreq/cpufreq_conservative.c	2009-04-23 23:53:34.000000000 -0400
@@ -75,12 +75,20 @@
 static unsigned int dbs_enable;	/* number of CPUs using this policy */
 
 /*
+ * dbs_mod_timer_mutex is used to protect the timer manipulation
+ * (creation/removal) so we can use a cancel_delayed_work_sync() to stop the
+ * workqueue without deadlocking with workqueue handler execution.
+ */
+static DEFINE_MUTEX (dbs_mod_timer_mutex);
+
+/*
  * DEADLOCK ALERT! There is a ordering requirement between cpu_hotplug
  * lock and dbs_mutex. cpu_hotplug lock should always be held before
  * dbs_mutex. If any function that can potentially take cpu_hotplug lock
  * (like __cpufreq_driver_target()) is being called with dbs_mutex taken, then
  * cpu_hotplug lock should be taken before that. Note that cpu_hotplug lock
  * is recursive for the same process. -Venki
+ * dbs_mutex nests inside dbs_mod_timer_mutex.
  */
 static DEFINE_MUTEX (dbs_mutex);
 static DECLARE_DELAYED_WORK(dbs_work, do_dbs_timer);
@@ -468,7 +476,7 @@
 
 static inline void dbs_timer_exit(void)
 {
-	cancel_delayed_work(&dbs_work);
+	cancel_delayed_work_sync(&dbs_work);
 	return;
 }
 
@@ -490,11 +498,13 @@
 		if (this_dbs_info->enable) /* Already enabled */
 			break;
 
+		mutex_lock(&dbs_mod_timer_mutex);
 		mutex_lock(&dbs_mutex);
 
 		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);
 		if (rc) {
 			mutex_unlock(&dbs_mutex);
+			mutex_unlock(&dbs_mod_timer_mutex);
 			return rc;
 		}
 
@@ -531,16 +541,21 @@
 
 			dbs_tuners_ins.sampling_rate = def_sampling_rate;
 
-			dbs_timer_init();
 			cpufreq_register_notifier(
 					&dbs_cpufreq_notifier_block,
 					CPUFREQ_TRANSITION_NOTIFIER);
 		}
 
 		mutex_unlock(&dbs_mutex);
+
+		if (dbs_enable == 1)
+			dbs_timer_init();
+
+		mutex_unlock(&dbs_mod_timer_mutex);
 		break;
 
 	case CPUFREQ_GOV_STOP:
+		mutex_lock(&dbs_mod_timer_mutex);
 		mutex_lock(&dbs_mutex);
 		this_dbs_info->enable = 0;
 		sysfs_remove_group(&policy->kobj, &dbs_attr_group);
@@ -549,15 +564,18 @@
 		 * Stop the timerschedule work, when this governor
 		 * is used for first time
 		 */
-		if (dbs_enable == 0) {
-			dbs_timer_exit();
+		if (dbs_enable == 0)
 			cpufreq_unregister_notifier(
 					&dbs_cpufreq_notifier_block,
 					CPUFREQ_TRANSITION_NOTIFIER);
-		}
 
 		mutex_unlock(&dbs_mutex);
 
+		if (dbs_enable == 0)
+			dbs_timer_exit();
+
+		mutex_unlock(&dbs_mod_timer_mutex);
+
 		break;
 
 	case CPUFREQ_GOV_LIMITS:

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
