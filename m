Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbYENDnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbYENDnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 23:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbYENDnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 23:43:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757088AbYENDm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 23:42:59 -0400
Date: Tue, 13 May 2008 20:42:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aristeu Sergio Rozanski Filho <aris@ruivo.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] RFC: vt: fix vcs* sysfs file creation race
Message-Id: <20080513204241.559b772f.akpm@linux-foundation.org>
In-Reply-To: <20080501192131.GA4662@jake.ruivo.org>
References: <20080501192131.GA4662@jake.ruivo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 15:21:32 -0400 Aristeu Sergio Rozanski Filho <aris@ruivo.org> wrote:

> Currently there's a race on VT open/close path that can trigger messages
> like:
> 
> kobject_add_internal failed for vcs7 with -EEXIST, don't try to register
> things with the same name in the same direc.
> Pid: 2967, comm: vcs_stress Not tainted 2.6.25 #10
>  [<c04e852e>] kobject_add_internal+0x137/0x149
>  [<c04e85d4>] kobject_add_varg+0x35/0x41
>  [<c04e8645>] kobject_add+0x43/0x49
>  [<c055e54f>] device_add+0x91/0x4b4
>  [<c055e984>] device_register+0x12/0x15
>  [<c055e9f6>] device_create+0x6f/0x95
>  [<c053e69b>] vcs_make_sysfs+0x23/0x4f
>  [<c0543aff>] con_open+0x74/0x82
>  [<c0538b64>] tty_open+0x188/0x287
>  [<c047b1c8>] chrdev_open+0x119/0x135
>  [<c04775d4>] __dentry_open+0xcf/0x185
>  [<c0477711>] nameidata_to_filp+0x1f/0x33
>  [<c047b0af>] ? chrdev_open+0x0/0x135
>  [<c0477753>] do_filp_open+0x2e/0x35
>  [<c0627da6>] ? _spin_unlock+0x1d/0x20
>  [<c04774ef>] ? get_unused_fd_flags+0xc9/0xd3
>  [<c047779a>] do_sys_open+0x40/0xb5
>  [<c0477851>] sys_open+0x1e/0x26
>  [<c0404962>] syscall_call+0x7/0xb
>  =======================
> 
> this happens because con_release() releases acquire_console_sem(),
> con_open() acquires it, finds vc_cons[currcons] unused and calls
> vcs_make_sysfs() before con_release() is able to call
> vcs_remove_sysfs(). vcs_remove_sysfs() can sleep so calling it with
> console semaphore taken isn't a good idea.
> 
> But this isn't the only problem. Currently release_dev() checks for
> tty->count without holding any locks but BKL that is acquired on
> tty_release() and several tty drivers also check tty->count and some of
> them without even holding any locks. This leads to the case where two
> calls to release_dev()/tty->driver->close() can race and both find
> tty->count == 2 and don't release anything. I see two possibilities
> here:
> 1) We get rid of tty->count usage on drivers by implementing internal
> counters. This solution would allow us to fix each driver before
> converting tty->count into a kref and only be used by tty layer.
> This proposed patch does eliminate tty->count usage on vt.
> 2) We kill the current one open/close for each tty_open, only calling
> driver's open and close on the first open and last close. By looking on
> the tty drivers, none of them do anything important with multiple opens
> anyway (but I might be wrong on this).
> 
> So, before doing anything more intrusive, I'd to hear which option you
> find better.
> 
> To reproduce this problem, I use a simple stress program available at
> 	jake.ruivo.org / ~aris / vcs_stress.c
> with a simple script like
> 	while [ 1 ]; do sleep $((RANDOM % 15)); killall Xorg; done
> running multiple vcs_stress sessions also helps
> 
> This patch removes the use of tty->count and tty_mutex and replaces it
> by an internal kref and changes the code to only set vc_tty to NULL
> after the vcs_remove_sysfs() is done.
> 

SOrry, this patch causes one of my test machines to oops when I type "akpm" at
"login:":

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c023e5fe>] vt_ioctl+0x1a/0x1534
*pde = 00000000 
Oops: 0000 [#1] PREEMPT 
last sysfs file: /sys/class/net/eth1/address
Modules linked in: ipw2200 sonypi ipv6 autofs4 hidp l2cap sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables acpi_cpufreq nvram hci_usb bluetooth ohci1394 ehci_hcd ieee1394 uhci_hcd sg joydev snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq sr_mod snd_seq_device cdrom snd_pcm_oss snd_mixer_oss ieee80211 snd_pcm ieee80211_crypt snd_timer snd i2c_i801 soundcore i2c_core snd_page_alloc ide_pci_generic pcspkr piix button ext3 jbd ide_disk ide_core [last unloaded: ipw2200]

Pid: 2387, comm: login Not tainted (2.6.26-rc2-mm1 #11)
EIP: 0060:[<c023e5fe>] EFLAGS: 00010282 CPU: 0
EIP is at vt_ioctl+0x1a/0x1534
EAX: 00000000 EBX: 00005404 ECX: 00005404 EDX: f4c05cc0
ESI: bfe7e5d8 EDI: bfe7e5d8 EBP: f4c7fe28 ESP: f4c7fda4
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process login (pid: 2387, ti=f4c7e000 task=f6e8a060 task.ti=f4c7e000)
Stack: 00000000 f781e9d8 f6fbd000 00000000 00000000 00000000 0000000a 0000004d 
       00000369 ffffffff f6e8a060 00000001 00000002 00000000 00000002 00000000 
       00000000 c042c2f0 00000246 00000000 00000000 f4c7fe20 00000246 00000002 
Call Trace:
 [<c01cc039>] ? avc_has_perm_noaudit+0x1c/0x42a
 [<c01cc3a5>] ? avc_has_perm_noaudit+0x388/0x42a
 [<c023ace3>] ? tty_ioctl+0xd95/0xe2d
 [<c01cd19f>] ? avc_has_perm+0x3d/0x47
 [<c01cdabf>] ? inode_has_perm+0x5e/0x68
 [<c01566af>] ? unlock_page+0x24/0x27
 [<c0161ad0>] ? __do_fault+0x2b8/0x2f2
 [<c0239f4e>] ? tty_ioctl+0x0/0xe2d
 [<c017e2da>] ? vfs_ioctl+0x22/0x67
 [<c017e5f3>] ? do_vfs_ioctl+0x2d4/0x2f1
 [<c01d05bc>] ? selinux_file_ioctl+0xa3/0xa6
 [<c017e650>] ? sys_ioctl+0x40/0x5c
 [<c0103992>] ? syscall_call+0x7/0xb
 =======================
Code: c0 c7 00 00 00 00 00 89 d8 83 c4 34 5b 5e 5f 5d c3 55 89 e5 57 56 53 89 cb 83 ec 78 89 45 84 8b 75 08 8b 80 2c 02 00 00 89 45 88 <0f> b7 10 89 55 8c e8 75 fd 0d 00 8b 45 8c e8 2f 4a 00 00 85 c0 
EIP: [<c023e5fe>] vt_ioctl+0x1a/0x1534 SS:ESP 0068:f4c7fda4
---[ end trace d57ae71bf382c4d7 ]---

config: http://userweb.kernel.org/~akpm/config-sony.txt
dmesg: http://userweb.kernel.org/~akpm/dmesg-sony.txt
