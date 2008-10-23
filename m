Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYJWWfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYJWWfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYJWWfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:35:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:10312 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYJWWfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:35:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,473,1220252400"; 
   d="scan'208";a="395405564"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
Date: Thu, 23 Oct 2008 15:34:55 -0700
Subject: RE: Oops in ACPI with git latest
Thread-Topic: Oops in ACPI with git latest
Thread-Index: Ack1T2YcipURkY0+TkapYeMivgOP4gAD3Maw
Message-ID: <4911F71203A09E4D9981D27F9D830858033D1CC9@orsmsx503.amr.corp.intel.com>
References: <1224791103.3330.37.camel@localhost.localdomain>
 <200810232242.33480.rjw@sisk.pl>
In-Reply-To: <200810232242.33480.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+	if (!output.pointer)
+		return AE_NULL_OBJECT;
+

This probably won't work. acpi_evaluate_object currently doesn't touch the pointer parameter if there is no return value, it only sets the length to zero.

So, you might try this:

+	if (!output.length)
+		return AE_NULL_OBJECT;
+

>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
>Sent: Thursday, October 23, 2008 1:43 PM
>To: James Bottomley
>Cc: linux-acpi@vger.kernel.org; linux-kernel; Jesse Barnes; Len Brown
>Subject: Re: Oops in ACPI with git latest
>
>On Thursday, 23 of October 2008, James Bottomley wrote:
>> ACPI Warning (nseval-0168): Insufficient arguments - method [_OSC] needs
>5, found 4 [20080926]
>> ACPI Warning (nspredef-0252): \_SB_.PCI0._OSC: Parameter count mismatch -
>ASL declared 5, expected 4 [20080926]
>> ACPI Error (nspredef-0163): \_SB_.PCI0._OSC: Missing expected return
>value [20080926]
>> BUG: unable to handle kernel NULL pointer dereference at 00000000
>> IP: [<c0237671>] acpi_run_osc+0xa1/0x170
>> *pde = 00000000
>> Oops: 0000 [#1] SMP
>> last sysfs file:
>> Dumping ftrace buffer:
>>    (ftrace buffer empty)
>> Modules linked in:
>>
>> Pid: 1, comm: swapper Not tainted (2.6.27 #124) IBM eServer 206m-
>[8485IZZ]-
>> EIP: 0060:[<c0237671>] EFLAGS: 00010246 CPU: 1
>> EIP is at acpi_run_osc+0xa1/0x170
>> EAX: 00000000 EBX: 00000010 ECX: 00000003 EDX: f704d4ec
>> ESI: 00000000 EDI: 00000000 EBP: f704fde4 ESP: f704fd7c
>>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> Process swapper (pid: 1, ti=f704e000 task=f704d150 task.ti=f704e000)
>> Stack:
>>  f704fdc8 f704fdf0 00000001 00000003 00000010 c04f4a28 c014c3ab 00000001
>>  00000001 00000000 f68766a0 00000001 00000003 00000000 f704fdd4 00000003
>>  0000000c f704fdf0 c023759b 00000000 00000000 00000004 f704fd88 00000010
>> Call Trace:
>>  [<c014c3ab>] ? trace_hardirqs_on+0xb/0x10
>>  [<c023759b>] ? acpi_get_osc_data+0x5b/0x90
>>  [<c02378c4>] ? acpi_query_osc+0x74/0xa0
>>  [<c02486bb>] ? acpi_ns_get_device_callback+0xfe/0x112
>>  [<c0249dbe>] ? acpi_ns_walk_namespace+0x9a/0x110
>>  [<c033a5cc>] ? pci_init+0x0/0x44
>>  [<c0248541>] ? acpi_get_devices+0x47/0x5d
>>  [<c02485bd>] ? acpi_ns_get_device_callback+0x0/0x112
>>  [<c0237850>] ? acpi_query_osc+0x0/0xa0
>>  [<c0237918>] ? __pci_osc_support_set+0x28/0x30
>>  [<c033b99c>] ? msi_init+0x27/0x38
>>  [<c033a5fc>] ? pci_init+0x30/0x44
>>  [<c010111d>] ? do_one_initcall+0x2d/0x160
>>  [<c014c3ab>] ? trace_hardirqs_on+0xb/0x10
>>  [<c01d6c5e>] ? proc_register+0xee/0x1f0
>>  [<c03482ad>] ? _spin_unlock+0x1d/0x20
>>  [<c01d6c5e>] ? proc_register+0xee/0x1f0
>>  [<c01d6e64>] ? create_proc_entry+0x54/0xb0
>>  [<c01622a4>] ? register_irq_proc+0xa4/0xc0
>>  [<c016231c>] ? init_irq_proc+0x5c/0x70
>>  [<c0521325>] ? kernel_init+0x10f/0x166
>>  [<c0521216>] ? kernel_init+0x0/0x166
>>  [<c0104213>] ? kernel_thread_helper+0x7/0x14
>> Code: 00 00 00 c7 45 cc 00 00 00 00 c7 45 d4 03 00 00 00 c7 45 d8 0c 00
>00 00 ba 80 41 4a c0 e8 67 10 01 00 89 c7 85 c0 75 4a 8b 75 e8 <83> 3e 03
>75 5c 8b 46 08 8b 18 85 db 74 29 f6 c3 02 0f 85 82 00
>> EIP: [<c0237671>] acpi_run_osc+0xa1/0x170 SS:ESP 0068:f704fd7c
>> ---[ end trace a7919e7f17c0a725 ]---
>> swapper used greatest stack depth: 5788 bytes left
>> Kernel panic - not syncing: Attempted to kill init!
>
>Does this patch help?
>
>---
> drivers/pci/pci-acpi.c |    3 +++
> 1 file changed, 3 insertions(+)
>
>Index: linux-2.6/drivers/pci/pci-acpi.c
>===================================================================
>--- linux-2.6.orig/drivers/pci/pci-acpi.c
>+++ linux-2.6/drivers/pci/pci-acpi.c
>@@ -83,6 +83,9 @@ static acpi_status acpi_run_osc(acpi_han
> 	if (ACPI_FAILURE(status))
> 		return status;
>
>+	if (!output.pointer)
>+		return AE_NULL_OBJECT;
>+
> 	out_obj = output.pointer;
> 	if (out_obj->type != ACPI_TYPE_BUFFER) {
> 		printk(KERN_DEBUG "Evaluate _OSC returns wrong type\n");
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
