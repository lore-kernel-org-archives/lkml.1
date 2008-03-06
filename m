Return-Path: <linux-kernel-owner+w=401wt.eu-S1761853AbYCFWtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761853AbYCFWtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYCFWtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:49:13 -0500
Received: from mail.xtech.com.ar ([216.75.63.130]:58531 "EHLO
	mail.xtech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbYCFWtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:49:11 -0500
Date: Thu, 6 Mar 2008 20:50:06 -0200
From: Diego Woitasen <diego@woitasen.com.ar>
To: Pavel Machek <pavel@ucw.cz>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: High resolution timer/dynticks bug
Message-ID: <20080306225006.GA2972@motherbox.xtech.com.ar>
References: <20080303010753.GB3512@motherbox.xtech.com.ar> <20080304110900.GA23227@elf.ucw.cz> <20080304230032.GA2967@motherbox.xtech.com.ar> <20080305082731.GA24004@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305082731.GA24004@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 09:27:31AM +0100, Pavel Machek wrote:
> Hi!
> > > > Hi!
> > > > 	I have problems when enable dynticks or hrtimers in kernel >=
> > > > 	2.6.24. It's easy to reproduce for me, when I enable either,
> > > > 	boots the machine, browse the web with Firefox or unplug the
> > > > 	power cable (i'm using a notebook) and the kernel freezes. I
> > > > 	could get a error message using NMI watchdog and netconsole.
> > > > 
> > > > 	Please, tell me if you need more information or testing.
> > > 
> > > 
> > > 
> > > > NMI Watchdog detected LOCKUP on CPU 0
> > > 
> > > Just turn off NMI watchdog?
> > > 
> > > Pulling the power cable causes the SMM trap, which takes _long_ to
> > > execute, potentially tickling NMI watchdog?
> > 
> > The system freezes silently without NMI watchdog :)
> 
> Ok... next hint:
> 
> > > > CPU 0 
> > > > Modules linked in: netconsole configfs fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 snd_hda_intel ecb crypto_blkcipher cryptomgr snd_pcm_oss snd_pcm snd_mixer_oss b43 mac80211 cfg80211 crc32 snd_seq_dummy snd_seq_oss firmware_class snd_seq_midi_event ieee80211softmac snd_seq ieee80211 ieee80211_crypt snd_timer snd_seq_device i2c_nforce2 sdhci rng_core ohci1394 snd i2c_core battery ac thermal processor forcedeth mmc_core psmouse ssb ieee1394 button soundcore snd_page_alloc ehci_hcd ohci_hcd usbcore
> > > > Pid: 0, comm: swapper Not tainted 2.6.25-rc3-porti-00081-g7704a8b #18
> > > > RIP: 0010:[<ffffffff80220799>]  [<ffffffff80220799>] hpet_readl+0x9/0x10
> 
> Is RIP always here? If so, can you pinpoint which part of hpet_readl
> causes the problem?
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

I reproduced the error ten times, and got the following results:

RIP: 0010:[<ffffffff80220799>]  [<ffffffff80220799>] hpet_readl+0x9/0x10
RIP: 0010:[<ffffffff80220799>]  [<ffffffff80220799>] hpet_readl+0x9/0x10
RIP: 0010:[<ffffffff8024894a>]  [<ffffffff8024894a>] getnstimeofday+0x1a/0xa0
RIP: 0010:[<ffffffff8021f4c9>]  [<ffffffff8021f4c9>] hpet_readl+0x9/0x10
RIP: 0010:[<ffffffff8021f4c9>]  [<ffffffff8021f4c9>] hpet_readl+0x9/0x10
RIP: 0010:[<ffffffff802489c0>]  [<ffffffff802489c0>] getnstimeofday+0x90/0xa0
RIP: 0010:[<ffffffff8021f4c9>]  [<ffffffff8021f4c9>] hpet_readl+0x9/0x10
RIP: 0010:[<ffffffff802489c0>]  [<ffffffff802489c0>] getnstimeofday+0x90/0xa0
RIP: 0010:[<ffffffff8021f4c9>] Process swapper (pid: 0, threadinfo ffffffff805e8000, task ffffffff805ac320)
RIP: 0010:[<ffffffff802489c0>]  [<ffffffff802489c0>] getnstimeofday+0x90/0xa0

Functions:
static void __iomem *hpet_virt_address;

unsigned long hpet_readl(unsigned long a)
{
        return readl(hpet_virt_address + a);
}

static __always_inline __u32 __readl(const volatile void __iomem *addr)
{
        return *(__force volatile __u32 *)addr;
}
#define readl(x) __readl(x)

----------------------------------------
void getnstimeofday(struct timespec *ts)
{
        unsigned long seq;
        s64 nsecs;

        do {
                seq = read_seqbegin(&xtime_lock);

                *ts = xtime;
                nsecs = __get_nsec_offset();

        } while (read_seqretry(&xtime_lock, seq));

        timespec_add_ns(ts, nsecs);
}


Functions disassemble:

(gdb) disassemble hpet_readl
Dump of assembler code for function hpet_readl:
0xffffffff8021f4c0 <hpet_readl+0>:      add    0x41ab69(%rip),%rdi        # 0xffffffff8063a030 <hpet_virt_address>
0xffffffff8021f4c7 <hpet_readl+7>:      mov    (%rdi),%eax
0xffffffff8021f4c9 <hpet_readl+9>:      mov    %eax,%eax
0xffffffff8021f4cb <hpet_readl+11>:     retq   
End of assembler dump.
(gdb) 

(gdb) disassemble getnstimeofday
Dump of assembler code for function getnstimeofday:
0xffffffff80248940 <getnstimeofday+0>:  push   %rbp
0xffffffff80248941 <getnstimeofday+1>:  mov    %rdi,%rbp
0xffffffff80248944 <getnstimeofday+4>:  push   %rbx
0xffffffff80248945 <getnstimeofday+5>:  sub    $0x8,%rsp
0xffffffff80248949 <getnstimeofday+9>:  mov    0x3f9cd1(%rip),%ebx        # 0xffffffff80642620 <xtime_lock>
0xffffffff8024894f <getnstimeofday+15>: jmp    0xffffffff80248953 <getnstimeofday+19>
0xffffffff80248951 <getnstimeofday+17>: mov    %edx,%ebx
0xffffffff80248953 <getnstimeofday+19>: mov    0x3f9cd6(%rip),%rax        # 0xffffffff80642630 <xtime>
0xffffffff8024895a <getnstimeofday+26>: mov    %rax,0x0(%rbp)
0xffffffff8024895e <getnstimeofday+30>: mov    0x3f9cd3(%rip),%rax        # 0xffffffff80642638 <xtime+8>
0xffffffff80248965 <getnstimeofday+37>: mov    %rax,0x8(%rbp)
0xffffffff80248969 <getnstimeofday+41>: mov    0x3f9d00(%rip),%rax        # 0xffffffff80642670 <clock>
0xffffffff80248970 <getnstimeofday+48>: callq  *0x20(%rax)
0xffffffff80248973 <getnstimeofday+51>: mov    %rax,%rsi
0xffffffff80248976 <getnstimeofday+54>: mov    0x3f9cf3(%rip),%rax        # 0xffffffff80642670 <clock>
0xffffffff8024897d <getnstimeofday+61>: sub    0x60(%rax),%rsi
0xffffffff80248981 <getnstimeofday+65>: mov    0x30(%rax),%edx
0xffffffff80248984 <getnstimeofday+68>: and    0x28(%rax),%rsi
0xffffffff80248988 <getnstimeofday+72>: mov    0x34(%rax),%ecx
0xffffffff8024898b <getnstimeofday+75>: imul   %rdx,%rsi
0xffffffff8024898f <getnstimeofday+79>: shr    %cl,%rsi
0xffffffff80248992 <getnstimeofday+82>: mov    0x3f9c88(%rip),%edx        # 0xffffffff80642620 <xtime_lock>
0xffffffff80248998 <getnstimeofday+88>: mov    %ebx,%eax
0xffffffff8024899a <getnstimeofday+90>: and    $0x1,%ebx
0xffffffff8024899d <getnstimeofday+93>: xor    %edx,%eax
0xffffffff8024899f <getnstimeofday+95>: or     %ebx,%eax
0xffffffff802489a1 <getnstimeofday+97>: jne    0xffffffff80248951 <getnstimeofday+17>
0xffffffff802489a3 <getnstimeofday+99>: mov    %rsi,%rax
0xffffffff802489a6 <getnstimeofday+102>:        add    0x8(%rbp),%rax
0xffffffff802489aa <getnstimeofday+106>:        cmp    $0x3b9ac9ff,%rax
0xffffffff802489b0 <getnstimeofday+112>:        ja     0xffffffff802489bd <getnstimeofday+125>
0xffffffff802489b2 <getnstimeofday+114>:        mov    %rax,0x8(%rbp)
0xffffffff802489b6 <getnstimeofday+118>:        add    $0x8,%rsp
0xffffffff802489ba <getnstimeofday+122>:        pop    %rbx
0xffffffff802489bb <getnstimeofday+123>:        pop    %rbp
0xffffffff802489bc <getnstimeofday+124>:        retq   
0xffffffff802489bd <getnstimeofday+125>:        mov    0x0(%rbp),%rdx
0xffffffff802489c1 <getnstimeofday+129>:        sub    $0x3b9aca00,%rax
0xffffffff802489c7 <getnstimeofday+135>:        inc    %rdx
0xffffffff802489ca <getnstimeofday+138>:        cmp    $0x3b9ac9ff,%rax
0xffffffff802489d0 <getnstimeofday+144>:        ja     0xffffffff802489c1 <getnstimeofday+129>
0xffffffff802489d2 <getnstimeofday+146>:        mov    %rdx,0x0(%rbp)
0xffffffff802489d6 <getnstimeofday+150>:        jmp    0xffffffff802489b2 <getnstimeofday+114>
End of assembler dump.
(gdb) 

Full messages:

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: netconsole configfs fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 snd_hda_intel ecb crypto_blkcipher cryptomgr snd_pcm_oss snd_pcm snd_mixer_oss b43 mac80211 cfg80211 crc32 snd_seq_dummy snd_seq_oss firmware_class snd_seq_midi_event ieee80211softmac snd_seq ieee80211 ieee80211_crypt snd_timer snd_seq_device i2c_nforce2 sdhci rng_core ohci1394 snd i2c_core battery ac thermal processor forcedeth mmc_core psmouse ssb ieee1394 button soundcore snd_page_alloc ehci_hcd ohci_hcd usbcore
Pid: 0, comm: swapper Not tainted 2.6.25-rc3-porti-00081-g7704a8b #18
RIP: 0010:[<ffffffff80220799>]  [<ffffffff80220799>] hpet_readl+0x9/0x10
RSP: 0018:ffffffff805e3e00  EFLAGS: 00000086
RAX: 00000000706c47ea RBX: 000000000002f3f4 RCX: 0000000000000020
RDX: 00000000ffffffc2 RSI: ffffffff805abcc0 RDI: ffffffffff5fc0f0
RBP: ffffffff805e3e48 R08: ffffffff805abcc0 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff80221010 R12: ffffffff805abcc0
R13: ffff81001cdf700c R14: 0000000000000004 R15: 0000000000000000
FS:  00007feeb1b826e0(0000) GS:ffffffff805da000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007feeb1b83315 CR3: 00000000155ea000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e2000, task ffffffff805a5320)
Stack:  ffffffff80249c33 ffffffff8021cec0 000000000002f3f4 ffffffff805e3e48
 ffffffff80247b9b ffffffff805e3e58 0000000000000000 00000039937b9f0c
 ffffffff80247bdc 0000000047c75913 0000000022adcfd4 0000000000000000
