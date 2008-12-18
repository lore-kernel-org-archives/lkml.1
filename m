Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbYLRVyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbYLRVyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYLRVyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:54:23 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:31641 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYLRVyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:54:22 -0500
Message-ID: <494AC64A.5000206@oracle.com>
Date: Thu, 18 Dec 2008 13:53:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 7/7] x86 PAT: update documentation to cover pgprot and
 remap_pfn related changes - v3
References: <20081218194126.963894000@intel.com> <20081218194617.987565000@intel.com> <494ABCF8.8050802@oracle.com> <20081218214940.GA31088@linux-os.sc.intel.com>
In-Reply-To: <20081218214940.GA31088@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.494AC64F.00C0:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> On Thu, Dec 18, 2008 at 01:13:28PM -0800, Randy Dunlap wrote:
>> venkatesh.pallipadi@intel.com wrote:
>>
>> +Advanced APIs for drivers
>> +-------------------------
>> +A. Exporting pages to user with remap_pfn_range, io_remap_pfn_range,
>>
>>                     to users
>> or                  to userspace
>>
>> +vm_insert_pfn
>> +
>> +Drivers wanting to export some pages to userspace, do it by using mmap
>>
>> Drop comma.
>>
>> +interface and a combination of
>> +1) pgprot_noncached()
>> +2) io_remap_pfn_range() or remap_pfn_range() or vm_insert_pfn()
>> +
>> +With pat support, a new API pgprot_writecombine is being added. So, driver can
>>
>> s/pat/PAT/
>> s/driver/drivers/ or s/driver/a driver/
>>
>> +continue to use the above sequence, with either pgprot_noncached() or
>> +pgprot_writecombine() in step 1, followed by step 2.
>> +
>> +In addition, step 2 internally tracks the region as UC or WC in memtype
>> +list in order to ensure no conflicting mapping.
>> +
>> +Note that this set of APIs only work with IO (non RAM) regions. If driver
>>
>>                                  works with IO (non-RAM) regions. If a driver
>>
>> +wants to export RAM region, it has to do set_memory_uc() or set_memory_wc()
>>
>>           export a RAM region,
>>
>> +as step 0 above and also track the usage of those pages and use set_memory_wb()
>> +before the page is freed to free pool.
>>
>>
> 
> refreshed patch below

Some of them were changed, others not changed, with no explanation...
More changes below:


> Thanks,
> Venki
> 
> 
> Add documentation related to pgprot_* change.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  Documentation/x86/pat.txt |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> Index: linux-2.6/Documentation/x86/pat.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/x86/pat.txt	2008-12-17 15:01:50.000000000 -0800
> +++ linux-2.6/Documentation/x86/pat.txt	2008-12-17 17:23:16.000000000 -0800
> @@ -80,6 +80,30 @@ pci proc               |    --    |    -
>                         |          |            |                  |
>  -------------------------------------------------------------------
>  
> +Advanced APIs for drivers
> +-------------------------
> +A. Exporting pages to users with remap_pfn_range, io_remap_pfn_range,
> +vm_insert_pfn
> +
> +Drivers wanting to export some pages to userspace do it by using mmap
> +interface and a combination of
> +1) pgprot_noncached()
> +2) io_remap_pfn_range() or remap_pfn_range() or vm_insert_pfn()
> +
> +With pat support, a new API pgprot_writecombine is being added. So, drivers can

        PAT (please)

> +continue to use the above sequence, with either pgprot_noncached() or
> +pgprot_writecombine() in step 1, followed by step 2.
> +
> +In addition, step 2 internally tracks the region as UC or WC in memtype
> +list in order to ensure no conflicting mapping.
> +
> +Note that this set of APIs only work with IO (non RAM) regions. If a driver

                              only works with IO (non-RAM)

> +wants to export a RAM region, it has to do set_memory_uc() or set_memory_wc()
> +as step 0 above and also track the usage of those pages and use set_memory_wb()
> +before the page is freed to free pool.


-- 
~Randy
