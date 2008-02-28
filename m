Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbYB1KZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbYB1KZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYB1KZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:25:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:34956 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbYB1KZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:25:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=c+4yyUSHdY/FjqkFXRpbvn1TbeQsOkQubQ6IhsfhgsLD0OefiIr13EwdBozc80bhAzMNYyII5VzNt9Xcs1+q/3e3/sfdG9YYiJ6rdMJsaK/vkQKX6YcOO8NtqpTBooRUUSxXnEEhvVxTkfHgLKfEmsI0ZrRmgeQiwrb5Qm5TakI=
Message-ID: <c4e36d110802280225h45acbdf8ped69e0418fc38e8f@mail.gmail.com>
Date: Thu, 28 Feb 2008 11:25:13 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: KVM & Qemu crashed with infinite recursive kernel loop in the guest
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

While testing something inside the Qemu I've accidentally created
infinite fast recursive loop with locked IRQ that instead of
deadlocking guest kernel inside Qemu actually caused some troubles to
the hosting system. (but the system survived)

Using 64bit kernels and git 2.6.25-rc3

 ------------[ cut here ]------------
 WARNING: at arch/x86/kvm/x86.c:158 kvm_queue_exception_e+0x61/0x70 [kvm]()
 Modules linked in: loop tun i915 drm ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 xt_s
tate nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables
x_tables bridge llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4
sunrpc bin
fmt_misc dm_mirror dm_multipath dm_mod uinput kvm_intel kvm
snd_hda_intel snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_pcm_oss sn
d_mixer_oss snd_pcm mmc_block arc4 ecb crypto_blkcipher cryptomgr
sr_mod snd_timer crypto_algapi sdhci i2c_i801 cdrom snd psmouse
rtc_cmos rtc
_core serio_raw iwl3945 mac80211 cfg80211 soundcore iTCO_wdt
iTCO_vendor_support e1000e snd_page_alloc ac intel_agp thinkpad_acpi
hwmon backli
ght rtc_lib i2c_core mmc_core evdev nvram button uhci_hcd ohci_hcd
ehci_hcd usbcore [last unloaded: battery]
Pid: 1856, comm: qemu-kvm Not tainted 2.6.25-rc3 #85

Call Trace:
 [<ffffffff8103e54f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff8824a011>] ? :kvm:gfn_to_hva+0x11/0x90
 [<ffffffff8824a2b2>] ? :kvm:kvm_read_guest_page+0x62/0x70
 [<ffffffff81179160>] ? __down_read_trylock+0x20/0x60
 [<ffffffff8824a308>] ? :kvm:kvm_read_guest+0x48/0x90
 [<ffffffff81179160>] ? __down_read_trylock+0x20/0x60
 [<ffffffff88253580>] ? :kvm:paging64_walk_addr+0x180/0x320
 [<ffffffff8824efd1>] :kvm:kvm_queue_exception_e+0x61/0x70
 [<ffffffff88250118>] :kvm:kvm_inject_page_fault+0x38/0x60
 [<ffffffff882539fe>] :kvm:paging64_page_fault+0x27e/0x4d0
 [<ffffffff88250370>] ? :kvm:emulator_write_emulated+0x70/0x90
 [<ffffffff88254b22>] ? :kvm:x86_emulate_insn+0x3e2/0x4dd0
 [<ffffffff8826aede>] ? :kvm_intel:vcpu_put_rsp_rip+0x2e/0x40
 [<ffffffff8826aea5>] ? :kvm_intel:vmx_set_rflags+0x25/0x30
 [<ffffffff88252cba>] :kvm:kvm_mmu_page_fault+0x1a/0xb0
 [<ffffffff8826bfd5>] :kvm_intel:handle_exception+0x1e5/0x280
 [<ffffffff8826a705>] :kvm_intel:kvm_handle_exit+0x75/0xc0
 [<ffffffff8824f666>] :kvm:kvm_arch_vcpu_ioctl_run+0x286/0x760
 [<ffffffff8824966e>] :kvm:kvm_vcpu_ioctl+0x38e/0x3a0
 [<ffffffff812efe49>] ? mutex_unlock+0x9/0x10
 [<ffffffff8108fcd4>] ? generic_file_aio_write+0x74/0xd0
 [<ffffffff811161f6>] ? ext3_file_write+0x26/0xc0
 [<ffffffff810bae01>] ? do_sync_write+0xf1/0x140
 [<ffffffff8824aba5>] ? :kvm:kvm_vm_ioctl+0x85/0x220
 [<ffffffff8110057c>] ? dnotify_parent+0x3c/0xa0
 [<ffffffff810c95b1>] vfs_ioctl+0x31/0xa0
 [<ffffffff810c98a3>] do_vfs_ioctl+0x283/0x2f0
 [<ffffffff810c99a9>] sys_ioctl+0x99/0xa0
 [<ffffffff8100c70a>] system_call_after_swapgs+0x8a/0x8f

And these were  repeated in the log many many time possible even mixed
with some different back traces - but this should be the primary
reason.

Zdenek