Call Trace:
 [<ffffffff80249c33>] ? getnstimeofday+0x33/0xa0
 [<ffffffff8021cec0>] ? lapic_next_event+0x0/0x10
 [<ffffffff80247b9b>] ? ktime_get_ts+0x1b/0x50
 [<ffffffff80247bdc>] ? ktime_get+0xc/0x50
 [<ffffffff8024cfa5>] ? tick_broadcast_set_event+0x25/0x50
 [<ffffffff8024d60e>] ? tick_broadcast_oneshot_control+0xfe/0x120
 [<ffffffff8024cc8d>] ? tick_notify+0x2cd/0x3c0
 [<ffffffff802486b1>] ? notifier_call_chain+0x51/0x70
 [<ffffffff8024c698>] ? clockevents_notify+0x18/0xa0
 [<ffffffff880a2e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff80447c3e>] ? cpuidle_idle_call+0x9e/0xe0
 [<ffffffff80447ba0>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020af50>] ? default_idle+0x0/0x60
 [<ffffffff8020b011>] ? cpu_idle+0x61/0xb0


Code: 38 41 00 89 0d 69 b4 38 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 90 90 90 90 90 90 90 90 90 90 48 03 3d 99 38 41 00 8b 07 <89> c0 c3 0f 1f 40 00 8b 05 92 38 41 00 85 c0 75 17 48 83 3d 6e 
---[ end trace cc7716e575d9d43d ]---
Kernel panic - not syncing: Attempted to kill the idle task!

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: netconsole configfs fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr snd_hda_intel b43 mac80211 snd_pcm_oss cfg80211 crc32 snd_pcm snd_mixer_oss firmware_class snd_seq_dummy ieee80211softmac sdhci snd_seq_oss ieee80211 ieee80211_crypt ohci1394 mmc_core snd_seq_midi_event i2c_nforce2 battery ac thermal button processor ieee1394 forcedeth rng_core snd_seq i2c_core psmouse ohci_hcd ssb snd_timer snd_seq_device ehci_hcd usbcore snd soundcoreR13: ffff81001bc3d00c R14: 0000000000000004 R15: 0000000000000000
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e2000, task ffffffff805a5320)
 ffffffff80249c33 ffffffff805e3e48
 0000000000000000
 ffffffff80247bdc 0000000000000000Call Trace:
 [<ffffffff8021cec0>] ? lapic_next_event+0x0/0x10
 [<ffffffff80247b9b>] ? ktime_get_ts+0x1b/0x50
 [<ffffffff80247bdc>] ? ktime_get+0xc/0x50
 [<ffffffff8024d60e>] ? tick_broadcast_oneshot_control+0xfe/0x120
 [<ffffffff8024cc8d>] ? tick_notify+0x2cd/0x3c0
 [<ffffffff802486b1>] ? notifier_call_chain+0x51/0x70
 [<ffffffff8024c698>] ? clockevents_notify+0x18/0xa0
 [<ffffffff880c2e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff80447ba0>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020af50>] ? default_idle+0x0/0x60
 [<ffffffff8020b011>] ? cpu_idle+0x61/0xb0
