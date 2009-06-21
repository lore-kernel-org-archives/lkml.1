Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZFUUNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZFUUNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 16:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbZFUUNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 16:13:21 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35570 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZFUUNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 16:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=opPFIUtgn0NtIoSwSZVysCs6vDbRcMb74lOqzMcIjw5WQC+UdyQX36OznWjfMu4RWw
         8GpVWlb4N/uR0l0PuD1o2RtSJBVwu2l50DfChq2wAzuwxe9JSeamrvt9KrrNXkQk0VWf
         T1/rO1jIeZ9huao9yWn1F+UdhG8h/dW+MCi3Y=
MIME-Version: 1.0
In-Reply-To: <4A3E7F38.7030300@linux.intel.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <4A3E7F38.7030300@linux.intel.com>
Date: Sun, 21 Jun 2009 22:13:21 +0200
Message-ID: <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, seto.hidetoshi@jp.fujitsu.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/21 Andi Kleen <ak@linux.intel.com>:
> I assume it runs stable for hours without resume from disk?

I only test for 40 minutes. latest git hangs  4-5 minutes after resume
from s2disk

> And you made sure you don't use stale data from
> a different kernel for resume from disk?

I'm sure

>
> It is strange that resume from disk affects machine check.
> How is your resume setup?

You ask about "resume" kernel option?

maciek@zlom:~$ cat /proc/cmdline
root=/dev/sda2 ro resume=/dev/sda3 selinux=0

> Do you have any init scripts that change machine check state
> before the resume from disk runs?

No. I use default Debian instalation. I use this script, to do s2disk:

#!/bin/sh
umount /mnt/vista
umount /mnt/drugi
governor0=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
governor1=`cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor`
f_min_0=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
f_min_1=`cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq`
f_max_0=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
f_max_1=`cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq`
#rmmod snd_hda_intel
sync
hdparm -F /dev/sda
hdparm -F /dev/sdb
sleep 1
# hibernate
echo -n platform > /sys/power/disk
echo -n disk > /sys/power/state
echo $governor0 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo $governor1 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo $f_min_0 >  /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo $f_min_1 >  /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo $f_max_0 >  /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo $f_max_1 >  /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
#modprobe snd_hda_intel model=3stack-dig
sleep 1
/etc/init.d/hdparm restart
mount /mnt/vista
mount /mnt/drugi


>
> I assume you have CONFIG_X86_NEW_MCE enabled, correct?

maciek@zlom:~$ cat /boot/config-2.6.30-git17 | grep MCE
CONFIG_X86_MCE=y
# CONFIG_X86_OLD_MCE is not set
CONFIG_X86_NEW_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

> Does it still happen with CONFIG_X86_OLD_MCE instead?

I will check tomorrow.

>
> Also a "a few minutes" suggest something might be going wrong
> with the poll handler.  Does the problem still happen
> with you use CONFIG_X86_NEW_MCE again, but before
> resume do
>
> echo 0 > /sys/device/system/machinecheck/machinecheck0/check_interval
>
> On the other hand you should get a crash very fast with
>
> echo 1 > /sys/device/system/machinecheck/machinecheck0/check_interval

I didn't instructions from above, but I found something else. After
normal boot I try:

echo 1 > /sys/devices/system/machinecheck/machinecheck0/check_interval

I I found this in dmesg:

