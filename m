Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab0BMSYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 13:24:53 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:46137 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab0BMSYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 13:24:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=db6bFg7TcMzcbW9sbAVc++UtmocVaC/nk3nl4yf4h7y6AVU1fz7MglpP80M5au987F
         sXbXvKNZ0ClLalzFpCc1wkwIdYDj33wsn4NhsAXSyLkR9TXGU0ETex8GochymAMT9zGQ
         jmepWLFW6NIeDWuwskSYCrHzeqUP1YsaGNmqg=
Message-ID: <4B76EE70.1060605@gmail.com>
Date: Sat, 13 Feb 2010 12:24:48 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Dariush Forouher <dariush@forouher.de>
CC: linux-kernel@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: ACPI/ata regression with hotplugging the dvd drive
References: <4B76D3E7.6000904@forouher.de>
In-Reply-To: <4B76D3E7.6000904@forouher.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 10:31 AM, Dariush Forouher wrote:
> Hi,
>
> since at least 2.6.32-rc6 inserting the dvd drive into my laptop at runtime
> doesn't work anymore.
>
> Usually (e.g. with 2.6.32) the kernel would print something like the
> following:
>
> ACPI: \_SB_.PCI0.IDE1.PRI_.MAST - docking
> ata4: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
> ata4: ACPI event
> ata4: soft resetting link
> ata4.00: ATAPI: TSSTcorp DVD+/-RW TS-L632H, D200, max UDMA/33
> ata4.00: configured for UDMA/33
> ata4: EH complete
> scsi 3:0:0:0: CD-ROM TSSTcorp DVD+-RW TS-L632H D200 PQ: 0 ANSI: 5
> sr0: scsi3-mmc drive: 6x/24x writer cd/rw xa/form2 cdda tray
> Uniform CD-ROM driver Revision: 3.20
> sr 3:0:0:0: Attached scsi CD-ROM sr0
> sr 3:0:0:0: Attached scsi generic sg1 type 5
>
> And then udev would go on and create the appropriate dev nodes etc.
>
> But with current 2.6.33-rc's the freshly connected drive isn't
> recognized anymore.
> The kernel doesn't give out any related messages and udev doesn't do
> anything either.
>
> If I boot with the drive already placed in the bay, then it's recognized
> correctly
> during start up.
>
> Due to the total lack of kernel messages I'm kind of wondering if maybe
> some new
> config option concerning hotplug or ACPI has been introduced between
> 2.6.32 and 2.6.33
> which I simply forgot to enable. A diff between the old/new kernel
> configs doesn't
> show anything suspicious, though.
>
> The Laptop is a Dell Latitude D630.
>
> Any ideas?

This lockdep error in dmesg looks suspicious. Does this match the point 
where the DVD drive was inserted?

CCing linux-acpi.

