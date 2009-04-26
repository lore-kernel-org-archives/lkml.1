Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZDZLe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZDZLe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZDZLeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:34:14 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56878 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZDZLeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cjqoEeCL4I4l/ENTsllSgBWdt8JBdulTHKMO8ObprK+MW+FyWO8aLC5uZ9YjeqSutg
         Thid0hn1vw/wjFkVnyyH5Cbzt/ayNOysISKseNIhEjZ/qfUQHaLHhZ/1M9ZvkBIAE8dM
         qxn8F5ZVrUARnp3HbDKN8PUPbdVUVMhRocNM0=
Message-ID: <49F446AE.6070607@tuffmail.co.uk>
Date: Sun, 26 Apr 2009 12:34:06 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: EEE PC hangs when booting off battery
References: <49E065CF.6040408@tuffmail.co.uk> <200904140859.02188.bjorn.helgaas@hp.com> <20090414081728.10de978a@infradead.org> <200904140948.37633.bjorn.helgaas@hp.com> <49E5F01B.2060201@tuffmail.co.uk> <49EF0ABD.2080801@tuffmail.co.uk>
In-Reply-To: <49EF0ABD.2080801@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Alan Jenkins wrote:
>   
>> Bjorn Helgaas wrote:
>>   
>>     
>>> On Tuesday 14 April 2009 09:17:28 am Arjan van de Ven wrote:
>>>   
>>>     
>>>       
>>>> On Tue, 14 Apr 2009 08:59:01 -0600
>>>> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>>>
>>>>     
>>>>       
>>>>         
>>>>> I can't help with the real problem of why the asynchronous battery
>>>>> init causes the hang.
>>>>>       
>>>>>         
>>>>>           
>>>> that got fixed already for the module case.
>>>>     
>>>>       
>>>>         
>>> But apparently still broken for the builtin case?  I think Alan is
>>> running pretty new bits -- he said "latest git" on April 11.
>>>   
>>>     
>>>       
>> It's now fixed, in 2.6.30-rc2.  My battery is modular btw.  I suspect
>>
>> 5d38258ec026921a7b266f4047ebeaa75db358e5 "ACPI battery: fix async boot
>> oops" [removal of __init]
>>
>> was not sufficient to fix my problem, but it was solved by the "real" fix,
>>
>> d6de2c80e9d758d2e36c21699117db6178c0f517 "async: Fix module loading
>> async-work regression" [module loading waits on async work]
>>
>>
>> I would argue there's still a question over why the asynchronous battery
>> init (_with_ the oops fix) should cause a hang in the idle routine.  But
>> since the regression is fixed, it's not exactly an urgent question.
>>   
>>     
>
> Ugh.  Recently I tried building the battery driver into the kernel, to
> benefit from the async work.  Later, I tried booting from the battery
> and it hung again.
>
> This time, the kernel did not even respond to SysRq.  I tried
> nmi_watchdog=1 and waiting 2 minutes, but the watchdog didn't trigger
> either.  As before, it doesn't happen with acpi=off.
>
> I checked that this still happened in todays rc3, and it doesn't happen
> if I revert
>
> 0f66af530116e9f4dd97f328d91718b56a6fc5a4 "ACPI: battery: asynchronous init"
>
>   

It looks like my hang is caused by linkwatch_event() deadlocking on
rtnl_lock().  I can't see any direct connection to asynchronous battery
init, so perhaps that is just revealing a bug by changing the timing.

It appears I wasn't patient enough for hung task detection.  If I leave
it long enough, I see:

<scrolled off top of screen>
? kobject_uevent_env
? kobject_uevent_env
__mutex_lock_slowpath
mutex_lock
rtnl_lock
linkwatch_event
worker_thread
? linkwatch_event
? autoremove_wake_function
? worker_thread
kthread
kernel_thread_helper


INFO: task modprobe:485 blocked for more than 120 seconds
Call trace:
? __atomic_notifier_call_chain
schedule
schedule_timeout
? notify_update
? do_con_write
? __wake_up
wait_for_common
? default_wake_function
wait_for_completion
flush_cpu_workqueue
? wq_barrier_func
flush_workqueue
flush_scheduled_work
tty_ldisc_release
? tty_fasyc
tty_release_dev
? free_pgtables
tty_release
__fput
filp_close
sys_close
syscall_call
? __send_remote_softirq
? usecs_to_jiffies


I then seem to get another repetition of the second calltrace, followed
by a new one

INFO: task swapper:1 blocked for more than 120 seconds
Call trace:
schedule
schedule_timeout
? __wake_up_common
? wake_up
wait_for_common
wait_for_completion
call_usermodehelper_exec
__request_module
crypto_larval_lookup
? extract_entropy
crypto_alg_mod_lookup
crypto_alloc_base
ieee80211_wep_init
ieee80211_register_hw
? ath5k_hw_set_bss
ath5k+pci_probe
local_pci_probe
pci_device_probe
driver_probe_device
__driver_attach
bus_for_each_dev
driver_attach
? __driver_attach
buad_add_driver
driver_register
? ktime_get_ts
__pci_register_driver
init_ath5k_pci
_stext
? init_ath5k_pci
? proc_create_data
? register_ieq_proc
kernel_init
? kernel_init
kernel_thread_helper




The hang happens at this point:

[    0.967588] scsi 1:0:0:0: Direct-Access     ATA      SILICONMOTION SM
n/a  PQ: 0 ANSI: 5
[    0.968049] calling  4_sd_probe_async+0x0/0x225 @ 323
[    0.968313] initcall 3_async_port_probe+0x0/0x95 returned 0 after
343051 usecs
<mark> (see below).
[    0.968786] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors:
(4.00 GB/3.72 GiB)
[    0.968964] sd 1:0:0:0: [sda] Write Protect is off
[    0.969062] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.969132] sd 1:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    0.969543]  sda: sda1 sda2
[    0.970965] sd 1:0:0:0: [sda] Attached SCSI disk
[    0.971073] initcall 4_sd_probe_async+0x0/0x225 returned 0 after 2849
usecs

On a successful boot, the next lines are

[    0.971188] async_continuing @ 1 after 2483 usec
[    0.971305] Freeing unused kernel memory: 256k freed
[    1.071724] calling  ata_generic_init+0x0/0x19 [ata_generic] @ 574
[    1.073798] initcall ata_generic_init+0x0/0x19 [ata_generic] returned
0 after 144 usecs
[    1.183372] Clocksource tsc unstable (delta = -128600689 ns)
[    2.035932] EXT4-fs: delayed allocation enabled

Also, on a successful boot, I see these additional lines at the point
<mark> above.

[    0.968461] async_continuing @ 1 after 76663 usec
[    0.968556] async_waiting @ 1

In fact, when the hang happens I can see no "async_waiting @ 1" on my
50-line screen.  Which makes sense if  the kernel init process is hung
in init_athk_pci().


Thanks
Alan