Code: 41 00 69 38 00 83 5b 41 5c 5d 41 5f 90 90 90 90 90 90 03 38 41 8b <89> c0 1f 00 8b 92 00 c0 75 48 6e Kernel panic - not syncing: Attempted to kill the idle task!

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: cpufreq_powersave netconsole configfs fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr snd_hda_intel b43 mac80211 snd_pcm_oss cfg80211 crc32 snd_pcm snd_mixer_oss firmware_class snd_seq_dummy ehci_hcd ieee80211softmac ohci_hcd sdhci snd_seq_oss ohci1394 ieee80211 ieee80211_crypt usbcore mmc_core snd_seq_midi_event battery ac ieee1394 thermal rng_core button psmouse forcedeth snd_seq snd_timer snd_seq_device processor i2c_nforce2 i2c_core snd soundcore snd_page_alloc ssb
Pid: 0, comm: swapper Not tainted 2.6.25-rc3-porti-00081-g7704a8b #18
RIP: 0010:[<ffffffff80220799>]  [<ffffffff80220799>] hpet_readl+0x9/0x10
RSP: 0018:ffffffff805e3e00  EFLAGS: 00000086
RAX: 00000000f057a179 RBX: 00000000000e2aea RCX: 0000000000000020
RDX: 00000000ffffffc2 RSI: ffffffff805abcc0 RDI: ffffffffff5fc0f0
RBP: ffffffff805e3e48 R08: ffffffff805abcc0 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff80221010 R12: ffffffff805abcc0
R13: ffff81001d98d00c R14: 0000000000000004 R15: 0000000000000000
FS:  00007f9498c706f0(0000) GS:ffffffff805da000(0000) knlGS:00000000f75446c0
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f949534f000 CR3: 000000001886c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e2000, task ffffffff805a5320)
Stack:  ffffffff80249c33 ffffffff8021cec0 00000000000e2aea ffffffff805e3e48
 ffffffff80247b9b ffffffff805e3e58 0000000000000000 0000009d94600786
 ffffffff80247bdc 0000000047c76150 000000002f11e126 0000000000000000