[  141.704025] ------------[ cut here ]------------
[  141.704039] WARNING: at arch/x86/kernel/cpu/mcheck/mce.c:1102
mcheck_timer+0xf5/0x100()
[  141.704044] Hardware name: G31M-S2L
[  141.704047] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
iptable_filter nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables
x_tables fuse dm_crypt dm_mod coretemp it87 hwmon_vid loop usbhid hid
btusb bluetooth snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device snd uhci_hcd ehci_hcd soundcore parport_pc parport
psmouse r8169 usbcore 8139too 8139cp mii i2c_i801 button rtc_cmos
rtc_core rtc_lib snd_page_alloc intel_agp agpgart evdev
[  141.704139] Pid: 0, comm: swapper Not tainted 2.6.30-git17 #1
[  141.704143] Call Trace:
[  141.704152]  [<c039382c>] ? printk+0x18/0x1c
[  141.704158]  [<c010f715>] ? mcheck_timer+0xf5/0x100
[  141.704165]  [<c013212c>] warn_slowpath_common+0x6c/0xc0
[  141.704170]  [<c010f715>] ? mcheck_timer+0xf5/0x100
[  141.704176]  [<c0132195>] warn_slowpath_null+0x15/0x20
[  141.704182]  [<c010f715>] mcheck_timer+0xf5/0x100
[  141.704188]  [<c013b99d>] run_timer_softirq+0x12d/0x1f0
[  141.704194]  [<c010f620>] ? mcheck_timer+0x0/0x100
[  141.704199]  [<c010f620>] ? mcheck_timer+0x0/0x100
[  141.704206]  [<c01372da>] __do_softirq+0x9a/0x130
[  141.704212]  [<c014b0ce>] ? hrtimer_interrupt+0xde/0x230
[  141.704217]  [<c039642f>] ? _spin_unlock+0xf/0x30
[  141.704224]  [<c01373a5>] do_softirq+0x35/0x40
[  141.704229]  [<c01375ad>] irq_exit+0x6d/0x90
[  141.704235]  [<c01167e8>] smp_apic_timer_interrupt+0x58/0x90
[  141.704241]  [<c0103856>] apic_timer_interrupt+0x2a/0x30
[  141.704248]  [<c010a662>] ? mwait_idle+0x62/0x70
[  141.704253]  [<c0101ee5>] cpu_idle+0x55/0x90
[  141.704259]  [<c0390b0b>] start_secondary+0x184/0x1f9
[  141.704264] ---[ end trace 54c5f0d77c70ea21 ]---
[  142.701022] ------------[ cut here ]------------
[  142.701036] WARNING: at arch/x86/kernel/cpu/mcheck/mce.c:1102
mcheck_timer+0xf5/0x100()
[  142.701041] Hardware name: G31M-S2L
[  142.701044] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
iptable_filter nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables
x_tables fuse dm_crypt dm_mod coretemp it87 hwmon_vid loop usbhid hid
btusb bluetooth snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device snd uhci_hcd ehci_hcd soundcore parport_pc parport
psmouse r8169 usbcore 8139too 8139cp mii i2c_i801 button rtc_cmos
rtc_core rtc_lib snd_page_alloc intel_agpagpgart evdev
[  142.701138] Pid: 0, comm: swapper Tainted: G        W  2.6.30-git17 #1
[  142.701142] Call Trace:
[  142.701151]  [<c039382c>] ? printk+0x18/0x1c
[  142.701156]  [<c010f715>] ? mcheck_timer+0xf5/0x100
[  142.701163]  [<c013212c>] warn_slowpath_common+0x6c/0xc0
[  142.701169]  [<c010f715>] ? mcheck_timer+0xf5/0x100
[  142.701174]  [<c0132195>] warn_slowpath_null+0x15/0x20
[  142.701180]  [<c010f715>] mcheck_timer+0xf5/0x100
[  142.701186]  [<c013b99d>] run_timer_softirq+0x12d/0x1f0
[  142.701192]  [<c010f620>] ? mcheck_timer+0x0/0x100
[  142.701197]  [<c010f620>] ? mcheck_timer+0x0/0x100
[  142.701204]  [<c01372da>] __do_softirq+0x9a/0x130
[  142.701210]  [<c014b0ce>] ? hrtimer_interrupt+0xde/0x230
[  142.701216]  [<c039642f>] ? _spin_unlock+0xf/0x30
[  142.701222]  [<c01373a5>] do_softirq+0x35/0x40
[  142.701228]  [<c01375ad>] irq_exit+0x6d/0x90
[  142.701234]  [<c01167e8>] smp_apic_timer_interrupt+0x58/0x90
[  142.701240]  [<c0103856>] apic_timer_interrupt+0x2a/0x30
[  142.701247]  [<c010a662>] ? mwait_idle+0x62/0x70
[  142.701252]  [<c0101ee5>] cpu_idle+0x55/0x90
[  142.701258]  [<c0390b0b>] start_secondary+0x184/0x1f9
[  142.701264] ---[ end trace 54c5f0d77c70ea22 ]---

It's stop when I do echo 0...

> Your dmesg also doesn't have anything related to resume from disk?

Dmesg after resume, but before hangs:
http://unixy.pl/maciek/download/kernel/2.6.30-git17/pc/dmesg-2.6.30-git17-after-resume.txt

Nothing weird.

>
> Thanks,
>
> -Andi
>

Thanks for ansfer.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
