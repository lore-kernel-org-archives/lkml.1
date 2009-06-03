Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZFCL4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZFCL4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZFCL4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:56:33 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:58660 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZFCL4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:56:32 -0400
Message-ID: <4A2664C7.6040909@linux.vnet.ibm.com>
Date: Wed, 03 Jun 2009 13:55:51 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, andi@firstfloor.org, ying.huang@intel.com,
       W.Li@Sun.COM, michaele@au1.ibm.com, mingo@elte.hu,
       heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com,
       rusty@rustcorp.com.au, xiyou.wangcong@gmail.com, sam@ravnborg.org,
       jdike@addtoit.com
Subject: Re: [PATCH 1/4] kernel: constructor support
References: <20090602114359.129247921@linux.vnet.ibm.com> <20090602114400.740271397@linux.vnet.ibm.com> <20090602143202.6cfcc4ce.akpm@linux-foundation.org>
In-Reply-To: <20090602143202.6cfcc4ce.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 02 Jun 2009 13:44:00 +0200
> Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
>> ...
>>
>> --- linux-2.6.30-rc7.orig/include/asm-generic/vmlinux.lds.h	2009-06-02 10:34:37.000000000 +0200
>> +++ linux-2.6.30-rc7/include/asm-generic/vmlinux.lds.h	2009-06-02 10:35:20.000000000 +0200
> 
> Sam's tree has mucked with this file in linux-next.
> 
>> @@ -332,6 +332,14 @@
>>  /* Section used for early init (in .S files) */
>>  #define HEAD_TEXT  *(HEAD_TEXT_SECTION)
>>  
>> +#ifdef CONFIG_CONSTRUCTORS
>> +#define KERNEL_CTORS()	VMLINUX_SYMBOL(__ctors_start) = .; \
>> +			*(.ctors)			   \
>> +			VMLINUX_SYMBOL(__ctors_end) = .;
>> +#else
>> +#define KERNEL_CTORS()
>> +#endif
>> +
>>  /* init and exit section handling */
>>  #define INIT_DATA							\
>>  	*(.init.data)							\
>> @@ -340,7 +348,8 @@
>>  	CPU_DISCARD(init.data)						\
>>  	CPU_DISCARD(init.rodata)					\
>>  	MEM_DISCARD(init.data)						\
>> -	MEM_DISCARD(init.rodata)
>> +	MEM_DISCARD(init.rodata)					\
>> +	KERNEL_CTORS()
>>  
> 
> What we now have here is
> 
> #define INIT_DATA							\
> 	*(.init.data)							\
> 	DEV_DISCARD(init.data)						\
> 	CPU_DISCARD(init.data)						\
> 	MEM_DISCARD(init.data)						\
> 	*(.init.rodata)							\
> 	DEV_DISCARD(init.rodata)					\
> 	CPU_DISCARD(init.rodata)					\
> 	MEM_DISCARD(init.rodata)
> 
> and I don't think that you wanted KERNEL_DTORS() inside the .rodata
> section, so I did this:
> 
> #define INIT_DATA							\
> 	*(.init.data)							\
> 	DEV_DISCARD(init.data)						\
> 	CPU_DISCARD(init.data)						\
> 	MEM_DISCARD(init.data)						\
> 	KERNEL_CTORS()							\
> 	*(.init.rodata)							\
> 	DEV_DISCARD(init.rodata)					\
> 	CPU_DISCARD(init.rodata)					\
> 	MEM_DISCARD(init.rodata)
> 
> Please check that?

Looks good, compiles and still works. So that's an ACK from me.