Call Trace:
 [<ffffffff80249c33>] ? getnstimeofday+0x33/0xa0
 [<ffffffff8021cec0>] ? lapic_next_event+0x0/0x10
 [<ffffffff80247b9b>] ? ktime_get_ts+0x1b/0x50
 [<ffffffff80247bdc>] ? ktime_get+0xc/0x50
 [<ffffffff8024cfa5>] ? tick_broadcast_set_event+0x25/0x50
 [<ffffffff8024d60e>] ? tick_broadcast_oneshot_control+0xfe/0x120
 [<ffffffff8024cc8d>] ? tick_notify+0x2cd/0x3c0
 [<ffffffff802486b1>] ? notifier_call_chain+0x51/0x70
 [<ffffffff8024c698>] ? clockevents_notify+0x18/0xa0
 [<ffffffff88033e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff80447c3e>] ? cpuidle_idle_call+0x9e/0xe0
 [<ffffffff80447ba0>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020af50>] ? default_idle+0x0/0x60
 [<ffffffff8020b011>] ? cpu_idle+0x61/0xb0


Code: 38 41 00 89 0d 69 b4 38 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 90 90 90 90 90 90 90 90 90 90 48 03 3d 99 38 41 00 8b 07 <89> c0 c3 0f 1f 40 00 8b 05 92 38 41 00 85 c0 75 17 48 83 3d 6e 
---[ end trace 00f16336241bb98c ]---
Kernel panic - not syncing: Attempted to kill the idle task!

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr b43 mac80211 cfg80211 crc32 snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss bcm43xx snd_seq_dummy firmware_class snd_seq_oss snd_seq_midi_event ieee80211softmac ohci_hcd sdhci ehci_hcd snd_seq ieee80211 ieee80211_crypt mmc_core ohci1394 i2c_nforce2 psmouse snd_timer snd_seq_device usbcore rng_core ieee1394 i2c_core ssb snd soundcore snd_page_alloc battery ac thermal button processor
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-porti #32
RAX: 00000000b77a9a0c RBX: 00000000000f73dc RCX: 0000000000000020
RDX: 00000000ffffffc2 RSI: ffffffff805b2b60 RDI: ffffffffff5fc0f0
RBP: ffffffff805e9e48 R08: ffffffff805b2b60 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8021fd40 R12: ffffffff805b2b60
R13: ffff81001c0fe00c R14: 0000000000000004 R15: 0000000000000000
FS:  00000000409b3950(0000) GS:ffffffff805e1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000f79d25d2 CR3: 00000000114b4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e8000, task ffffffff805ac320)
Stack:  ffffffff80248963 ffffffff8021c680 00000000000f73dc ffffffff805e9e48
 ffffffff802468cb ffffffff805e9e58 0000000000000000 00000094a7d9858c
 ffffffff8024690c 000000001c72bf0f 0000000000000000Call Trace:
 [<ffffffff80248963>] ? getnstimeofday+0x33/0xa0
 [<ffffffff8021c680>] ? lapic_next_event+0x0/0x10
 [<ffffffff802468cb>] ? ktime_get_ts+0x1b/0x50
 [<ffffffff8024690c>] ? ktime_get+0xc/0x50
 [<ffffffff8024bcd5>] ? tick_broadcast_set_event+0x25/0x50
 [<ffffffff8024b9bd>] ? tick_notify+0x2cd/0x3c0
 [<ffffffff802473e1>] ? notifier_call_chain+0x51/0x70
 [<ffffffff8024b3c8>] ? clockevents_notify+0x18/0xa0
 [<ffffffff88001e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff8044c6fe>] ? cpuidle_idle_call+0x9e/0xe0
 [<ffffffff8044c660>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020aef0>] ? default_idle+0x0/0x60
 [<ffffffff8020afb1>] ? cpu_idle+0x61/0xb0


