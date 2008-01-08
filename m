Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYAHJ1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYAHJ1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbYAHJ1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:27:38 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50212 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbYAHJ1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:27:37 -0500
Message-ID: <478341E9.9000703@linux.vnet.ibm.com>
Date: Tue, 08 Jan 2008 14:57:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bunk@kernel.org, clameter@sgi.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: Linux 2.6.24-rc7 Build-Failure at __you_cannot_kmalloc_that_much
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <478200A4.4090707@linux.vnet.ibm.com> <20080107100733.3655f74f.akpm@linux-foundation.org> <47833231.3080801@linux.vnet.ibm.com>
In-Reply-To: <47833231.3080801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Andrew Morton wrote:
>> On Mon, 07 Jan 2008 16:06:20 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>
>>> The defconfig make fails on x86_64 (AMD box) with following error
>>>
>>>   CHK     include/linux/utsrelease.h
>>>   CALL    scripts/checksyscalls.sh
>>>   CHK     include/linux/compile.h
>>>   GEN     .version
>>>   CHK     include/linux/compile.h
>>>   UPD     include/linux/compile.h
>>>   CC      init/version.o
>>>   LD      init/built-in.o
>>>   LD      .tmp_vmlinux1
>>> drivers/built-in.o(.init.text+0x8d76): In function `dmi_id_init':
>>> : undefined reference to `__you_cannot_kmalloc_that_much'
>>> make: *** [.tmp_vmlinux1] Error 1
>>>
>>>
>>> # gcc --version
>>> gcc (GCC) 3.2.3 20030502 (Red Hat Linux 3.2.3-59)
>>>
>>> This was reported by Adrian Bunk http://lkml.org/lkml/2007/12/1/39
>> That's odd.  afacit the only kmalloc in dmi_id_init() is
>>
>>         dmi_dev = kzalloc(sizeof(*dmi_dev), GFP_KERNEL);
>>
>> and even gcc-3.2.3 should be able to get that right.
>>
>> Could you please a) verify that simply removing that line fixes the build
>> error and then b) try to find some way of fixing it?
>>
>> Try replacing `sizeof(*dmi_dev)' with `sizeof(struct dmi_device_attribute)'
>> and any other tricks you can think of to try to make the compiler process
>> the code differently.
>>
> 
> removing the line fixes the issue, but changing the sizeof(*dmi_dev) to
> sizeof(struct device) is not helping.
> 

Hi, Andrew,

We tried the following, generated stabs information. The size of struct
device is 560 bytes. We found that dead code was not being eliminated
(__you_cannot_kmalloc_that_much), even though no one called that
function. I suspect builtin_constant_p() and dead code elimination as
the root causes of this error.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
