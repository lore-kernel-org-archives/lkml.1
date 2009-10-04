Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbZJDOn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbZJDOn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 10:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZJDOn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 10:43:27 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:52887 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZJDOnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 10:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=u+bluVUOojChKURQnEYc4zR3fieux1yUAR2p8suXQaD1hLFwYUAw7W62PkzadBZSAA
         /PGOarKumy1BGchZWT/VLk2lue8toGTtzF6WKj6Gagb0oGJdogYBzs7MtaD0vzjCM+VT
         E5yyJAwVzCwb2qx0V400XNoERuEEW89XhZD0s=
Message-ID: <4AC8B4A8.3050601@tuffmail.co.uk>
Date: Sun, 04 Oct 2009 15:43:52 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: pm list <linux-pm@lists.linux-foundation.org>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.32-rc1: various BUGs on resume from hibernation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing a variety of BUGs on my EeePC 701 after hibernation.  
Sometimes they cause a hang during resume; sometimes they happen just 
after resume.  It doesn't happen all the time either -  I've just 
hibernated three times in a row with no problems.  It's most perplexing.

One resume hang showed a series of SCSI backtraces and errors.  
Unfortunately I wasn't able to capture it at the time.  They were most 
probably related to the root device, an SSD controlled by ata_piix.

Today on latest -git I captured this "bad swap file entry" problem.  I 
use a swap file for hibernation (I don't have a swap partition).

    Restarting tasks ... done.
    PM: Basic memory bitmaps freed
    swap_dup: Bad swap file entry 50055555
    swap_free: Bad swap file entry 50055555
    BUG: Bad page map in process kded4  pte:aaaaaa00aaaaaa pmd:173a1067
    addr:b2c71000 vm_flags:08100073 anon_vma:d77ff710 mapping:ddfdc74c
    index:a
    vma->vm_ops->fault: filemap_fault+0x0/0x2d2
    vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x3f
    Pid: 2558, comm: kded4 Not tainted 2.6.32-rc2eeepc-test #505
    Call Trace:
    print_bad_pte+0x1f5/0x207
    unmap_vmas+0x389/0x5a6
    exit_mmap+0x81/0xe8
    mmput+0x23/0x81
    flush_old_exec+0x30c/0x54c
    ? kernel_read+0x2e/0x3e
    load_elf_binary+0x338/0x10ca
    ? get_user_pages+0x39/0x41
    ? get_arg_page+0x32/0x82
    ? put_arg_page+0x8/0xa
    search_binary_handler+0xb2/0x212
    ? load_elf_binary+0x0/0x10ca
    do_execve+0x198/0x250
    sys_execve+0x26/0x49
    sysenter_do_call+0x12/0x28
    Disabling lock debugging due to kernel taint
    ...
    (several similar traces here)

Previously, on a slightly older kernel (still after 32-rc1), I captured 
this BUG in fget_light():

Restarting tasks ...
BUG: unable to handle kernel NULL pointer dereference at (null)
fget_light+0x39/0x79
*pdpt = 000000001be15001 *pde = 0000000000000000

last sysfs file: 
/sys/devices/pci0000:00/0000:00:1b.0/sound/card0/controlC0/uevent
Modules linked in: cpufreq_stats freq_table af_packet fbcon tileblit 
font bitblit softcursor i915 drm_kms_helper drm i2c_algo_bit cfbcopyarea 
cfbimgblt cfbfillrect ipv6 loop joydev snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss ath5k 
snd_pcm mac80211 ath uvcvideo snd_timer snd cfg80211 psmouse i2c_i801 
videodev v4l1_compat eeepc_laptop serio_raw pcspkr i2c_core rfkill 
snd_page_alloc battery ac processor pci_hotplug evdev intel_agp video 
agpgart backlight output button thermal fan [last unloaded: scsi_wait_scan]

Pid: 2199, comm: klauncher Not tainted (2.6.32-rc2eeepc-test #483) 701
EFLAGS: 00010296 CPU: 0
EIP is at fget_light+0x39/0x79
EAX: ffffffff EBX: 00000003 ECX: 00000000 EDX: dbe23f7c
ESI: dbe23f7c EDI: b6092ff4 EBP: dbe23bd8 ESP: dbe23bd0
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process klauncher (pid: 2199, ti=dbe22000 task=dbc61840 task.ti=dbe22000)
Stack:
 00000020 dbe23e7c dbe23f8c c01a62bd 00000001 d759c400 dbc61840 00000000
<0> 08088728 08088750 00000000 dbe23e74 dbe23ea4 00000000 00000000 00000000
<0> dbe23c18 00c7afc0 c01a6eb1 ffffffff 00000000 dbc61840 00000000 00000000
Call Trace:
? do_sys_poll+0x1be/0x39b
? __pollwait+0x0/0xaf
? pollwake+0x0/0x59
? pollwake+0x0/0x59
? pollwake+0x0/0x59
? pollwake+0x0/0x59
? pollwake+0x0/0x59
? sched_clock_cpu+0xab/0xbf
? check_preempt_wakeup+0x1c6/0x1ee
? default_wake_function+0xb/0xd
? pollwake+0x4c/0x59
? default_wake_function+0x0/0xd
? __wake_up_common+0x2e/0x54
? unix_stream_recvmsg+0x2fc/0x3c2
? __wake_up_sync_key+0x2b/0x3c
? __wake_up_sync+0xa/0xd
? skb_release_data+0x81/0x85
? update_curr+0xa1/0x11a
? rb_erase+0x10a/0x218
? __switch_to+0xcc/0x15e
? finish_task_switch+0x26/0x63
? schedule+0x3c5/0x3e6
? get_signal_to_deliver+0xa7/0x2dc
? do_notify_resume+0x83/0x6b6
? autoremove_wake_function+0x0/0x30
? ktime_get_ts+0xc3/0xcd
? do_restart_poll+0x2e/0x43
? sys_restart_syscall+0x11/0x13
? sysenter_do_call+0x12/0x28
Code: 8b 88 a0 03 00 00 c7 02 00 00 00 00 8b 01 48 75 17 8b 49 04 31 d2 
3b 19 73 4b 8d 04 9d 00 00 00 00 03 41 04 8b 10 eb 3d 8b 49 04 <3b> 19 
73 34 8d 04 9d 00 00 00 00 03 41 04 8b 10 85 d2 74 26 8b
fget_light+0x39/0x79 SS:ESP 0068:dbe23bd0
CR2: 0000000000000000
---[ end trace f0a940e691d70c2d ]---
done.
PM: Basic memory bitmaps freed
...
(several similar traces here)

I have full dmesgs for both of these.

I'm afraid I can't work out how to get line numbers in my backtraces, 
despite having the obvious two options enabled -

    CONFIG_DEBUG_BUGVERBOSE=y
    CONFIG_DEBUG_INFO=y

I will keep the vmlinux for my current kernel around and try 
markup_oops.pl as soon as I capture something it can handle.

All suggestions gratefully recieved :-)
Alan