Code: 89 c7 c4 e9 26 05 00 0f 1f 00 00 48 89 f7 58 b5 00 90 90 90 90 90 48 03 69 ab 00 8b 07 <89> 0f 40 00 8b 05 62 41 00 c0 17 48 3d 3e ---[ end trace 2428bcb7cde77123 ]---
Kernel panic - not syncing: Attempted to kill the idle task!

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: tcp_veno fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr b43 mac80211 cfg80211 crc32 snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss bcm43xx snd_seq_dummy firmware_class snd_seq_oss snd_seq_midi_event ieee80211softmac snd_seq ohci_hcd ieee80211 ieee80211_crypt ehci_hcd snd_timer snd_seq_device sdhci ohci1394 i2c_nforce2 rng_core snd psmouse mmc_core usbcore ieee1394 i2c_core ssb soundcore snd_page_alloc battery ac thermal button processor
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-porti #32
RIP: 0010:[<ffffffff8024894a>]  [<ffffffff8024894a>] getnstimeofday+0x1a/0xa0
RSP: 0018:ffffffff805e9e08  EFLAGS: 00000092
RAX: 0000000047cfdc07 RBX: 00000000000cf8c4 RCX: 0000000000000020
RDX: 00000000ffffffc2 RSI: ffffffff805b2b60 RDI: ffffffff805e9e48
RBP: ffffffff805e9e48 R08: ffffffff805b2b60 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8021fd40 R12: ffffffff805b2b60
R13: ffff81001c01600c R14: 0000000000000004 R15: 0000000000000000
FS:  00007fd59837f6e0(0000) GS:ffffffff805e1000(0000) knlGS:00000000f5afdb90
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000001126d64 CR3: 00000000181b6000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e8000, task ffffffff805ac320)
Stack:  ffffffff8021c680 00000000000cf8c4 ffffffff805e9e48 ffffffff802468cb
 ffffffff805e9e58 0000000000000000 00000070c7335983 ffffffff8024690c
 00000000000001e4 ffffffff8021fd6b 0000000000000000 ffffffff8024bcd5
Call Trace:
 [<ffffffff8021c680>] ? lapic_next_event+0x0/0x10
 [<ffffffff802468cb>] ? ktime_get_ts+0x1b/0x50
 [<ffffffff8024690c>] ? ktime_get+0xc/0x50
 [<ffffffff8021fd6b>] hpet_legacy_next_event+0x2b/0x50
 [<ffffffff8024bcd5>] ? tick_broadcast_set_event+0x25/0x50
 [<ffffffff8024c33e>] ? tick_broadcast_oneshot_control+0xfe/0x120
 [<ffffffff8024b9bd>] ? tick_notify+0x2cd/0x3c0
 [<ffffffff802473e1>] ? notifier_call_chain+0x51/0x70
 [<ffffffff8024b3c8>] ? clockevents_notify+0x18/0xa0
 [<ffffffff88001e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff8044c6fe>] ? cpuidle_idle_call+0x9e/0xe0
 [<ffffffff8044c660>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020aef0>] ? default_idle+0x0/0x60
 [<ffffffff8020afb1>] ? cpu_idle+0x61/0xb0

Code: df f8 48 c4 28 0f 1f 00 00 55 89 ec 08 1d 9c 3f eb d3 48 05 e6 3f 00 89 48 8b e3 9c 00 48 08 8b 05 9d 3f ---[ end trace e8678fd804e7bb70 ]---
Kernel panic - not syncing: Attempted to kill the idle task!

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: tcp_veno fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr snd_hda_intel snd_pcm_oss b43 mac80211 snd_pcm snd_mixer_oss cfg80211 crc32 snd_seq_dummy bcm43xx snd_seq_oss snd_seq_midi_event firmware_class snd_seq ieee80211softmac snd_timer snd_seq_device ieee80211 ieee80211_crypt ehci_hcd ohci_hcd rng_core snd sdhci ohci1394 i2c_nforce2 psmouse mmc_core ieee1394 usbcore i2c_core thermal ssb soundcore snd_page_alloc battery ac button processor
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-porti-funca #34
RIP: 0010:[<ffffffff8021f4c9>]  [<ffffffff8021f4c9>] hpet_readl+0x9/0x10
RSP: 0018:ffffffff805e9e00  EFLAGS: 00000086
RAX: 00000000508657b6 RBX: 000000000005699e RCX: 0000000000000020
RDX: 00000000ffffffc2 RSI: ffffffff805b2b60 RDI: ffffffffff5fc0f0
RBP: ffffffff805e9e48 R08: ffffffff805b2b60 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8021fd40 R12: ffffffff805b2b60
R13: ffff81001c05e00c R14: 0000000000000004 R15: 0000000000000000
FS:  00007f28ffc936e0(0000) GS:ffffffff805e1000(0000) knlGS:00000000f75216c0
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000002756900 CR3: 0000000012dbb000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e8000, task ffffffff805ac320)
Stack:  ffffffff80248963 ffffffff8021c680 000000000005699e ffffffff805e9e48
 ffffffff802468cb ffffffff805e9e58 0000000000000000 000000349646e23e
 ffffffff8024690c 0000000047cfe184 000000000cc16dba
 [<ffffffff80248963>] ? getnstimeofday+0x33/0xa0
 [<ffffffff8021c680>] ? lapic_next_event+0x0/0x10
 [<ffffffff802468cb>] ? ktime_get_ts+0x1b/0x50
 [<ffffffff8024690c>] ? ktime_get+0xc/0x50
 [<ffffffff8024bcd5>] ? tick_broadcast_set_event+0x25/0x50
 [<ffffffff8024c33e>] ? tick_broadcast_oneshot_control+0xfe/0x120
 [<ffffffff802473e1>] ? notifier_call_chain+0x51/0x70
 [<ffffffff8024b3c8>] ? clockevents_notify+0x18/0xa0
 [<ffffffff88001e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff8044c6fe>] ? cpuidle_idle_call+0x9e/0xe0
 [<ffffffff8044c660>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020aef0>] ? default_idle+0x0/0x60
 [<ffffffff8020afb1>] ? cpu_idle+0x61/0xb0
