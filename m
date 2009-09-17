Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZIQOp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZIQOp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 10:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbZIQOp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 10:45:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42603 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbZIQOp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 10:45:28 -0400
Message-ID: <4AB24B84.8030503@austin.ibm.com>
Date: Thu, 17 Sep 2009 09:45:24 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dynamic logical partitioning infrastructure
References: <4AAABC55.4070207@austin.ibm.com>	 <4AAABCE3.5090702@austin.ibm.com> <1253064816.5600.103.camel@concordia>
In-Reply-To: <1253064816.5600.103.camel@concordia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> On Fri, 2009-09-11 at 16:10 -0500, Nathan Fontenot wrote:
>> This patch provides the kernel DLPAR infrastructure in a new filed named
>> dlpar.c.  The functionality provided is for acquiring and releasing a 
>> resource from firmware and the parsing of information returned from the
>> ibm,configure-connector rtas call.  Additionally this exports the 
>> pSeries reconfiguration notifier chain so that it can be invoked when
>> device tree updates are made.
>>
>> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
>> ---
>>
>> Index: powerpc/arch/powerpc/platforms/pseries/dlpar.c
>> ===================================================================
>> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
>> +++ powerpc/arch/powerpc/platforms/pseries/dlpar.c	2009-09-11 12:51:52.000000000 -0500
>> @@ -0,0 +1,416 @@
>> +/*
>> + * dlpar.c - support for dynamic reconfiguration (including PCI
>> + * Hotplug and Dynamic Logical Partitioning on RPA platforms).
>> + *
>> + * Copyright (C) 2009 Nathan Fontenot
>> + * Copyright (C) 2009 IBM Corporation
>> + *
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License version
>> + * 2 as published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/kref.h>
>> +#include <linux/notifier.h>
>> +#include <linux/proc_fs.h>
>> +#include <linux/spinlock.h>
>> +
>> +#include <asm/prom.h>
>> +#include <asm/machdep.h>
>> +#include <asm/uaccess.h>
>> +#include <asm/rtas.h>
>> +#include <asm/pSeries_reconfig.h>
>> +
>> +#define CFG_CONN_WORK_SIZE	4096
>> +static char workarea[CFG_CONN_WORK_SIZE];
>> +spinlock_t workarea_lock;
>> +
>> +static struct property *parse_cc_property(char *workarea)
>> +{
>> +	struct property *prop;
>> +	u32 *work_ints;
>> +	char *name;
>> +	char *value;
>> +
>> +	prop = kzalloc(sizeof(*prop), GFP_KERNEL);
>> +	if (!prop)
>> +		return NULL;
>> +
>> +	work_ints = (u32 *)workarea;
>> +	name = workarea + work_ints[2];
>> +	prop->name = kzalloc(strlen(name) + 1, GFP_KERNEL);
>> +	if (!prop->name) {
>> +		kfree(prop);
>> +		return NULL;
>> +	}
>> +
>> +	strcpy(prop->name, name);
>> +
>> +	prop->length = work_ints[3];
>> +	value = workarea + work_ints[4];
>> +	prop->value = kzalloc(prop->length, GFP_KERNEL);
> 
> 
> The use of work_ints is a bit opaque, it might be clearer if you define
> a struct, something like:
> 
> struct cc_prop {
> 	u32 ?;
> 	u32 ?;
> 	u32 name_offset;
> 	u32 length;
> 	u32 value_offset;
> };
> 
> cc = (struct cc_prop *)workarea;
> 
> name = workarea + cc->name_offset;
> ..
> prop->length = cc->length;
> value = workarea + cc->value_offset;
> 

Good idea, and I agree that the use of the workarea/work_ints is a bit vague.
The current way works because sometimes its easier to think of the workarea
as a char buffer and sometimes as a int buffer.

I'll try to come up with something to make the parsing of the workarea buffer
easier to understand.

-Nathan Fontenot
 
> etc.
> 
> 
> Also I don't see any checking of the offsets into workarea (for name &
> value), vs the size of workarea.
> 
> cheers
> 
