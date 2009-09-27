Return-Path: <linux-kernel-owner+w=401wt.eu-S1752981AbZI0OBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbZI0OBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 10:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZI0OBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 10:01:04 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:48733 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbZI0OBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 10:01:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IS4esbx9rCcoQ9drJzfTGUEI43DjLjSjrFShW5XYChB7a3fEw4661rw9yVYx52ttVF
         uDlB0iIhErvvq5itBwD97OXKGJig7brLGJ9ZAq7Mo+g8qtqeYk9I/JIbcCEIMgmOMZKK
         PSyRPo/mr/NI123nDtzn/P+eeZjFP4RWixpcY=
MIME-Version: 1.0
In-Reply-To: <8db1092f0909270325j67825cem82fc93cf19336d6f@mail.gmail.com>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
	 <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
	 <2674af740909270130h359a5d23taa7e8b63e6a18a4d@mail.gmail.com>
	 <8db1092f0909270325j67825cem82fc93cf19336d6f@mail.gmail.com>
Date: Sun, 27 Sep 2009 22:01:07 +0800
Message-ID: <2674af740909270701u6febabdbpc5c772fabc193b32@mail.gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
	hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
	__sysdev_resume+0xc3/0xe0()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 6:25 PM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> 2009/9/27 Yong Zhang <yong.zhang0@gmail.com>:
>>
>> Oops, TABLE is corrupted. Please use the attachment.
>
> kernel/time/timekeeping.c: In function ‘timekeeping_resume’:
> kernel/time/timekeeping.c:577: error: ‘xtime_locks’ undeclared (first
> use in this function)
> kernel/time/timekeeping.c:577: error: (Each undeclared identifier is
> reported only once
> kernel/time/timekeeping.c:577: error: for each function it appears
> in.)
> make[3]: *** [kernel/time/timekeeping.o] Błąd 1
> make[2]: *** [kernel/time] Błąd 2
>
>
> I change:
> write_seqlock(&xtime_locks);
> to:
> write_seqlock(&xtime_lock);
>

Oh, typo error.

> Corrected patch in attachment.
>
> First warning has gone, but still I have this:
> [  120.868049] SMP alternatives: switching to UP code
> [  120.872570] CPU0 attaching NULL sched-domain.
> [  120.872574] CPU1 attaching NULL sched-domain.
> [  120.872581] CPU0 attaching NULL sched-domain.
> [  120.872787] CPU1 is down
> [  120.872846] Extended CMOS year: 2000
> [  120.872945] PM: Creating hibernation image:
> [  120.876009] PM: Need to copy 107120 pages
> [  120.872009] PM: Restoring platform NVS memory
> [  120.872009] CPU0: Thermal monitoring handled by SMI
> [  120.872009] Extended CMOS year: 2000
> [  120.872009] ------------[ cut here ]------------
> [  120.872009] WARNING: at drivers/base/sys.c:353
> __sysdev_resume+0xc3/0xe0()
> [  120.872009] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
> [  120.872009] Interrupts enabled after timekeeping_resume+0x0/0x1c0

Irq is enabled after timekeeping_resume(), the previous patch do something
sensible. But we even don't know when the irq is enabled. such as in
timekeeping_resume() or before enter timekeeping_resume(). But it
seem that this is not due to timekeeping_resume(). Instead I'm afraid
it's caused by buggy driver.

So can you test the follow patch. And show the dmesg info(DEBUG
level) after WARNING is triggered?

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fb0f46f..4a00a1a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -569,6 +569,9 @@ static int timekeeping_resume(struct sys_device *dev)
 	unsigned long flags;
 	struct timespec ts;

+	WARN_ONCE(!irqs_disabled(),
+		KERN_INFO "timekeeping_resume() called with IRQs enabled!");
+
 	read_persistent_clock(&ts);

 	clocksource_resume();

Thanks,
Yong

> [  120.872009] Modules linked in: i915 drm_kms_helper drm i2c_algo_bit
> i2c_core sco bnep rfcomm l2cap crc16 xt_tcpudp xt_limit xt_state
> iptable_filter nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables
> x_tables aes_i586 aes_generic cbc dm_crypt dm_snapshot dm_mirror
> dm_region_hash dm_log dm_mod hp_wmi fuse sbp2 loop
> snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel snd_hda_codec
> snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy arc4 snd_seq_oss ecb
> snd_seq_midi snd_rawmidi iwl3945 snd_seq_midi_event iwlcore btusb
> firmware_class snd_seq bluetooth snd_timer mac80211 pcmcia
> snd_seq_device led_class b44 video ohci1394 backlight ssb rtc_cmos snd
> yenta_socket cfg80211 intel_agp soundcore rsrc_nonstatic uhci_hcd
> ehci_hcd rtc_core usbcore psmouse snd_page_alloc agpgart pcmcia_core
> rfkill rtc_lib ieee1394 sg output evdev serio_raw mii fan button ac
> battery
> [  120.872009] Pid: 3510, comm: pm-hibernate Not tainted 2.6.31-git17
> #1
> [  120.872009] Call Trace:
> [  120.872009]  [<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
> [  120.872009]  [<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
> [  120.872009]  [<c013c3a1>] warn_slowpath_common+0x71/0xc0
> [  120.872009]  [<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
> [  120.872009]  [<c013c43b>] warn_slowpath_fmt+0x2b/0x30
> [  120.872009]  [<c030f4a3>] __sysdev_resume+0xc3/0xe0
> [  120.872009]  [<c015f810>] ? timekeeping_resume+0x0/0x1c0
> [  120.872009]  [<c030f50f>] sysdev_resume+0x4f/0xc0
> [  120.872009]  [<c0176909>] ? hibernate_nvs_restore+0x19/0x60
> [  120.872009]  [<c0172ac1>] hibernation_snapshot+0x1d1/0x210
> [  120.872009]  [<c0171b54>] ? freeze_processes+0x44/0xa0
> [  120.872009]  [<c0172bef>] hibernate+0xef/0x190
> [  120.872009]  [<c0171590>] ? state_store+0x0/0xc0
> [  120.872009]  [<c017163b>] state_store+0xab/0xc0
> [  120.872009]  [<c0171590>] ? state_store+0x0/0xc0
> [  120.872009]  [<c0285e04>] kobj_attr_store+0x24/0x30
> [  120.872009]  [<c0223d82>] sysfs_write_file+0xa2/0x100
> [  120.872009]  [<c01d880c>] vfs_write+0x9c/0x150
> [  120.872009]  [<c0223ce0>] ? sysfs_write_file+0x0/0x100
> [  120.872009]  [<c01d8982>] sys_write+0x42/0x70
> [  120.872009]  [<c0102f04>] sysenter_do_call+0x12/0x22
> [  120.872009] ---[ end trace 51d3cc987b340170 ]---
> [  120.872009] Enabling non-boot CPUs ...
> [  120.872009] SMP alternatives: switching to SMP code
>
> Regards
> --
> Maciej Rutecki
> http://www.maciek.unixy.pl
>