[   73.483939]
[   73.483942] =======================================================
[   73.483945] [ INFO: possible circular locking dependency detected ]
[   73.483948] 2.6.33-rc8 #2
[   73.483950] -------------------------------------------------------
[   73.483952] kacpi_hotplug/253 is trying to acquire lock:
[   73.483954]  (kacpid){+.+.+.}, at: [<ffffffff81055680>] 
flush_workqueue+0x0/0xb0
[   73.483963]
[   73.483963] but task is already holding lock:
[   73.483965]  ((&dpc->work)){+.+.+.}, at: [<ffffffff81054699>] 
worker_thread+0x189/0x320
[   73.483971]
[   73.483971] which lock already depends on the new lock.
[   73.483972]
[   73.483973]
[   73.483974] the existing dependency chain (in reverse order) is:
[   73.483976]
[   73.483977] -> #1 ((&dpc->work)){+.+.+.}:
[   73.483981]        [<ffffffff8106de84>] __lock_acquire+0x13c4/0x1cd0
[   73.483986]        [<ffffffff8106e7ec>] lock_acquire+0x5c/0x80
[   73.483989]        [<ffffffff810546e5>] worker_thread+0x1d5/0x320
[   73.483993]        [<ffffffff81058c76>] kthread+0x96/0xb0
[   73.483996]        [<ffffffff810032d4>] kernel_thread_helper+0x4/0x10
[   73.484001]
[   73.484002] -> #0 (kacpid){+.+.+.}:
[   73.484005]        [<ffffffff8106e73c>] __lock_acquire+0x1c7c/0x1cd0
[   73.484005]        [<ffffffff8106e7ec>] lock_acquire+0x5c/0x80
[   73.484005]        [<ffffffff810556ce>] flush_workqueue+0x4e/0xb0
[   73.484005]        [<ffffffff812c6df9>] 
acpi_os_wait_events_complete+0x10/0x1e
[   73.484005]        [<ffffffff812c6e24>] 
acpi_os_execute_deferred+0x1d/0x31
[   73.484005]        [<ffffffff810546eb>] worker_thread+0x1db/0x320
[   73.484005]        [<ffffffff81058c76>] kthread+0x96/0xb0
[   73.484005]        [<ffffffff810032d4>] kernel_thread_helper+0x4/0x10
[   73.484005]
[   73.484005] other info that might help us debug this:
[   73.484005]
[   73.484005] 2 locks held by kacpi_hotplug/253:
[   73.484005]  #0:  (kacpi_hotplug){+.+...}, at: [<ffffffff81054699>] 
worker_thread+0x189/0x320
[   73.484005]  #1:  ((&dpc->work)){+.+.+.}, at: [<ffffffff81054699>] 
worker_thread+0x189/0x320
[   73.484005]
[   73.484005] stack backtrace:
[   73.484005] Pid: 253, comm: kacpi_hotplug Not tainted 2.6.33-rc8 #2
[   73.484005] Call Trace:
[   73.484005]  [<ffffffff8106c440>] print_circular_bug+0x100/0x110
[   73.484005]  [<ffffffff8106e73c>] __lock_acquire+0x1c7c/0x1cd0
[   73.484005]  [<ffffffff81054699>] ? worker_thread+0x189/0x320
[   73.484005]  [<ffffffff8106df15>] ? __lock_acquire+0x1455/0x1cd0
[   73.484005]  [<ffffffff812c6e07>] ? acpi_os_execute_deferred+0x0/0x31
[   73.484005]  [<ffffffff8106e7ec>] lock_acquire+0x5c/0x80
[   73.484005]  [<ffffffff81055680>] ? flush_workqueue+0x0/0xb0
[   73.484005]  [<ffffffff810556ce>] flush_workqueue+0x4e/0xb0
[   73.484005]  [<ffffffff81055680>] ? flush_workqueue+0x0/0xb0
[   73.484005]  [<ffffffff812c6df9>] acpi_os_wait_events_complete+0x10/0x1e
[   73.484005]  [<ffffffff812c6e24>] acpi_os_execute_deferred+0x1d/0x31
[   73.484005]  [<ffffffff810546eb>] worker_thread+0x1db/0x320
[   73.484005]  [<ffffffff81054699>] ? worker_thread+0x189/0x320
[   73.484005]  [<ffffffff8165f426>] ? schedule+0x3c6/0xa80
[   73.484005]  [<ffffffff81059120>] ? autoremove_wake_function+0x0/0x40
[   73.484005]  [<ffffffff8106bc1d>] ? trace_hardirqs_on+0xd/0x10
[   73.484005]  [<ffffffff81054510>] ? worker_thread+0x0/0x320
[   73.484005]  [<ffffffff81058c76>] kthread+0x96/0xb0
[   73.484005]  [<ffffffff810032d4>] kernel_thread_helper+0x4/0x10
[   73.484005]  [<ffffffff81662c3c>] ? restore_args+0x0/0x30
[   73.484005]  [<ffffffff81058be0>] ? kthread+0x0/0xb0
[   73.484005]  [<ffffffff810032d0>] ? kernel_thread_helper+0x0/0x10
