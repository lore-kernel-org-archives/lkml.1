Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZBLIjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZBLIjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 03:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZBLIjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 03:39:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbZBLIjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 03:39:13 -0500
Date: Thu, 12 Feb 2009 09:38:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Clark Williams <williams@redhat.com>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>
Subject: [patch] irq threading: fix PF_HARDIRQ definition
Message-ID: <20090212083850.GA29995@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090211205533.329cea1c@torg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211205533.329cea1c@torg>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clark Williams <williams@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On Wed, 11 Feb 2009 23:43:44 +0100 (CET)
> Thomas Gleixner <tglx@tglx.de> wrote:
> 
> > After a 1.5 years sabbatical from preempt-rt we are pleased to
> > announce a refactored preempt-rt patch against linux-2.6.29-rc4.
> 
> 
> Hi Thomas, 
> 
> I got the following after booting on my T60:
> 
> - ------------[ cut here ]------------
> WARNING: at crypto/blkcipher.c:327 blkcipher_walk_first+0x72/0x1aa()
> Hardware name:
> Modules linked in: fuse i915 drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect autofs4 coretemp sunrpc nf_conntrack_netbios_ns xt_state ipt_REJECT iptable_filter ip_tables cpufreq_ondemand dm_multipath scsi_dh uinput btusb bluetooth sg snd_hda_codec_analog snd_hda_intel snd_hda_codec iwl3945 snd_hwdep e1000e lib80211 snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss video snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc i2c_i801 i2c_core thinkpad_acpi rfkill output iTCO_wdt iTCO_vendor_support button joydev hwmon dm_snapshot dm_zero dm_mirror dm_region_hash dm_log uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
> Pid: 9, comm: sirq-tasklet/0 Not tainted 2.6.29-rc4-rt1-tip #50
> Call Trace:
>  [<ffffffff8023bd23>] warn_slowpath+0xaf/0xd6
>  [<ffffffff8035d176>] blkcipher_walk_first+0x72/0x1aa
>  [<ffffffff802309cb>] ? enqueue_task_fair+0x25/0x68
>  [<ffffffff8035d2f6>] blkcipher_walk_virt+0x1a/0x1c
>  [<ffffffff803620af>] crypto_ecb_crypt+0x2b/0x9a
>  [<ffffffff80359d20>] ? setkey+0xc4/0xd8
>  [<ffffffff8036426a>] ? arc4_crypt+0x0/0x5e
>  [<ffffffff8036214f>] crypto_ecb_decrypt+0x31/0x33
>  [<ffffffff8035c8fb>] ? setkey+0xba/0xcd
>  [<ffffffff8022bf8f>] ? __wake_up_common+0x49/0x7f
>  [<ffffffff80519beb>] ieee80211_wep_decrypt_data+0x5e/0x95
>  [<ffffffff80519d3a>] ieee80211_wep_decrypt+0x118/0x16f
>  [<ffffffff80519ddc>] ieee80211_crypto_wep_decrypt+0x4b/0x93
>  [<ffffffff80524d8f>] ieee80211_invoke_rx_handlers+0x26b/0x1395
>  [<ffffffff8021ce0f>] ? native_smp_send_reschedule+0x59/0x5b
>  [<ffffffff8022c699>] ? resched_task+0x60/0x62
>  [<ffffffff802367a9>] ? try_to_wake_up+0x352/0x364
>  [<ffffffff802367ca>] ? default_wake_function+0xf/0x11
>  [<ffffffff80526418>] __ieee80211_rx_handle_packet+0x55f/0x59c
>  [<ffffffff80526c82>] __ieee80211_rx+0x508/0x572
>  [<ffffffff80517451>] ieee80211_tasklet_handler+0x6d/0xff
>  [<ffffffff80241192>] __tasklet_action+0xa1/0x112
>  [<ffffffff80241277>] tasklet_action+0x39/0x3b
>  [<ffffffff80240eef>] ksoftirqd+0x162/0x278
>  [<ffffffff80240d8d>] ? ksoftirqd+0x0/0x278
>  [<ffffffff80240d8d>] ? ksoftirqd+0x0/0x278
>  [<ffffffff8024f5ce>] kthread+0x48/0x73
>  [<ffffffff8020cf6a>] child_rip+0xa/0x20
>  [<ffffffff8024f586>] ? kthread+0x0/0x73
>  [<ffffffff8020cf60>] ? child_rip+0x0/0x20
> - ---[ end trace b6a0ff9dfe960c5e ]---
> 
> It booted to runlevel 5, brought up GDM, I logged in and XFCE came up
> fine. It wasn't until NetworkManager started dorking around with the
> 802.11 adapter and started doing WEP things that I got the above
> warning. Right after I got this, NetworkManager connected and the
> system locked up. Sorry, no traceback from the panic.
> 
> I haven't gone far in looking at this, but it looks like we might have
> to adjust expectations in the crypto code, since it's probably ok to
> be in_irq() in this case, since we're actually in a kthread.