Code: 48 48 c4 08 26 b8 00 00 00 89 f7 b5 00 90 90 90 90 90 3d 69 41 00 07 c3 1f 40 8b 05 ab 85 c0 17 83 3d 
Kernel panic - not syncing: Attempted to kill the idle task!

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: tcp_veno fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr snd_hda_intel b43 mac80211 snd_pcm_oss snd_pcm cfg80211 crc32 snd_mixer_oss bcm43xx snd_seq_dummy snd_seq_oss firmware_class snd_seq_midi_event ieee80211softmac snd_seq ieee80211 ieee80211_crypt snd_timer snd_seq_device ohci_hcd ehci_hcd rng_core sdhci ohci1394 i2c_nforce2 snd thermal mmc_core psmouse usbcore ieee1394 i2c_core ssb soundcore snd_page_alloc battery ac button processor
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-porti-funca #34
 [<ffffffff8021f4c9>] hpet_readl+0x9/0x10
RAX: 00000000562ddd1a RBX: 000000000014e22c RCX: 0000000000000020
RDX: 00000000ffffffc2 RSI: ffffffff805b2b60 RDI: ffffffffff5fc0f0
R10: 0000000000000000 R11: ffffffff8021fd40 R12: ffffffff805b2b60
R13: ffff81001c11600c R14: 0000000000000004 R15: 0000000000000000
FS:  00007fc8739586f0(0000) GS:ffffffff805e1000(0000) knlGS:00000000f74d46c0
CR2: 000000000a207000 CR3: 00000000181b5000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e8000, task ffffffff805ac320)
 ffffffff8021c680
 ffffffff805e9e58
 0000000047d04b6d
 [<ffffffff80248963>] ? getnstimeofday+0x33/0xa0
 [<ffffffff8024690c>] ? ktime_get+0xc/0x50
 [<ffffffff8024bcd5>] ? tick_broadcast_set_event+0x25/0x50
 [<ffffffff8024c33e>] ? tick_broadcast_oneshot_control+0xfe/0x120
 [<ffffffff8024b9bd>] ? tick_notify+0x2cd/0x3c0
 [<ffffffff8024b3c8>] ? clockevents_notify+0x18/0xa0
 [<ffffffff88001e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff8044c660>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020aef0>] ? default_idle+0x0/0x60

89 c7 c4 26 00 1f 00 89 58 00 90 90 90 3d 41 07 c0 1f 05 41 85 17 3d 3e Kernel panic - not syncing: Attempted to kill the idle task!

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr b43 mac80211 cfg80211 crc32 snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy bcm43xx snd_seq_oss snd_seq_midi_event firmware_class snd_seq ieee80211softmac ohci_hcd ieee80211 ieee80211_crypt ehci_hcd snd_timer snd_seq_device sdhci ohci1394 rng_core psmouse mmc_core usbcore ieee1394 snd i2c_nforce2 soundcore snd_page_alloc i2c_core ssb battery ac thermal button processor
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-porti-funca #34
RIP: 0010:[<ffffffff8021f4c9>]  [<ffffffff8021f4c9>] hpet_readl+0x9/0x10
RSP: 0018:ffffffff805e9e00  EFLAGS: 00000086
RAX: 00000000bc26499f RBX: 00000000000a733c RCX: 0000000000000020
RDX: 00000000ffffffc2 RSI: ffffffff805b2b60 RDI: ffffffffff5fc0f0
RBP: ffffffff805e9e48 R08: ffffffff805b2b60 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8021fd40 R12: ffffffff805b2b60
R13: ffff81001c10400c R14: 0000000000000004 R15: 0000000000000000
FS:  00007f815ce056e0(0000) GS:ffffffff805e1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f48ce3a7000 CR3: 0000000019818000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e8000, task ffffffff805ac320)
Stack:  ffffffff8021c680
 0000000000000000 000000e55bf1e6de 0000000000000000
 [<ffffffff80248963>] ? getnstimeofday+0x33/0xa0
 [<ffffffff802468cb>] ? ktime_get_ts+0x1b/0x50
 [<ffffffff8024bcd5>] ? tick_broadcast_set_event+0x25/0x50
 [<ffffffff8024c33e>] ? tick_broadcast_oneshot_control+0xfe/0x120
 [<ffffffff802473e1>] ? notifier_call_chain+0x51/0x70
 [<ffffffff8024b3c8>] ? clockevents_notify+0x18/0xa0
 [<ffffffff88001e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff8044c660>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020aef0>] ? default_idle+0x0/0x60
