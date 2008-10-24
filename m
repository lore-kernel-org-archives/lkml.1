Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYJXPC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYJXPC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYJXPCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:02:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:31553 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbYJXPCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:02:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,478,1220252400"; 
   d="scan'208";a="64881606"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Date: Fri, 24 Oct 2008 08:02:37 -0700
Subject: RE: [PATCH] Subject: Prevent acpi_run_osc from using NULL objects
 (was: Re: Oops in ACPI with git latest)
Thread-Topic: [PATCH] Subject: Prevent acpi_run_osc from using NULL objects
 (was: Re: Oops in ACPI with git latest)
Thread-Index: Ack1zf3o/AbA1kNVT3eygKQet39DjAAGw/8g
Message-ID: <4911F71203A09E4D9981D27F9D8308580AA7FA4F@orsmsx503.amr.corp.intel.com>
References: <1224791103.3330.37.camel@localhost.localdomain>
 <1224811642.3330.57.camel@localhost.localdomain>
 <200810240857.18190.rjw@sisk.pl> <200810241349.43166.rjw@sisk.pl>
In-Reply-To: <200810241349.43166.rjw@sisk.pl>
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


>> Still, I'd expect the AML interpreter to return error code in this case.


We've just recently deployed a new module that validates the inputs and outputs for the predefined ACPI methods (Those that start with underscore).

That is the source of these messages:

> > ACPI Warning (nspredef-0252): \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, expected 4 [20080926]
> > ACPI Error (nspredef-0163): \_SB_.PCI0._OSC: Missing expected return value [20080926]

For the initial version of this module, we only output messages when the inputs and/or outputs don't match the requirements of the ACPI specification. 

We can change this to returning exceptions in the future.
 

>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
>Sent: Friday, October 24, 2008 4:50 AM
>To: James Bottomley; Jesse Barnes
>Cc: Moore, Robert; linux-acpi@vger.kernel.org; linux-kernel; Len Brown
>Subject: [PATCH] Subject: Prevent acpi_run_osc from using NULL objects
>(was: Re: Oops in ACPI with git latest)
>
>On Friday, 24 of October 2008, Rafael J. Wysocki wrote:
>> On Friday, 24 of October 2008, James Bottomley wrote:
>> > On Thu, 2008-10-23 at 15:34 -0700, Moore, Robert wrote:
>> > > +	if (!output.pointer)
>> > > +		return AE_NULL_OBJECT;
>> > > +
>> > >
>> > > This probably won't work. acpi_evaluate_object currently doesn't
>touch the pointer parameter if there is no return value, it only sets the
>length to zero.
>> >
>> > Actually, it does.
>>
>> Well, this was the only candidate for a NULL pointer dereference, so I'd
>be
>> surprised if it didn't. :-)
>>
>> > > So, you might try this:
>> > >
>> > > +	if (!output.length)
>> > > +		return AE_NULL_OBJECT;
>> > > +
>>
>> Still, I'd expect the AML interpreter to return error code in this case.
>>
>> > This also works.
>>
>> Why don't we make it extra safe, then. ;-)
>>
>> ---
>> From: Rafael J. Wysocki <rjw@sisk.pl>
>> Subject: Prevent acpi_osc_run from using NULL objects
>
>Ah, mistake in the subject.
>
>---
>From: Rafael J. Wysocki <rjw@sisk.pl>
>Subject: Prevent acpi_run_osc from using NULL objects
>
>Check if the object returned by acpi_evaluate_object() in
>acpi_run_osc() is not NULL before using it.
>
>Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
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
>+	if (!output.pointer || !output.length)
>+		return AE_NULL_OBJECT;
>+
> 	out_obj = output.pointer;
> 	if (out_obj->type != ACPI_TYPE_BUFFER) {
> 		printk(KERN_DEBUG "Evaluate _OSC returns wrong type\n");
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
