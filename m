Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0BBREM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:04:12 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:52456 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab0BBREI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:04:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=maqXwJjud1BjDJ6QyFbn5dpZQQOcepmOoJiCvKmwpTU1fb9ID65a5JMCcuFs2Llftc
         GgT6T+vLGidUs1JmTak9Ivrbe3x4V/gM5MkeF5b0jIWKDEOfoM5RLwFpNBbDAbyfbDB6
         DBfingJOq9ntd/nq5UqygsunjTEuOII2reNGo=
MIME-Version: 1.0
In-Reply-To: <2c03f9591001182050r3617196v96eab70c309d268e@mail.gmail.com>
References: <2c03f9590911181948w3a9f68a3m6d55e09f537ba63c@mail.gmail.com>
	 <2c03f9591001182050r3617196v96eab70c309d268e@mail.gmail.com>
Date: Tue, 2 Feb 2010 15:04:03 -0200
X-Google-Sender-Auth: eeba82031bf82e66
Message-ID: <2c03f9591002020904o580b3f1cja5b8040929e607f9@mail.gmail.com>
Subject: Re: Oops with 2.6.32-rc6
From: "Lucas C. Villa Real" <lucasvr@gobolinux.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 2:50 AM, Lucas C. Villa Real
<lucasvr@gobolinux.org> wrote:
>
> On Thu, Nov 19, 2009 at 1:48 AM, Lucas C. Villa Real
> <lucasvr@gobolinux.org> wrote:
> > Hi,
> >
> > I recently decided to test 2.6.32-rc6 and I noticed that, whenever too
> > many disk activity happens, the system crashes. The error shown in the
> > traces below happened about 3 times in a week.
> >
> > Do you have any suggestions?
> >
> > Thanks,
> > Lucas
> >
>
> I just got a reproduction of the kernel oops with 2.6.33-rc4, whose
> original report can be seen at
> http://bugzilla.kernel.org/show_bug.cgi?id=14656.
>
> I'm seeing this problem while I'm stressing a FUSE file system which
> is sitting on top of ReiserFS 3. However, since some write operations
> in this test-case also operate in the root filesystem I cannot tell if
> FUSE has anything to do with this. Based on the stack trace I would
> say no.
>
> I have one complete message which shows the complete stack trace,
> found below, and another partial one which includes some debugging
> messages from CONFIG_DEBUG_LIST=y. The very line which is causing the
> problem is a list_del() in __rmqueue:
>
> (gdb) list *__rmqueue+0x98
> 0x963 is in __rmqueue (mm/page_alloc.c:730).
> 725                             continue;
> 726
> 727                     page = list_entry(area->free_list[migratetype].next,
> 728                                                             struct
> page, lru);
> 729                     list_del(&page->lru);
> 730                     rmv_page_order(page);
>
> "page" is a valid pointer, but it looks like the members of lru are
> corrupted, as seen in the first trace below:
>
> Jan 19 02:01:46 (none) kernel: ------------[ cut here ]------------
> Jan 19 02:01:47 (none) kernel: WARNING: at lib/list_debug.c:51
> list_del+0x41/0x60()
> Jan 19 02:01:47 (none) kernel: Hardware name: MacBook3,1
> Jan 19 02:01:47 (none) kernel: list_del corruption. next->prev should
> be c1b71018, but was 00005095
> Jan 19 02:01:47 (none) kernel: Modules linked in: tun ipv6
> acpi_cpufreq snd_pcm_oss snd_mixer_oss hfsplus ndiswrapper fuse
> snd_hda_codec_realtek snd_hda_
> intel snd_hda_codec joydev snd_hwdep sky2 applesmc led_class uvcvideo
> firewire_ohci rtc_cmos snd_pcm videodev firewire_core input_polldev
> rtc_core video
> output snd_timer v4l1_compat shpchp battery rtc_lib ac appletouch
> pcspkr snd thermal button processor ohci1394 pci_hotplug intel_agp
> snd_page_alloc iTCO_
> wdt i2c_i801 iTCO_vendor_support i2c_core
> Jan 19 02:01:47 (none) kernel: Pid: 30559, comm: lt-ltfs Tainted: P
> M       2.6.33-rc4-Gobo #3
> Jan 19 02:01:47 (none) kernel: Call Trace:
> Jan 19 02:01:47 (none) kernel:  [<c0137f28>] warn_slowpath_common+0x6a/0x81
> Jan 19 02:01:47 (none) kernel:  [<c0400811>] ? list_del+0x41/0x60
>
>
> For reference, this is the complete stack trace which I got yesterday:
>
> Jan 18 00:58:30 (none) kernel: BUG: unable to handle kernel NULL
> pointer dereference at 00000006
> Jan 18 00:58:30 (none) kernel: IP: [<c019b505>] __rmqueue+0x98/0x36c
> Jan 18 00:58:30 (none) kernel: *pdpt = 00000000298e7001 *pde = 0000000000000000
> Jan 18 00:58:30 (none) kernel: Oops: 0002 [#1] PREEMPT SMP
> Jan 18 00:58:30 (none) kernel: last sysfs file:
> /System/Kernel/Objects/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0003:00/power_supply/ADP1/online
> Jan 18 00:58:30 (none) kernel: Modules linked in: cdc_ether usbnet mii
> cdc_acm tun kqemu ndiswrapper dvb_usb_dib0700 dib7000p dib0090
> dib7000m dib0070 dv
> b_usb dib8000 dvb_core dib3000mc dibx000_common ipv6 acpi_cpufreq
> snd_pcm_oss snd_mixer_oss hfsplus fuse joydev snd_hda_codec_realtek
> applesmc led_class
> snd_hda_intel uvcvideo input_polldev snd_hda_codec videodev
> firewire_ohci video firewire_core output snd_hwdep v4l1_compat ac sky2
> battery snd_pcm i2c_i8
> 01 ohci1394 appletouch button thermal processor snd_timer snd i2c_core
> intel_agp snd_page_alloc iTCO_wdt iTCO_vendor_support rtc_cmos pcspkr
> rtc_core rtc
> _lib shpchp pci_hotplug
> Jan 18 00:58:30 (none) kernel:
> Jan 18 00:58:30 (none) kernel: Pid: 10381, comm: lt-ltfs Tainted: P
>       2.6.33-rc4-Gobo #1 Mac-F22788C8/MacBook3,1
> Jan 18 00:58:30 (none) kernel: EIP: 0060:[<c019b505>] EFLAGS: 00010086 CPU: 0
> Jan 18 00:58:30 (none) kernel: EIP is at __rmqueue+0x98/0x36c
> Jan 18 00:58:30 (none) kernel: EAX: 000001b8 EBX: c1b69000 ECX:
> 0000000a EDX: 00000002
> Jan 18 00:58:30 (none) kernel: ESI: c0bb69c0 EDI: c0bb6ccc EBP:
> f011ec64 ESP: f011ec2c
> Jan 18 00:58:30 (none) kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Jan 18 00:58:30 (none) kernel: Process lt-ltfs (pid: 10381,
> ti=f011e000 task=f004a610 task.ti=f011e000)
> Jan 18 00:58:30 (none) kernel: Stack:
> Jan 18 00:58:30 (none) kernel:  c01cc35e e9130990 00000000 00000000
> 00000010 00000000 c0bb6cb8 c0bb6cbc
> Jan 18 00:58:30 (none) kernel: <0> 00000002 c1b69018 00000010 c0bb69c0
> c1b78ff8 00000000 f011ecbc c019cb28
> Jan 18 00:58:30 (none) kernel: <0> 00000000 00000040 00000002 ffffffff
> 0000001f 00000020 00000000 c0bb7244
> Jan 18 00:58:30 (none) kernel: Call Trace:
> Jan 18 00:58:30 (none) kernel:  [<c01cc35e>] ? inode_get_bytes+0x48/0x54
> Jan 18 00:58:31 (none) kernel:  [<c019cb28>] ?
> get_page_from_freelist+0x14c/0x3ea
> Jan 18 00:58:31 (none) kernel:  [<c019ce8c>] ? __alloc_pages_nodemask+0xc6/0x49a
> Jan 18 00:58:31 (none) kernel:  [<c01980ac>] ? find_get_page+0x2d/0xaf
> Jan 18 00:58:31 (none) kernel:  [<c01986af>] ?
> grab_cache_page_write_begin+0x54/0x8e
> Jan 18 00:58:31 (none) kernel:  [<c021b54b>] ? reiserfs_write_begin+0x7b/0x1cf
> Jan 18 00:58:31 (none) kernel:  [<c0197a2d>] ?
> generic_file_buffered_write+0xd2/0x1d2
> Jan 18 00:58:31 (none) kernel:  [<c019939d>] ?
> __generic_file_aio_write+0x39f/0x3e0
> Jan 18 00:58:31 (none) kernel:  [<c01d9380>] ? wake_up_inode+0x1c/0x1e
> Jan 18 00:58:31 (none) kernel:  [<c023531d>] ? reiserfs_write_unlock+0x37/0x39
> Jan 18 00:58:31 (none) kernel:  [<c0851fcf>] ? _raw_spin_unlock+0xd/0x25
> Jan 18 00:58:31 (none) kernel:  [<c0199442>] ? generic_file_aio_write+0x64/0xab
> Jan 18 00:58:31 (none) kernel:  [<c01c9179>] ? do_sync_write+0x8e/0xc9
> Jan 18 00:58:31 (none) kernel:  [<c01d3906>] ? do_filp_open+0x564/0xa44
> Jan 18 00:58:31 (none) kernel:  [<c021f466>] ? reiserfs_file_write+0x6e/0x77
> Jan 18 00:58:31 (none) kernel:  [<c01c9b3e>] ? vfs_write+0x99/0x14c
> Jan 18 00:58:31 (none) kernel:  [<c021f3f8>] ? reiserfs_file_write+0x0/0x77
> Jan 18 00:58:31 (none) kernel:  [<c01c9cad>] ? sys_write+0x48/0x75
> Jan 18 00:58:31 (none) kernel:  [<c010345f>] ? sysenter_do_call+0x12/0x28
> Jan 18 00:58:31 (none) kernel: Code: 39 5d f0 75 06 41 e9 a0 00 00 00
> 8b 55 e8 c1 e2 03 89 55 f0 01 c2 8b 94 16 44 01 00 00 89 d3 83 eb 18
> 89 55 ec 8b 7b
>  1c 8b 53 18 <89> 7a 04 89 17 c7 43 1c 00 02 20 00 c7 43 18 00 01 10 00 8b 7d
>
>
> Do you have any suggestions on things that I should try? The last
> kernel version that I used which works just fine is 2.6.27.4, which is
> a bit old to look for possible regressions.

Hi, folks,

I compiled linux-2.6-stable from Git last night and just got a
reproduction of this oops.

A few days ago I took a diff from 2.6.27.4, which was the latest
stable version I had installed, to 2.6.33-rc4. All the significant
changes involve locking operations, such as the removal of the BKL and
lock contention fixes.

I'm about to rollback a few of these, starting with the BKL ones, in
an attempt to find the culprit. However I'd really like to have some
comments from some of you, as I'm not familiar with ReiserFS code.

The new trace finds below.

Thanks,
Lucas


Feb  2 14:40:32 (none) kernel: ------------[ cut here ]------------
Feb  2 14:40:32 (none) kernel: WARNING: at lib/list_debug.c:51
list_del+0x41/0x60()
Feb  2 14:40:32 (none) kernel: Hardware name: MacBook3,1
Feb  2 14:40:32 (none) kernel: list_del corruption. next->prev should
be c1b71018, but was 000056d5
Feb  2 14:40:32 (none) kernel: Modules linked in: ndiswrapper tun fuse
ipv6 acpi_cpufreq snd_pcm_oss snd_mixer_oss hfsplus
snd_hda_codec_realtek s
nd_hda_intel joydev sky2 snd_hda_codec uvcvideo applesmc led_class
snd_hwdep rtc_cmos videodev video snd_pcm firewire_ohci firewire_core
snd_timer
 input_polldev output v4l1_compat rtc_core battery snd ac shpchp
appletouch thermal processor button rtc_lib ohci1394 intel_agp
snd_page_alloc pci
_hotplug pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core [last
unloaded: fuse]
Feb  2 14:40:32 (none) kernel: Pid: 24395, comm: lnotes Tainted: P   M
      2.6.33-rc6-Gobo-00072-gab65832-dirty #1
Feb  2 14:40:32 (none) kernel: Call Trace:
Feb  2 14:40:32 (none) kernel:  [<c0137f50>] warn_slowpath_common+0x6a/0x81
Feb  2 14:40:32 (none) kernel:  [<c0400581>] ? list_del+0x41/0x60
Feb  2 14:40:32 (none) kernel:  [<c0137fa5>] warn_slowpath_fmt+0x29/0x2c
Feb  2 14:40:32 (none) kernel:  [<c0400581>] list_del+0x41/0x60
Feb  2 14:40:32 (none) kernel:  [<c019c1ca>] __rmqueue+0x9f/0x38f
Feb  2 14:40:32 (none) kernel:  [<c019d7a5>] get_page_from_freelist+0x151/0x3ea
Feb  2 14:40:32 (none) kernel:  [<c019db04>] __alloc_pages_nodemask+0xc6/0x49a
Feb  2 14:40:32 (none) kernel:  [<c01c61ad>] ?
mem_cgroup_charge_statistics+0xad/0xc5
Feb  2 14:40:32 (none) kernel:  [<c01c638d>] ?
__mem_cgroup_commit_charge+0xc1/0xd8
Feb  2 14:40:32 (none) kernel:  [<c0852ff1>] ? sub_preempt_count+0x8/0x74
Feb  2 14:40:32 (none) kernel:  [<c019ff65>] ? __lru_cache_add+0x71/0x89
Feb  2 14:40:32 (none) kernel:  [<c01aa9c7>] ? page_address+0xe/0xb5
Feb  2 14:40:32 (none) kernel:  [<c019ffa7>] ? lru_cache_add_lru+0x2a/0x2c
Feb  2 14:40:32 (none) kernel:  [<c01ad5dc>] handle_mm_fault+0x1ff/0x897
Feb  2 14:40:32 (none) kernel:  [<c01d9249>] ? __d_lookup+0xf1/0x10d
Feb  2 14:40:32 (none) kernel:  [<c0852fd3>] do_page_fault+0x350/0x366
Feb  2 14:40:32 (none) kernel:  [<c0852c83>] ? do_page_fault+0x0/0x366
Feb  2 14:40:32 (none) kernel:  [<c0850d53>] error_code+0x73/0x78
Feb  2 14:40:32 (none) kernel:  [<c085007b>] ? _raw_spin_unlock+0x2b/0x2c
Feb  2 14:40:32 (none) kernel:  [<c019894d>] ? file_read_actor+0x42/0xc6
Feb  2 14:40:32 (none) kernel:  [<c019a5a3>] generic_file_aio_read+0x327/0x50c
Feb  2 14:40:32 (none) kernel:  [<c01c9d86>] do_sync_read+0x8e/0xc9
Feb  2 14:40:32 (none) kernel:  [<c019ffa7>] ? lru_cache_add_lru+0x2a/0x2c
Feb  2 14:40:32 (none) kernel:  [<c011da3b>] ? native_set_pte_at+0xc/0x19
Feb  2 14:40:32 (none) kernel:  [<c0852ff1>] ? sub_preempt_count+0x8/0x74
Feb  2 14:40:32 (none) kernel:  [<c01c988a>] ?
generic_file_llseek_unlocked+0xe/0x84
Feb  2 14:40:32 (none) kernel:  [<c084ec93>] ? mutex_unlock+0x8/0x1b
Feb  2 14:40:32 (none) kernel:  [<c01c9dd2>] ? rw_verify_area+0x11/0xa7
Feb  2 14:40:32 (none) kernel:  [<c01ca8b5>] vfs_read+0x97/0x14a
Feb  2 14:40:32 (none) kernel:  [<c01c9cf8>] ? do_sync_read+0x0/0xc9
Feb  2 14:40:33 (none) kernel:  [<c01caa24>] sys_read+0x48/0x75
Feb  2 14:40:33 (none) kernel:  [<c010345f>] sysenter_do_call+0x12/0x28
Feb  2 14:40:33 (none) kernel: ---[ end trace c8086567704fab22 ]---
Feb  2 14:40:33 (none) kernel: BUG: unable to handle kernel NULL
pointer dereference at 00000006
