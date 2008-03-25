Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYCYVNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYCYVNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYCYVNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:13:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53669 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbYCYVM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:12:59 -0400
Subject: kvm causing memory corruption?  ~2.6.25-rc6
From: Dave Hansen <haveblue@us.ibm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 14:12:56 -0700
Message-Id: <1206479576.7562.21.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was getting some kvm userspace crashes trying to run a Windows guest.
So, I decided to try a recent kernel (2.6.25-rc6-00333-ga4083c9)  with
the kvm kernel code that shipped with that kernel.

I've had some lockups doing similar things over the last month or two,
but figured it was something really stupid I was doing, and never really
connected the dots.  Now, I've hooked up a serial console and reproduced
it with a fresh boot and not much else going on at all on the machine.

Machine is a Thinkpad T61.  .config is here:

http://sr71.net/~dave/linux/config-2.6.25-rc6-00333-ga4083c9

To trigger it, I first run kvm and see an error (-no-kvm works fine,
btw):

$ ~/src/kvm-userspace/qemu/x86_64-softmmu/qemu-system-x86_64 -hda ~/projects/qemu/windows-xp-base-runme.img 
kvm_run: Cannot allocate memory
kvm_run returned -12

Then, run it again.  I usually get an oops.  But, the weird part is that
the oops isn't *in* kvm.  It's in some other part of the kernel and in
some *OTHER* process.  One in bash is below.  That's what leads me to
believe it is memory corruption.  The machine also becomes increasingly
unstable after the original oops so there's definitely collateral
damage.
        
        $ addr2line -e vmlinux c01795e4
        /home/dave/kernels/linux-2.6.git/mm/filemap.c:1327
        
        int filemap_fault(struct vm_area_struct *vma, struct vm_fault
        *vmf)
        {
                int error;
                struct file *file = vma->vm_file;
                struct address_space *mapping = file->f_mapping;
                struct file_ra_state *ra = &file->f_ra;
        HERE--->struct inode *inode = mapping->host;

Which is a line of code that literally hasn't touched since the
beginning of time (in git terms :).  Full oops is below:

[  435.057922] BUG: unable to handle kernel NULL pointer dereference at 00000048
[  435.067275] IP: [<c01795e4>] filemap_fault+0x34/0x310
[  435.072815] *pdpt = 000000002a4a7001 *pde = 0000000000000000 
[  435.081272] Oops: 0000 [#2] SMP 
[  435.084812] Modules linked in: nls_iso8859_1 vfat fat rfcomm l2cap tun ppdev acpi_cpufreq cpufreq_ondemand cpufreq_conservative cpufreq_stats freq_table cpufreq_userspace cpufreq_powersave sbs container sbshc af_packet sbp2 lp loop usb_storage arc4 ecb crypto_blkcipher pcmcia usbhid libusual hid snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device joydev iwl4965 snd serio_raw mac80211 yenta_socket parport_pc sdhci uhci_hcd ehci_hcd ricoh_mmc ohci1394 rsrc_nonstatic soundcore cfg80211 parport psmouse mmc_core ieee1394 pcmcia_core usbcore snd_page_alloc e1000 button thinkpad_acpi nvram evdev thermal processor fan fuse
[  435.084812] 
[  435.084812] Pid: 7691, comm: bash Tainted: G      D  (2.6.25-rc6-00333-ga4083c9 #144)
[  435.084812] EIP: 0060:[<c01795e4>] EFLAGS: 00010286 CPU: 0
[  435.084812] EIP is at filemap_fault+0x34/0x310
[  435.084812] EAX: ef83bf48 EBX: 00000012 ECX: 00000000 EDX: ef83c7e8
[  435.084812] ESI: c04cc248 EDI: 00000000 EBP: ef96ee40 ESP: ef96ee00
[  435.084812]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  435.084812] Process bash (pid: 7691, ti=ef96e000 task=ef8a2e00 task.ti=ef96e000)
[  435.084812] Stack: ef96ee2c c0130cbc ef96ee28 c01870bb ef96ee28 00000000 00000000 00000000 
[  435.084812]        ef83bf48 ef83c7e8 ef83bf00 ef96ee9c ea49f7e8 00000012 c04cc248 00000000 
[  435.084812]        ef96eeb8 c018ab57 80000001 00000001 00000001 00000000 00000000 eacb6314 
[  435.084812] Call Trace:
[  435.084812]  [<c0130cbc>] ? kmap_atomic_prot+0x12c/0x150
[  435.084812]  [<c01870bb>] ? vm_normal_page+0x2b/0xa0
[  435.084812]  [<c018ab57>] ? __do_fault+0x67/0x4e0
[  435.084812]  [<c01a8a70>] ? pipe_read+0x1f0/0x290
[  435.084812]  [<c018b03d>] ? do_linear_fault+0x6d/0x80
[  435.084812]  [<c018b570>] ? handle_mm_fault+0x1c0/0x4d0
[  435.084812]  [<c014d58e>] ? do_sigaction+0x16e/0x190
[  435.084812]  [<c03b3419>] ? do_page_fault+0x169/0x4d0
[  435.084812]  [<c01a38b9>] ? fput+0x19/0x20
[  435.084812]  [<c03b32b0>] ? do_page_fault+0x0/0x4d0
[  435.084812]  [<c03b187a>] ? error_code+0x72/0x78
[  435.084812]  [<c03b0000>] ? wait_for_completion_killable+0x10/0x30
[  435.084812]  =======================
[  435.084812] Code: 89 45 f0 89 55 ec 8b 40 4c 89 45 e8 8b 50 7c 83 c0 48 89 45 e0 89 55 e4 8b 0a c7 45 d8 00 00 00 00 c7 45 d4 00 00 00 00 89 4d dc <8b> 49 48 89 f6 8d bc 27 00 00 00 00 89 c8 8b 7d dc 8b 5f 40 8b 
[  435.084812] EIP: [<c01795e4>] filemap_fault+0x34/0x310 SS:ESP 0068:ef96ee00
[  435.084870] ---[ end trace addcd60623916614 ]---

~/src/kvm-userspace$ git describe
kvm-63-118-g52be1a1

/proc/cpuinfo:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
stepping        : 10
cpu MHz         : 800.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3
cx16 xtpr lahf_lm ida
bogomips        : 3996.38
clflush size    : 64
processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
stepping        : 10
cpu MHz         : 800.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3
cx16 xtpr lahf_lm ida
bogomips        : 3990.03
clflush size    : 64



-- Dave

