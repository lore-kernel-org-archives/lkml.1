Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbYAQXly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbYAQXly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYAQXlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:41:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:15298 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbYAQXlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:41:45 -0500
X-ExtLoop1: 1
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Date: Thu, 17 Jan 2008 15:42:10 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE62B493@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080117232448.GJ12631@alberich.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Thread-Index: AchZYPwVCz+2as9iQtyTI9VRHfIkFAAAKnXQ
References: <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu> <20080117213131.GA25389@linux-os.sc.intel.com> <20080117214209.GA12811@elte.hu> <20080117220650.GE12631@alberich.amd.com> <20080117221505.GB18883@elte.hu> <20080117225243.GH12631@alberich.amd.com> <20080117230410.GA8694@linux-os.sc.intel.com> <20080117232448.GJ12631@alberich.amd.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <ak@muc.de>,
       <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <torvalds@linux-foundation.org>, <gregkh@suse.de>, <airlied@skynet.ie>,
       <davej@redhat.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <akpm@linux-foundation.org>, <arjan@infradead.org>,
       "Barnes, Jesse" <jesse.barnes@intel.com>, <davem@davemloft.net>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Jan 2008 23:41:44.0102 (UTC) FILETIME=[8447BC60:01C85962]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Andreas Herrmann3 [mailto:andreas.herrmann3@amd.com] 
>Sent: Thursday, January 17, 2008 3:25 PM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Siddha, Suresh B; ak@muc.de; 
>ebiederm@xmission.com; rdreier@cisco.com; 
>torvalds@linux-foundation.org; gregkh@suse.de; 
>airlied@skynet.ie; davej@redhat.com; tglx@linutronix.de; 
>hpa@zytor.com; akpm@linux-foundation.org; arjan@infradead.org; 
>Barnes, Jesse; davem@davemloft.net; linux-kernel@vger.kernel.org
>Subject: Re: [patch 0/4] x86: PAT followup - Incremental 
>changes and bug fixes
>
>On Thu, Jan 17, 2008 at 03:04:10PM -0800, Venki Pallipadi wrote:
>> 
>> Below is another potential fix for the problem here. Going 
>through ACPI
>> ioremap usages, we found at one place the mapping is cached 
>for possible
>> optimization reason and not unmapped later. Patch below always unmaps
>> ioremap at this place in ACPICA.
>> 
>> Thanks,
>> Venki
>> 
>> 
>> Index: linux-2.6.git/drivers/acpi/executer/exregion.c
>> ===================================================================
>> --- linux-2.6.git.orig/drivers/acpi/executer/exregion.c	
>2008-01-17 03:18:39.000000000 -0800
>> +++ linux-2.6.git/drivers/acpi/executer/exregion.c	
>2008-01-17 07:34:33.000000000 -0800
>> @@ -48,6 +48,8 @@
>>  #define _COMPONENT          ACPI_EXECUTER
>>  ACPI_MODULE_NAME("exregion")
>>  
>> +static int ioremap_cache;
>> +
>>  
>/**************************************************************
>*****************
>>   *
>>   * FUNCTION:    acpi_ex_system_memory_space_handler
>> @@ -249,6 +251,13 @@
>>  		break;
>>  	}
>>  
>> +	if (!ioremap_cache) {
>> +		acpi_os_unmap_memory(mem_info->mapped_logical_address,
>> +		                     window_size);
>> +		mem_info->mapped_logical_address = 0;
>> +		mem_info->mapped_physical_address = 0;
>> +		mem_info->mapped_length = 0;
>> +	}
>>  	return_ACPI_STATUS(status);
>>  }
>>  
>
>
>Applying and compiling your patch I see:
>
>  CC      drivers/acpi/executer/exregion.o
>drivers/acpi/executer/exregion.c: In function 
>'acpi_ex_system_memory_space_handler':
>drivers/acpi/executer/exregion.c:81: warning: 'window_size' 
>may be used uninitialized in this function
> 
>
>After glancing through this file it seems that ioremap_cache 
>is always 0
>and acpi_os_unmap_memory will unconditionally be executed at 
>end of this function.
>I am not familiar with that code. But I just want to reinsure that this
>is what you want. And if so, why is that variable needed?
>But maybe I missed something ...

I missed that warning. But should not matter for testing this patch as
we always initialize window_size with the patch.

Yes. The variable is not needed. With patch I always map at the
beginning of this function and unmap at the end. I just kept the
variable as I was planning to add a boot option to control this
initially. But, later decided to keep the test patch simple without any
boot option.
We can come up with a better patch once we know that the test patch
helps.

Thanks,
Venki