Code: c7 c4 e9 05 0f 00 89 58 00 90 90 90 48 03 ab 8b <89> 0f 00 8b ab 00 75 17 3d ---[ end trace 10a50140e8089cfd ]---

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr snd_hda_intel b43 mac80211 snd_pcm_oss snd_pcm cfg80211 crc32 snd_mixer_oss bcm43xx snd_seq_dummy snd_seq_oss firmware_class snd_seq_midi_event ieee80211softmac snd_seq ieee80211 ieee80211_crypt snd_timer snd_seq_device ohci_hcd ehci_hcd rng_core sdhci ohci1394 i2c_nforce2 snd psmouse thermal mmc_core usbcore ieee1394 i2c_core ssb soundcore snd_page_alloc battery ac button processor
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-porti-funca #34
RIP: 0010:[<ffffffff802489c0>]  [<ffffffff802489c0>] getnstimeofday+0x90/0xa0
RSP: 0018:ffffffff805e9e08  EFLAGS: 00000016
RAX: 00000000a961fa65 RBX: 0000000000000000 RCX: 0000000000000016
RDX: 0000000047d057dd RSI: 000000013fa30177 RDI: ffffffffff5fc0f0
RBP: ffffffff805e9e48 R08: ffffffff805b2b60 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8021fd40 R12: ffffffff805b2b60
R13: ffff81001bd1700c R14: 0000000000000004 R15: 0000000000000000
FS:  00007f8ce41346e0(0000) GS:ffffffff805e1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fffec244e68 CR3: 0000000017dfc000 CR4: 00000000000006e0
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e8000, task ffffffff805ac320)
 ffffffff8021c680 ffffffff802468cb 0000000000000000 ffffffff8024690c 000000001c8f56ee
Call Trace:
 [<ffffffff802468cb>] ? ktime_get_ts+0x1b/0x50
 [<ffffffff8024bcd5>] ? tick_broadcast_set_event+0x25/0x50
 [<ffffffff8024c33e>] ? tick_broadcast_oneshot_control+0xfe/0x120
 [<ffffffff802473e1>] ? notifier_call_chain+0x51/0x70
 [<ffffffff8024b3c8>] ? clockevents_notify+0x18/0xa0
 [<ffffffff88001e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff8044c660>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020afb1>] ? cpu_idle+0x61/0xb0

f0 03 48 3d 9a 0b 89 48 08 c3 48 00 2d 9a 3b c2 3d 9a 3b 48 00 0f 84 00 48 48 ---[ end trace eda11acdc4f5198e ]---

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr b43 mac80211 cfg80211 crc32 snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss bcm43xx snd_seq_dummy firmware_class snd_seq_oss ieee80211softmac snd_seq_midi_event ieee80211 ieee80211_crypt snd_seq ohci_hcd ehci_hcd sdhci rng_core psmouse ohci1394 snd_timer snd_seq_device mmc_core i2c_nforce2 usbcore ieee1394 i2c_core snd soundcore snd_page_alloc ssb battery ac thermal button processor
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-porti-funca #34
RIP: 0010:[<ffffffff8021f4c9>]  [<ffffffff8021f4c9>] hpet_readl+0x9/0x10
RSP: 0018:ffffffff805e9e00  EFLAGS: 00000086
RAX: 000000000c77337a RBX: 00000000000300f8 RCX: 0000000000000020
RDX: 00000000ffffffc2 RSI: ffffffff805b2b60 RDI: ffffffffff5fc0f0
RBP: ffffffff805e9e48 R08: ffffffff805b2b60 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8021fd40 R12: ffffffff805b2b60
FS:  00007ff4402e56f0(0000) GS:ffffffff805e1000(0000) knlGS:00000000f74f66c0
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000394c0a0 CR3: 0000000016518000 CR4: 00000000000006e0
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e8000, task ffffffff805ac320)
 ffffffff80248963 ffffffff805e9e48 0000000000000000 00000029ef2fe7a5 0000000047d05a80
Call Trace:
 [<ffffffff8021c680>] ? lapic_next_event+0x0/0x10
 [<ffffffff8024690c>] ? ktime_get+0xc/0x50
 [<ffffffff8024bcd5>] ? tick_broadcast_set_event+0x25/0x50
 [<ffffffff8024b9bd>] ? tick_notify+0x2cd/0x3c0
 [<ffffffff8024b3c8>] ? clockevents_notify+0x18/0xa0
 [<ffffffff88001e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff8044c6fe>] ? cpuidle_idle_call+0x9e/0xe0
 [<ffffffff8020aef0>] ? default_idle+0x0/0x60

89 83 c4 26 00 0f 00 89 e9 90 90 90 90 3d 41 8b c0 0f 00 62 ab 85 48 83 
Kernel panic - not syncing: Attempted to kill the idle task!

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr b43 mac80211 cfg80211 crc32 snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy bcm43xx snd_seq_oss firmware_class snd_seq_midi_event ieee80211softmac snd_seq ieee80211 ieee80211_crypt ehci_hcd ohci_hcd snd_timer snd_seq_device sdhci ohci1394 rng_core mmc_core psmouse usbcore ieee1394 i2c_nforce2 snd thermal i2c_core ssb soundcore snd_page_alloc battery ac button processor
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-porti-funca #34
RIP: 0010:[<ffffffff802489c0>]  [<ffffffff802489c0>] getnstimeofday+0x90/0xa0
RSP: 0000:ffffffff805e9e08  EFLAGS: 00000012
RAX: 000000009a9950f6 RBX: 0000000000000000 RCX: 0000000000000016
RDX: 0000000047d05bdc RSI: 00000001495a39bc RDI: ffffffffff5fc0f0
RBP: ffffffff805e9e48 R08: ffffffff805b2b60 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8021fd40 R12: ffffffff805b2b60
R13: ffff81001d9a600c R14: 0000000000000004 R15: 0000000000000000
FS:  00007fc08c9dd6e0(0000) GS:ffffffff805e1000(0000) knlGS:00000000f74ec6c0
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000f66f6000 CR3: 0000000012974000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e8000, task ffffffff805ac320)
Stack:  ffffffff8021c680 0000000000037d74 ffffffff805e9e48 ffffffff802468cb
 ffffffff805e9e58 0000000000000000
 0000000000000000
 [<ffffffff8021c680>] ? lapic_next_event+0x0/0x10
 [<ffffffff8024690c>] ? ktime_get+0xc/0x50
 [<ffffffff8024bcd5>] ? tick_broadcast_set_event+0x25/0x50
 [<ffffffff8024b9bd>] ? tick_notify+0x2cd/0x3c0
 [<ffffffff802473e1>] ? notifier_call_chain+0x51/0x70
 [<ffffffff88001e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff8044c6fe>] ? cpuidle_idle_call+0x9e/0xe0
 [<ffffffff8044c660>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020afb1>] ? cpu_idle+0x61/0xb0
