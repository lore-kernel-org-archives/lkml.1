Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbYG1VtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbYG1VtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYG1VtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:49:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49441 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYG1VtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:49:03 -0400
Subject: sched-powersave causes oops on 2.6.26-08037-g8cd362a
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 14:48:59 -0700
Message-Id: <1217281739.7345.8.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This oops just happens on startup for me.

$ uname -a
Linux nimitz 2.6.26-08037-g8cd362a #69 SMP Mon Jul 28 14:12:00 PDT 2008 i686 GNU/Linux

$ addr2line -e vmlinux c0126866
linux-2.6.git/kernel/sched.c:7660

static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
{
        int ret;

HERE--> if (buf[0] != '0' && buf[0] != '1')
                return -EINVAL;

        if (smt)
                sched_smt_power_savings = (buf[0] == '1');
        else
                sched_mc_power_savings = (buf[0] == '1');

        ret = arch_reinit_sched_domains();

        return ret ? ret : count;
}

Looks to me like someone managed to get a null 'buf' into there.
Although, it is a bit odd that the actual deref is at 00000002.

I'm assuming that this is coming from: 4a0b2b4dbe1335b8b9886ba3dc85a145d5d938ed.

[  167.635123] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[  168.590082] iwl4965 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  168.590256] iwl4965 0000:03:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x40100106)
[  168.590335] firmware: requesting iwlwifi-4965-2.ucode
[  168.596984] iwl4965: iwlwifi-4965-2.ucode firmware file req failed: Reason -2
[  168.611276] iwl4965: Could not read microcode: -2
[  168.620708] iwl4965 0000:03:00.0: PCI INT A disabled
[  186.857870] iwl4965 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  186.858083] iwl4965 0000:03:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x40100106)
[  186.858161] firmware: requesting iwlwifi-4965-2.ucode
[  186.861756] iwl4965: iwlwifi-4965-2.ucode firmware file req failed: Reason -2
[  186.876051] iwl4965: Could not read microcode: -2
[  186.885509] iwl4965 0000:03:00.0: PCI INT A disabled
[  189.159655] BUG: unable to handle kernel NULL pointer dereference at 00000002
[  189.171417] IP: [<c0126866>] sched_power_savings_store+0x16/0x60
[  189.183509] *pdpt = 000000000ac15001 *pde = 0000000000000000 
[  189.183513] Oops: 0000 [#1] SMP 
[  189.188602] Modules linked in: dummy rfcomm l2cap nls_iso8859_1 vfat fat kvm_intel kvm tun ppdev acpi_cpufreq cpufreq_stats cpufreq_ondemand freq_table cpufreq_powersave cpufreq_userspace cpufreq_conservative sbs container sbshc iptable_filter ip_tables x_tables deflate zlib_deflate des_generic cbc aes_generic xcbc sha256_generic sha1_generic af_key dm_crypt dm_mod lp snd_hda_intel snd_pcm_oss snd_pcm joydev snd_mixer_oss arc4 ecb crypto_blkcipher pcmcia snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq iwl4965 snd_timer snd_seq_device yenta_socket iwlcore rsrc_nonstatic usb_storage snd usbhid thinkpad_acpi mac80211 hid libusual psmouse rfkill parport_pc pcmcia_core video led_class soundcore parport serio_raw cfg80211 evdev button snd_page_alloc nvram ohci1394 ieee1394 ehci_hcd uhci_hcd usbcore thermal processor fan fuse
[  189.188602] 
[  189.188602] Pid: 7113, comm: sched-powersave Not tainted (2.6.26-08037-g8cd362a #69)
[  189.188602] EIP: 0060:[<c0126866>] EFLAGS: 00010292 CPU: 0
[  189.188602] EIP is at sched_power_savings_store+0x16/0x60
[  189.188602] EAX: 00000002 EBX: 00000000 ECX: ffffffea EDX: c04b73f8
[  189.188602] ESI: c04b73f8 EDI: cac49000 EBP: cac7bf24 ESP: cac7bf1c
[  189.188602]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  189.188602] Process sched-powersave (pid: 7113, ti=cac7b000 task=cac8b000 task.ti=cac7b000)
[  189.188602] Stack: c01268d0 c04b7704 cac7bf2c c01268df cac7bf40 c02a1ddb c04b73f8 f6c0b6f0 
[  189.188602]        c04b7704 cac7bf6c c01d530b 00000002 080fc408 cb729800 cd84bc54 00000002 
[  189.188602]        c04b73f8 cb729800 080fc408 00000002 cac7bf90 c018dba6 cac7bf9c cb729800 
[  189.188602] Call Trace:
[  189.188602]  [<c01268d0>] ? sched_mc_power_savings_store+0x0/0x20
[  189.188602]  [<c01268df>] ? sched_mc_power_savings_store+0xf/0x20
[  189.188602]  [<c02a1ddb>] ? sysdev_class_store+0x2b/0x40
[  189.188602]  [<c01d530b>] ? sysfs_write_file+0xbb/0x110
[  189.188602]  [<c018dba6>] ? vfs_write+0x96/0x130
[  189.188602]  [<c01d5250>] ? sysfs_write_file+0x0/0x110
[  189.188602]  [<c018e0cd>] ? sys_write+0x3d/0x70
[  189.188602]  [<c0103d3f>] ? sysenter_do_call+0x12/0x33
[  189.188602]  [<c0380000>] ? pci_bus_assign_resources+0x220/0x4c6
[  189.188602]  =======================
[  189.188602] Code: c9 31 d2 e8 6d fd ff ff e8 58 61 00 00 31 c0 5d c3 8d 74 26 00 55 89 e5 83 ec 08 89 1c 24 89 cb b9 ea ff ff ff 89 74 24 04 89 d6 <0f> b6 10 8d 42 d0 3c 01 76 10 8b 1c 24 89 c8 8b 74 24 04 89 ec 
[  189.188602] EIP: [<c0126866>] sched_power_savings_store+0x16/0x60 SS:ESP 0068:cac7bf1c
[  189.643173] ---[ end trace 9d31c0bef6b8b1a8 ]---

-- Dave

