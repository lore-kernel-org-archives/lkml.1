Return-Path: <linux-kernel-owner+w=401wt.eu-S1161674AbXDXHL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161674AbXDXHL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161678AbXDXHL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:11:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161674AbXDXHLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:11:25 -0400
Date: Tue, 24 Apr 2007 00:09:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Prarit Bhargava <prarit@redhat.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
Message-Id: <20070424000936.85cf817f.akpm@linux-foundation.org>
In-Reply-To: <462DAA8C.10508@goop.org>
References: <20070327214919.800272641@goop.org>
	<20070327215827.871954359@goop.org>
	<20070423234910.50149faf.akpm@linux-foundation.org>
	<462DAA8C.10508@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 23:58:20 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > On Tue, 27 Mar 2007 14:49:20 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >   
> >> The softlockup watchdog is currently a nuisance in a virtual machine,
> >> since the whole system could have the CPU stolen from it for a long
> >> period of time.  While it would be unlikely for a guest domain to be
> >> denied timer interrupts for over 10s, it could happen and any softlockup
> >> message would be completely spurious.
> >>
> >> Earlier I proposed that sched_clock() return time in unstolen
> >> nanoseconds, which is how Xen and VMI currently implement it.  If the
> >> softlockup watchdog uses sched_clock() to measure time, it would
> >> automatically ignore stolen time, and therefore only report when the
> >> guest itself locked up.  When running native, sched_clock() returns
> >> real-time nanoseconds, so the behaviour would be unchanged.
> >>
> >> Note that sched_clock() used this way is inherently per-cpu, so this
> >> patch makes sure that the per-processor watchdog thread initialized
> >> its own timestamp.
> >>     
> >
> > This patch
> > (ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/ignore-stolen-time-in-the-softlockup-watchdog.patch)
> > causes six failures in the locking self-tests, which I must say is rather
> > clever of it.
> >   
> 
> Interesting.

I'll say.

>  Which variation of sched_clock do you have in your tree at
> the moment?

Andi's, plus the below fix.

Sigh.  I thought I was only two more bugs away from a release, then...


[18014389.347124] BUG: unable to handle kernel paging request at virtual address 6b6b7193
[18014389.347142]  printing eip:
[18014389.347149] c029a80c
[18014389.347156] *pde = 00000000
[18014389.347166] Oops: 0000 [#1]
[18014389.347174] Modules linked in: i915 drm ipw2200 sonypi ipv6 autofs4 hidp l2cap bluetooth sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables cpufreq_ondemand video sbs button battery asus_acpi ac nvram ohci1394 ieee1394 ehci_hcd uhci_hcd sg joydev snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm sr_mod cdrom snd_timer ieee80211 i2c_i801 piix ieee80211_crypt i2c_core generic snd soundcore snd_page_alloc ext3 jbd ide_disk ide_core
[18014389.347520] CPU:    0
[18014389.347521] EIP:    0060:[<c029a80c>]    Tainted: G      D VLI
[18014389.347522] EFLAGS: 00010296   (2.6.21-rc7-mm1 #35)
[18014389.347547] EIP is at input_release_device+0x8/0x4e
[18014389.347555] eax: c99709a8   ebx: 6b6b6b6b   ecx: 00000286   edx: 00000000
[18014389.347563] esi: 6b6b6b6b   edi: c99709cc   ebp: c21e3d40   esp: c21e3d38
[18014389.347571] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[18014389.347580] Process khubd (pid: 159, ti=c21e2000 task=c20a62f0 task.ti=c21e2000)
[18014389.347588] Stack: 6b6b6b6b c99709a8 c21e3d60 c029b489 c2014ec8 c9182000 c96b167c c9970954 
[18014389.347655]        c9970954 c99709cc c21e3d80 c029d401 c9977a6c c96b1000 c21e3d90 c9970954 
[18014389.347708]        c99709a8 c9164000 c21e3d90 c029d4b5 c96b1000 c9970564 c21e3db0 c029c50b 
[18014389.347771] Call Trace:
[18014389.347792]  [<c029b489>] input_close_device+0x13/0x51
[18014389.347810]  [<c029d401>] mousedev_destroy+0x29/0x7e
[18014389.347827]  [<c029d4b5>] mousedev_disconnect+0x5f/0x63
[18014389.347842]  [<c029c50b>] input_unregister_device+0x6a/0x100
[18014389.347858]  [<c02abf9c>] hidinput_disconnect+0x24/0x41
[18014389.347874]  [<c02aef29>] hid_disconnect+0x79/0xc9
[18014389.347889]  [<c028e1db>] usb_unbind_interface+0x47/0x8f
[18014389.347916]  [<c0256852>] __device_release_driver+0x74/0x90
[18014389.347933]  [<c0256c5f>] device_release_driver+0x37/0x4e
[18014389.347957]  [<c02561c6>] bus_remove_device+0x73/0x82
[18014389.347977]  [<c02547c1>] device_del+0x214/0x28c
[18014389.348132]  [<c028bb72>] usb_disable_device+0x62/0xc2
[18014389.348148]  [<c0288893>] usb_disconnect+0x99/0x126
[18014389.348163]  [<c0288d2c>] hub_thread+0x3a5/0xb07
[18014389.348178]  [<c012cbe5>] kthread+0x6e/0x79
[18014389.348194]  [<c0104917>] kernel_thread_helper+0x7/0x10
[18014389.348210]  =======================
[18014389.348218] INFO: lockdep is turned off.
[18014389.348224] Code: 5b 5d c3 55 b9 f0 ff ff ff 8b 50 0c 89 e5 83 ba 28 06 00 00 00 75 08 89 82 28 06 00 00 31 c9 5d 89 c8 c3 55 89 e5 56 53 8b 70 0c <39> 86 28 06 00 00 75 3a 8b 9e e4 08 00 00 c7 86 28 06 00 00 00 

I dunno.  I'll keep plugging for another couple hours then I'll shove
out what I have as a -mm snapshot whatsit.

Things are just ridiculous.  I'm thinking of having a hard-disk crash and
accidentally losing everything.



From: Andrew Morton <akpm@linux-foundation.org>

WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:sc_cpu_event from .data between 'sc_cpu_notifier' (at offset 0x2110) and 'mcelog'

Use hotcpu_notifier().  This takes care of making sure that the unused code
disappears from vmlinux if !CONFIG_HOTPLUG_CPU, too.

Please, test allnoconfig builds and watch for the warnings?

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sched-clock.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/i386/kernel/sched-clock.c~fix-x86_64-mm-sched-clock-share arch/i386/kernel/sched-clock.c
--- a/arch/i386/kernel/sched-clock.c~fix-x86_64-mm-sched-clock-share
+++ a/arch/i386/kernel/sched-clock.c
@@ -169,20 +169,15 @@ sc_cpu_event(struct notifier_block *self
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block sc_cpu_notifier = {
-	.notifier_call = sc_cpu_event
-};
-
 static __init int init_sched_clock(void)
 {
 	struct cpufreq_freqs f = { .cpu = get_cpu(), .new = 0 };
 	WARN_ON(num_online_cpus() > 1);
 	call_r_s_f(&f);
 	put_cpu();
-	register_cpu_notifier(&sc_cpu_notifier);
+	hotcpu_notifier(sc_cpu_event, 0);
 	cpufreq_register_notifier(&sc_freq_notifier,
 				 CPUFREQ_TRANSITION_NOTIFIER);
 	return 0;
 }
 core_initcall(init_sched_clock);
-
_

