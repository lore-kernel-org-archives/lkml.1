Return-Path: <linux-kernel-owner+w=401wt.eu-S1751741AbZKZBfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbZKZBfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 20:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZKZBfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 20:35:30 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52141 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZKZBf1 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 20:35:27 -0500
Message-ID: <4B0DDB5D.9030202@linux.vnet.ibm.com>
Date: Wed, 25 Nov 2009 19:35:25 -0600
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       Linux-kernel@vger.kernel.org
Subject: Re: kernel bug in kvm_intel
References: <4ACF9745.3050902@linux.vnet.ibm.com> <4AD16ACE.6040903@redhat.com> <1255372957.4883.49.camel@twinturbo.austin.ibm.com> <4AD4231F.6040608@redhat.com> <1255442640.4883.56.camel@twinturbo.austin.ibm.com> <4AD6061D.5070306@redhat.com> <1255637909.4883.129.camel@twinturbo.austin.ibm.com> <1256926052.4883.203.camel@twinturbo.austin.ibm.com> <4AEC5C24.9080506@redhat.com> <4AEC64FC.7070908@linux.vnet.ibm.com> <4AEC6699.6000202@redhat.com> <4AEC6821.7010801@redhat.com> <4AED5C3F.9050506@kernel.org> <4AED6100.6040804@redhat.com> <4AED66D0.20704@kernel.org> <4AED7178.2060906@redhat.com> <4B03BDCC.4080502@kernel.org>
In-Reply-To: <4B03BDCC.4080502@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> 11/01/2009 08:31 PM, Avi Kivity wrote:
>>>> Here is the code in question:
>>>>
>>>>     
>>>>>      3ae7:       75 05                   jne   
>>>>> 3aee<vmx_vcpu_run+0x26a>
>>>>>        3ae9:       0f 01 c2                vmlaunch
>>>>>        3aec:       eb 03                   jmp   
>>>>> 3af1<vmx_vcpu_run+0x26d>
>>>>>        3aee:       0f 01 c3                vmresume
>>>>>        3af1:       48 87 0c 24             xchg   %rcx,(%rsp)
>>>>>        
>>>> ^^^ fault, but not at (%rsp)
>>>>      
>>> Can you please post the full oops (including kernel debug messages
>>> during boot) or give me a pointer to the original message?
>> http://www.mail-archive.com/kvm@vger.kernel.org/msg23458.html
>>
>>> Also, does
>>> the faulting address coincide with any symbol?
>>>    
>> No (at least, not in System.map).
> 
> Has there been any progress?  Is kvm + oprofile still broken?
>

I just tried testing tip of kvm.git, but unfortunately I think I might 
be hitting a different problem, where processes run 100% in kernel mode. 
  In my case, cpus 9 and 13 were stuck, running qemu processes.  A stack 
backtrace for both cpus are below.  FWIW, kernel.org 2.6.32-rc7 does not 
have this problem, or the original problem.


