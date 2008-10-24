Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYJXO6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYJXO6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYJXO55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:57:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:48269 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbYJXO54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:57:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,478,1220252400"; 
   d="scan'208";a="455155736"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Date: Fri, 24 Oct 2008 07:57:51 -0700
Subject: RE: Oops in ACPI with git latest
Thread-Topic: Oops in ACPI with git latest
Thread-Index: Ack1pTOW4prVlKUDTcK6mjIt2xSkwgAQ5RTA
Message-ID: <4911F71203A09E4D9981D27F9D8308580AA7FA41@orsmsx503.amr.corp.intel.com>
References: <1224791103.3330.37.camel@localhost.localdomain>
 <4911F71203A09E4D9981D27F9D830858033D1CC9@orsmsx503.amr.corp.intel.com>
 <1224811642.3330.57.camel@localhost.localdomain>
 <200810240857.18190.rjw@sisk.pl>
In-Reply-To: <200810240857.18190.rjw@sisk.pl>
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

Since acpi_evaluate_object doesn't set the pointer value, it may be simply random.

>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>Sent: Thursday, October 23, 2008 11:57 PM
>To: James Bottomley; Jesse Barnes
>Cc: Moore, Robert; linux-acpi@vger.kernel.org; linux-kernel; Len Brown
>Subject: Re: Oops in ACPI with git latest
>
>On Friday, 24 of October 2008, James Bottomley wrote:
>> On Thu, 2008-10-23 at 15:34 -0700, Moore, Robert wrote:
>> > +	if (!output.pointer)
>> > +		return AE_NULL_OBJECT;
>> > +
>> >
>> > This probably won't work. acpi_evaluate_object currently doesn't touch
>the pointer parameter if there is no return value, it only sets the length
>to zero.
>>
>> Actually, it does.
>
>Well, this was the only candidate for a NULL pointer dereference, so I'd be
>surprised if it didn't. :-)
>
>> > So, you might try this:
>> >
>> > +	if (!output.length)
>> > +		return AE_NULL_OBJECT;
>> > +
>
>Still, I'd expect the AML interpreter to return error code in this case.
>
>> This also works.
>
>Why don't we make it extra safe, then. ;-)
>
>---
>From: Rafael J. Wysocki <rjw@sisk.pl>
>Subject: Prevent acpi_osc_run from using NULL objects
>
>Check if the object returned by acpi_evaluate_object() in
>acpi_run_osc() is not NULL.
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