Code: 48 45 3d 9a 3b 48 45 83 c4 48 00 00 9a ff c2 ff 3b 48 00 0f 84 00 00 48 fb NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr b43 mac80211 cfg80211 crc32 snd_hda_intel snd_pcm_oss snd_pcm bcm43xx snd_mixer_oss firmware_class snd_seq_dummy ohci_hcd ieee80211softmac ieee80211 ieee80211_crypt ehci_hcd sdhci snd_seq_oss rng_core psmouse ohci1394 mmc_core snd_seq_midi_event usbcore ieee1394 snd_seq snd_timer snd_seq_device i2c_nforce2 i2c_core snd soundcore snd_page_alloc ssb battery ac thermal button processor
RIP: 0010:[<ffffffff8021f4c9>] Process swapper (pid: 0, threadinfo ffffffff805e8000, task ffffffff805ac320)

 ffffffff8024690cCall Trace:
 [<ffffffff802468cb>] ? ktime_get_ts+0x1b/0x50
 [<ffffffff8024c33e>] ? tick_broadcast_oneshot_control+0xfe/0x120
 [<ffffffff8024b3c8>] ? clockevents_notify+0x18/0xa0
 [<ffffffff8044c6fe>] ? cpuidle_idle_call+0x9e/0xe0
 [<ffffffff8044c660>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020afb1>] ? cpu_idle+0x61/0xb0

89 c7 c4 e9 05 66 0f 00 48 e9 b5 90 90 90 90 03 ab 41 <89> c0 00 62 41 c0 75 83 
---[ end trace 5645fbcea5096751 ]---

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 ecb crypto_blkcipher cryptomgr b43 mac80211 cfg80211 crc32 snd_hda_intel snd_pcm_oss bcm43xx snd_pcm firmware_class snd_mixer_oss ieee80211softmac ieee80211 ieee80211_crypt snd_seq_dummy ohci_hcd ehci_hcd sdhci snd_seq_oss rng_core psmouse ohci1394 mmc_core snd_seq_midi_event usbcore ieee1394 snd_seq snd_timer snd_seq_device i2c_nforce2 i2c_core snd thermal soundcore snd_page_alloc ssb battery ac button processor
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-porti-funca #34
RIP: 0010:[<ffffffff802489c0>]  [<ffffffff802489c0>] getnstimeofday+0x90/0xa0
RSP: 0018:ffffffff805e9e08  EFLAGS: 00000016
RAX: 00000000a6a6fdc4 RBX: 0000000000000000 RCX: 0000000000000016
RDX: 0000000047d05d9d RSI: 000000014307b071 RDI: ffffffffff5fc0f0
RBP: ffffffff805e9e48 R08: ffffffff805b2b60 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8021fd40 R12: ffffffff805b2b60
R13: ffff81001c78300c R14: 0000000000000004 R15: 0000000000000000
FS:  00007fe6f8f266e0(0000) GS:ffffffff805e1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fe6f9033000 CR3: 0000000019c5b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff805e8000, task ffffffff805ac320)
Stack:  ffffffff8021c680 ffffffff805e9e48 ffffffff805e9e58 0000000f1784cde0 0000000047d05d9a 00000000166fab53
 [<ffffffff8021c680>] ? lapic_next_event+0x0/0x10
 [<ffffffff802468cb>] ? ktime_get_ts+0x1b/0x50
 [<ffffffff8024bcd5>] ? tick_broadcast_set_event+0x25/0x50
 [<ffffffff8024c33e>] ? tick_broadcast_oneshot_control+0xfe/0x120
 [<ffffffff8024b9bd>] ? tick_notify+0x2cd/0x3c0
 [<ffffffff802473e1>] ? notifier_call_chain+0x51/0x70
 [<ffffffff88001e31>] ? :processor:acpi_idle_enter_bm+0x10f/0x31a
 [<ffffffff8044c6fe>] ? cpuidle_idle_call+0x9e/0xe0
 [<ffffffff8044c660>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020afb1>] ? cpu_idle+0x61/0xb0
f0 45 08 ff 9a 0b 45 08 83 5b 48 8b 48 ca 3b c2 48 c9 3b 48 89 00 0f 00 00 00 89 48 Kernel panic - not syncing: Attempted to kill the idle task!
 [<ffffffff8044c660>] ? cpuidle_idle_call+0x0/0xe0
 [<ffffffff8020aef0>] ? default_idle+0x0/0x60

df 48 48 c4 0f 00 00 55 89 48 ec 1d e1 00 89 48 8b <48> 00 48 e3 00 89 48 8b 9d 
Kernel panic - not syncing: Attempted to kill the idle task!

-- 

--------------
Diego Woitasen
