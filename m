Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYGCPZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYGCPZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYGCPZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:25:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:24871 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYGCPZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:25:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qbERIx4vaqP/i3cX5xt0yOgcepfmksNRugynK9+az4f7nOsXNkjT+6dGYJeAny026X
         +bMvBvvtC0UC/UyLZI5yxbe9Zc3SXvrcUwkhds65HEK2Tuuscdq0hBltrrbDkXnRsT7K
         DsES8qMnaMV8QhqqJomgvw8MDqSTutPL5GkFM=
Message-ID: <486CEF34.4000702@gmail.com>
Date: Thu, 03 Jul 2008 17:24:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: WARNING at acpi/.../utmisc.c:1043 [Was: 2.6.26-rc8-mm1]
References: <20080703020236.adaa51fa.akpm@linux-foundation.org> <486CE1A7.4030009@gmail.com> <486CE46C.6040700@linux.intel.com>
In-Reply-To: <486CE46C.6040700@linux.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen napsal(a):
> Jiri Slaby wrote:
>> Andrew Morton napsal(a):
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc8/2.6.26-rc8-mm1/ 
>>>
>>
>> Running this in qemu shows up these 3 warnings while booting (It's 
>> tainted due to previous MTRR warning which was there for ever):
>>
>> PCI: Using configuration type 1 for base access
>> ------------[ cut here ]------------
>> WARNING: at /home/latest/xxx/drivers/acpi/utilities/utmisc.c:1043 
> 
> Not sure where that is coming from. My tree and my copy of linux-next
> doesn't have a WARN_ON in this function.

It's from
acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath.patch

> Anyways, I assume you always saw this message right?

Yes (almost, see below), I've checked this now.

>> ACPI Exception (evxface-0645): AE_BAD_PARAMETER, Installing notify 
>> handler failed [20080609]
>> ACPI: Interpreter enabled
> 
> And the only thing new is the backtrace right?

In the two cases. The thermal one is new:

  processor ACPI0007:00: registered as cooling_device0
-thermal LNXTHERM:01: registered as thermal_zone0
-ACPI: Critical trip point
-Critical temperature reached (60 C), shutting down.
-ACPI: Thermal Zone [THRM] (60 C)
+------------[ cut here ]------------
+WARNING: at /home/latest/xxx/drivers/acpi/utilities/utmisc.c:1043 
acpi_ut_exception+0x3c/0xb9()
+Modules linked in:
+Pid: 1, comm: swapper Tainted: G       AW 2.6.26-rc8-mm1-nohz #9
+
+Call Trace:
+ [<ffffffff8023c2df>] warn_on_slowpath+0x5f/0x90
+ [<ffffffff80257a74>] ? up+0x34/0x50
+ [<ffffffff803576d6>] ? acpi_os_release_object+0x9/0xd
+ [<ffffffff8036f92c>] ? acpi_ut_delete_object_desc+0x48/0x4c
+ [<ffffffff8036f103>] ? acpi_ut_delete_internal_obj+0x167/0x16f
+ [<ffffffff8036f162>] ? acpi_ut_update_ref_count+0x57/0xa3
+ [<ffffffff8036f2a5>] ? acpi_ut_update_object_reference+0xf7/0x153
+ [<ffffffff8036e24e>] acpi_ut_exception+0x3c/0xb9
+ [<ffffffff80357912>] ? acpi_os_signal_semaphore+0x23/0x27
+ [<ffffffff8036719c>] ? acpi_evaluate_object+0x1ea/0x1fe
+ [<ffffffff8036f103>] ? acpi_ut_delete_internal_obj+0x167/0x16f
+ [<ffffffff803582e2>] ? acpi_evaluate_integer+0xbf/0xd1
+ [<ffffffff8037cbb6>] acpi_thermal_trips_update+0x6a/0x56c
+ [<ffffffff8036719c>] ? acpi_evaluate_object+0x1ea/0x1fe
+ [<ffffffff802fe7c0>] ? sysfs_ilookup_test+0x0/0x20
+ [<ffffffff8052b27e>] ? _spin_unlock+0x2e/0x40
+ [<ffffffff803582e2>] ? acpi_evaluate_integer+0xbf/0xd1
+ [<ffffffff8037d9e8>] acpi_thermal_add+0x3cf/0x43e
+ [<ffffffff80372312>] acpi_device_probe+0x49/0x8c
+ [<ffffffff803b2892>] driver_probe_device+0xa2/0x1e0
+ [<ffffffff803b2a5b>] __driver_attach+0x8b/0x90
+ [<ffffffff803b29d0>] ? __driver_attach+0x0/0x90
+ [<ffffffff803b204b>] bus_for_each_dev+0x6b/0xa0
+ [<ffffffff80339dca>] ? kobject_get+0x1a/0x30
+ [<ffffffff803b26dc>] driver_attach+0x1c/0x20
+ [<ffffffff803b18d8>] bus_add_driver+0x208/0x280
+ [<ffffffff8071032f>] ? acpi_thermal_init+0x0/0x83
+ [<ffffffff803b2c40>] driver_register+0x70/0x160
+ [<ffffffff8071032f>] ? acpi_thermal_init+0x0/0x83
+ [<ffffffff8037264a>] acpi_bus_register_driver+0x3e/0x40
+ [<ffffffff80710390>] acpi_thermal_init+0x61/0x83
+ [<ffffffff806f95b7>] do_one_initcall+0x35/0x15d
+ [<ffffffff802719f8>] ? register_irq_proc+0xe8/0x110
+ [<ffffffff802f0000>] ? __inode_dir_notify+0x30/0xf0
+ [<ffffffff806f987a>] kernel_init+0x19b/0x1a6
+ [<ffffffff802396f7>] ? schedule_tail+0x27/0x60
+ [<ffffffff8020c788>] child_rip+0xa/0x12
+ [<ffffffff806f96df>] ? kernel_init+0x0/0x1a6
+ [<ffffffff8020c77e>] ? child_rip+0x0/0x12
+
+---[ end trace 4eaa2a86a8e2da22 ]---
+ACPI Exception (thermal-0377): AE_OK, No or invalid critical threshold 
[20080609]
  Real Time Clock Driver v1.12ac