> NMI backtrace for cpu 9
> CPU 9:
> Modules linked in: tun sunrpc af_packet bridge stp ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm_intel kvm uinput sr_mod cdrom ata_generic pata_acpi ata_piix joydev libata ide_pci_generic usbhid ide_core hid serio_raw cdc_ether usbnet mii matroxfb_base matroxfb_DAC1064 matroxfb_accel matroxfb_Ti3026 matroxfb_g450 g450_pll matroxfb_misc iTCO_wdt i2c_i801 i2c_core pcspkr iTCO_vendor_support ioatdma thermal rtc_cmos rtc_core bnx2 rtc_lib dca thermal_sys hwmon sg button shpchp pci_hotplug qla2xxx scsi_transport_fc scsi_tgt sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: processor]
> Pid: 5687, comm: qemu-system-x86 Not tainted 2.6.32-rc7-5e8cb552cb8b48244b6d07bff984b3c4080d4bc9-autokern1 #1  -[7947AC1]-
> RIP: 0010:[<ffffffff810b802b>]  [<ffffffff810b802b>] fire_user_return_notifiers+0x31/0x36
> RSP: 0018:ffff88095024df08  EFLAGS: 00000246
> RAX: 0000000000000000 RBX: 0000000000000800 RCX: ffff88095024c000
> RDX: ffff880028340000 RSI: 0000000000000000 RDI: ffff88095024df58
> RBP: ffff88095024df18 R08: 0000000000000000 R09: 0000000000000001
> R10: 000000caf1fff62d R11: ffff8805b584de40 R12: 00007fffae48e0f0
> R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
> FS:  00007f45c69d57c0(0000) GS:ffff880028340000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: fffff9800121056e CR3: 0000000953d36000 CR4: 00000000000026e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Call Trace:
>  <#DB[1]>  <<EOE>> Pid: 5687, comm: qemu-system-x86 Not tainted 2.6.32-rc7-5e8cb552cb8b48244b6d07bff984b3c4080d4bc9-autokern1 #1
> Call Trace:
>  <NMI>  [<ffffffff8100af53>] ? show_regs+0x44/0x49
>  [<ffffffff812e57b2>] nmi_watchdog_tick+0xc2/0x1b9
>  [<ffffffff812e4e73>] do_nmi+0xb0/0x252
>  [<ffffffff812e48a0>] nmi+0x20/0x30
>  [<ffffffff810b802b>] ? fire_user_return_notifiers+0x31/0x36
>  <<EOE>>  [<ffffffff8100b844>] do_notify_resume+0x62/0x69
>  [<ffffffff8100bf48>] ? int_check_syscall_exit_work+0x9/0x3d
>  [<ffffffff8100bf8e>] int_signal+0x12/0x17

> NMI backtrace for cpu 13
> CPU 13:
> Modules linked in: tun sunrpc af_packet bridge stp ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm_intel kvm uinput sr_mod cdrom ata_generic pata_acpi ata_piix joydev libata ide_pci_generic usbhid ide_core hid serio_raw cdc_ether usbnet mii matroxfb_base matroxfb_DAC1064 matroxfb_accel matroxfb_Ti3026 matroxfb_g450 g450_pll matroxfb_misc iTCO_wdt i2c_i801 i2c_core pcspkr iTCO_vendor_support ioatdma thermal rtc_cmos rtc_core bnx2 rtc_lib dca thermal_sys hwmon sg button shpchp pci_hotplug qla2xxx scsi_transport_fc scsi_tgt sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: processor]
> Pid: 5792, comm: qemu-system-x86 Not tainted 2.6.32-rc7-5e8cb552cb8b48244b6d07bff984b3c4080d4bc9-autokern1 #1  -[7947AC1]-
> RIP: 0010:[<ffffffff8100bfb0>]  [<ffffffff8100bfb0>] int_restore_rest+0x1d/0x3d
> RSP: 0018:ffff88124f491f58  EFLAGS: 00000292
> RAX: 0000000000000800 RBX: 00007fff9df852e0 RCX: ffff88124f490000
> RDX: ffff88099ff40000 RSI: 0000000000000000 RDI: 000000000000fe2e
> RBP: 00007fff9df85260 R08: ffff88124f490000 R09: 0000000000000000
> R10: 0000000000000005 R11: ffff880954971da0 R12: 00007fff9df851e0
> R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
> FS:  00007f73b5b1d7c0(0000) GS:ffff88099ff40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f8d5a8de9d0 CR3: 0000000eb34d7000 CR4: 00000000000026e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Call Trace:
>  <#DB[1]>  <<EOE>> Pid: 5792, comm: qemu-system-x86 Not tainted 2.6.32-rc7-5e8cb552cb8b48244b6d07bff984b3c4080d4bc9-autokern1 #1
> Call Trace:
>  <NMI>  [<ffffffff8100af53>] ? show_regs+0x44/0x49
>  [<ffffffff812e57b2>] nmi_watchdog_tick+0xc2/0x1b9
>  [<ffffffff812e4e73>] do_nmi+0xb0/0x252
>  [<ffffffff812e48a0>] nmi+0x20/0x30
>  [<ffffffff8100bfb0>] ? int_restore_rest+0x1d/0x3d
>  <<EOE>> 


-Andrew