no, removing the warning would just hide the real bug.

Could you try the fix below please?

	Ingo

--------------------------------->
Subject: irq threading: fix PF_HARDIRQ definition
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Feb 12 09:29:14 CET 2009

Clark Williams reported the following warning:

  WARNING: at crypto/blkcipher.c:327 blkcipher_walk_first+0x72/0x1aa()

 [<ffffffff8035d176>] blkcipher_walk_first+0x72/0x1aa
 [<ffffffff8035d2f6>] blkcipher_walk_virt+0x1a/0x1c
 [<ffffffff803620af>] crypto_ecb_crypt+0x2b/0x9a
 [<ffffffff8036214f>] crypto_ecb_decrypt+0x31/0x33
 [<ffffffff80519beb>] ieee80211_wep_decrypt_data+0x5e/0x95
 [<ffffffff80519d3a>] ieee80211_wep_decrypt+0x118/0x16f
 [<ffffffff80519ddc>] ieee80211_crypto_wep_decrypt+0x4b/0x93
 [<ffffffff80524d8f>] ieee80211_invoke_rx_handlers+0x26b/0x1395
 [<ffffffff80526418>] __ieee80211_rx_handle_packet+0x55f/0x59c
 [<ffffffff80526c82>] __ieee80211_rx+0x508/0x572
 [<ffffffff80517451>] ieee80211_tasklet_handler+0x6d/0xff
 [<ffffffff80241192>] __tasklet_action+0xa1/0x112
 [<ffffffff80241277>] tasklet_action+0x39/0x3b
 [<ffffffff80240eef>] ksoftirqd+0x162/0x278

Which comes from:

        if (WARN_ON_ONCE(in_irq()))
                return -EDEADLK;

This warning is surprising, as it clearly comes from a softirq
context.

The in_irq() definition looks like this on -rt:

  #define in_irq()        (hardirq_count() || (current->flags & PF_HARDIRQ))

hardirq_count() is correct, but looking at PF_HARDIRQ's definition in sched.h:

 #define PF_EXITPIDONE  0x00000008      /* pi exit done on shut down */
 #define PF_VCPU        0x00000010      /* I'm a virtual CPU */
 #define PF_HARDIRQ     0x08000020      /* hardirq context */
 #define PF_NOSCHED     0x00000020      /* Userspace does not expect scheduling */
 #define PF_FORKNOEXEC  0x00000040      /* forked but didn't exec */

Reveals that due to a typo it not only overlaps the PF_NOSCHED bit, but
also has a spurious 0x08000000 component.

Move it to a free slot: 0x00000080.

Reported-by: Clark Williams <williams@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -1721,9 +1721,9 @@ extern cputime_t task_gtime(struct task_
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
-#define PF_HARDIRQ	0x08000020	/* hardirq context */
 #define PF_NOSCHED	0x00000020	/* Userspace does not expect scheduling */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
+#define PF_HARDIRQ	0x00000080	/* hardirq context */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
 #define PF_DUMPCORE	0x00000200	/* dumped core */
 #define PF_SIGNALED	0x00000400	/* killed by a signal */
