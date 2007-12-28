Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbXL1BsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbXL1BsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 20:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbXL1BsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 20:48:04 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39474 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbXL1BsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 20:48:01 -0500
Message-ID: <477455A0.7060603@ak.jp.nec.com>
Date: Fri, 28 Dec 2007 10:47:12 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: akpm@osdl.org, morgan@kernel.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com>
In-Reply-To: <20071227161435.GB9677@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting KaiGai Kohei (kaigai@ak.jp.nec.com):
>> This patch enables to export the code/name pairs of capabilities under
>> /capability of securityfs.
>>
>> In the current libcap, it obtains the list of capabilities from header file
>> on the build environment statically. However, it is not enough portable
>> between different versions of kernels, because an already built libcap
>> cannot have knowledge about new added capabilities.
>>
>> Dynamic collection of code/name pairs of capabilities will resolve this
>> matter.
>>
>> But it is not perfect one. I have a bit concern about this patch now.
>>
>> 1. I want to generate cap_entries array from linux/capability.h
>>    automatically. Is there any good idea?
>> 2. We have to mount securityfs explicitly, or using /etc/fstab.
>>    It can make a matter when we want to use this features
>>    in very early boot sequence.
>>
>> Any comment please.
> 
> I like the idea, but
   - snip -
>> +/*
>> + * capability code/name pairs are exported under /sys/security/capability/
>> + */
>> +struct cap_entry_data {
>> +	unsigned int code;
>> +	const char *name;
>> +};
>> +
>> +static struct cap_entry_data cap_entries[] = {
>> +	/* max number of supported format */
>> +	{ _LINUX_CAPABILITY_VERSION,	"version" },
>> +	/* max number of capability */
>> +	{ CAP_LAST_CAP,			"index" },
>> +	/* list of capabilities */
>> +	{ CAP_CHOWN,			"cap_chown" },
>> +	{ CAP_DAC_OVERRIDE,		"cap_dac_override" },
   - snip -
>> +	{ CAP_MAC_OVERRIDE,		"cap_mac_override" },
>> +	{ CAP_MAC_ADMIN,		"cap_mac_admin" },
>> +	{ -1,				NULL},
>> +};
> 
> I don't like this duplication with the list in include/linux/capability.h.
> Now when a new cap is added, it needs to be
> 
> 	1. added to capability.h
> 	2. swapped as the new CAP_LAST_CAP in capability.h
> 	3. added to this list...
> 
> Could you integrate the two lists (not sure how offhand), or at least
> put them in the same place?

The following script will generate cap_entries[] array.

cat include/linux/capability.h				\
  | egrep '^#define[ \t]+CAP_[A-Z_]+[ \t]+[0-9]+$'	\
  | awk '{ printf("\t{ %s, \"\" },\n", $2, tolower($2)); }'

It is nice to include the result of this script, like as:

static struct cap_entry_data cap_entries[] = {
	/* max number of supported format */
	{ _LINUX_CAPABILITY_VERSION,	"version" },
	/* max number of capability */
	{ CAP_LAST_CAP,			"index" },
#include "capability_names.h"
	{ -1,				NULL },
};

I guess we can put this script on Makefile like as kernel/timeconst.pl doing.

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
