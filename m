Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbXDQJI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbXDQJI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 05:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXDQJI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 05:08:57 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:43489 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbXDQJIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 05:08:53 -0400
From: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
Organization: Adaptec
To: linux-kernel@vger.kernel.org
Subject: BUG in sysfs_remove_group
Date: Tue, 17 Apr 2007 14:29:53 +0530
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704171429.53115.nagendra_tomar@adaptec.com>
X-OriginalArrivalTime: 17 Apr 2007 09:08:44.0717 (UTC) FILETIME=[00229DD0:01C780D0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of lookup_one_len() is used without testing for error return. 
This results in the following oops when SELinux is enabled and enforced.  The 
reason for the Oops is as follows.
	The shell's (bash) SELinux domain is not allowed "search" permission in sysfs 
filesystem (type sysfs_t in the default SELinux policy), due to which the 
lookup_one_len->__lookup_hash->permission->security_inode_permission 
returns -EACCESS. This -ve number is passed as the 'dir' argument to 
remove_files()  and then to sysfs_hash_and_remove() which accesses this bogus 
pointer resulting in the crash.
	A simple fix will be to check for IS_ERR(dir) in sysfs_remove_group() and 
return (without doing anything) if true, but this will result in the 
corresponding sysfs dirent entries to be leaked. IMHO the proper fix will be 
to not check for "search" permissions in such cases where the internal kernel 
code is trying to free up sysfs entries like the current case.

Comments ?


- Tomar


 
 BUG: unable to handle kernel paging request at virtual address fffffffb
  printing eip:
 c01aa182
 *pde = 00002067
 *pte = 00000000
 Oops: 0000 [#1]
 PREEMPT 
 Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usb_storage i915 usbhid 
autofs4 hidp rfcomm l2cap bluetooth vmnet(P) parport_pc vmmon(P) sunrpc 
iscsi_tcp libiscsi scsi_transport_iscsi ipv6 dm_mirror dm_multipath dm_mod 
video button battery asus_acpi backlight ac parport nvram snd_intel8x0m 
snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy joydev snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipw2200 
sg pcspkr ieee80211 ieee80211_crypt snd_pcm tg3 snd_timer rng_core snd 
soundcore snd_page_alloc firmware_class i2c_i801 rtc ata_piix libata sd_mod 
scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd usbcore
 CPU:    0
 EIP:    0060:[<c01aa182>]    Tainted: P      VLI
 EFLAGS: 00010286   (2.6.20 #8)
 EIP is at sysfs_hash_and_remove+0x32/0x130
 eax: fffffff3   ebx: c03ec750   ecx: ffffffff   edx: fffffff3
 esi: fffffff3   edi: fffffff3   ebp: dd68fdd0   esp: dd68fdb4
 ds: 007b   es: 007b   ss: 0068
 Process bash (pid: 21158, ti=dd68e000 task=e5b34560 task.ti=dd68e000)
 Stack: c03a68ef fffffff3 dd68fde0 c0176591 c03ec750 fffffff3 fffffff3 
dd68fde0 
        c01ac98b c03ec748 f0749c68 dd68fdf4 c01ac9d1 f0749c00 f0749c00 
f0749c68 
        dd68fdfc c0265a20 dd68fe08 c02651c0 f7f9fa34 dd68fe20 c025f87b 
00000000 
 Call Trace:
  [<c010502a>] show_trace_log_lvl+0x1a/0x30
  [<c01050f1>] show_stack_log_lvl+0xb1/0xe0
  [<c01052db>] show_registers+0x1bb/0x300
  [<c0105533>] die+0x113/0x240
  [<c03202dd>] do_page_fault+0x2bd/0x5f0
  [<c031e9ec>] error_code+0x74/0x7c
  [<c01ac98b>] remove_files+0x1b/0x30
  [<c01ac9d1>] sysfs_remove_group+0x31/0x60
  [<c0265a20>] dpm_sysfs_remove+0x10/0x20
  [<c02651c0>] device_pm_remove+0x20/0x60
  [<c025f87b>] device_del+0x17b/0x1b0
  [<c025f8bb>] device_unregister+0xb/0x20
  [<c025f948>] device_destroy+0x78/0x90
  [<c023f7bc>] vcs_remove_sysfs+0x1c/0x40
  [<c024569e>] con_close+0x5e/0x70
  [<c023779c>] release_dev+0x13c/0x680
  [<c0237cf2>] tty_release+0x12/0x20
  [<c016e7cb>] __fput+0x9b/0x190
  [<c016e928>] fput+0x18/0x20
  [<c016bcb7>] filp_close+0x47/0x70
  [<c011fc55>] put_files_struct+0x95/0xa0
  [<c0120ec3>] do_exit+0x143/0x870
  [<c0121617>] do_group_exit+0x27/0x80
  [<c012167f>] sys_exit_group+0xf/0x20
  [<c0104130>] syscall_call+0x7/0xb
  =======================
 Code: c0 89 5d f4 89 75 f8 89 7d fc 89 45 e8 89 55 e4 75 17 b8 fe ff ff ff 8b 
5d f4 8b 75 f8 8b 7d fc 89 ec 5d c3 90 8d 74 26 00 89 c2 <8b> 40 08 85 c0 74 
e0 8b 72 50 83 c0 68 e8 8c 37 17 00 8b 5e 0c 
 EIP: [<c01aa182>] sysfs_hash_and_remove+0x32/0x130 SS:ESP 0068:dd68fdb4
  <1>Fixing recursive fault but reboot is needed!


