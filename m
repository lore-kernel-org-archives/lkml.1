Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbZHCTbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbZHCTbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbZHCTbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:31:38 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:53680 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345AbZHCTbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:31:38 -0400
Message-ID: <4A773B26.20007@vmware.com>
Date: Mon, 03 Aug 2009 21:31:50 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thellstrom@vmware.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Dave Airlie <airlied@linux.ie>,
       Arjan van de Ven <arjan@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>
Subject: CPA interfaces WAS x86: Fix CPA memtype reserving in the set_pages_array
 cases
References: <1249284345-7654-1-git-send-email-thellstrom@vmware.com>	 <20090803081110.GB32258@elte.hu>	 <alpine.DEB.2.00.0908030928280.496@skynet.skynet.ie>	 <4A76A24F.1030505@vmware.com> <20090803091954.GB9074@elte.hu>	 <4A76B985.40202@vmware.com>  <20090803104454.GB18165@elte.hu> <1249318705.27006.10777.camel@localhost.localdomain>
In-Reply-To: <1249318705.27006.10777.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha skrev:
>
> Also, now that we have set_pages_array interface, do we still need the
> set_memory_array_uc interface? Removing that should clean up the cpa
> code a bit.
>
> thanks,
> suresh
>
>   
This might be a good time to discuss how graphics drivers will use this 
interface in the not too distant future. These are my thoughts.

1) A pool of uc / wc pages: Jerome Glisse and Dave Airlie have been 
working on this. It will hugely speed up the allocation and freeing of 
transient uc / wc buffers. Pages will be allocated and freed in chunks 
of a couple of megabytes, and caching attributes are changed using the 
set_pages_array() interface. The pool will sit in the TTM driver.
1a) Using large pages: With such a pool it would be beneficial to 
allocate and free large pages to avoid page splitting in the CPA code. 
There is no code in the pool implementation for that yet, but I think 
the set_memory_array_xx will be the best interface for that, although I 
guess set_pages_array_xx would work.

2) Optimize cache flushing:
2a) I think both the TTM code and AGP code flushes the cache before 
changing from wb, to make sure the device sees the data. Therefore with 
these callers, I don't think the CPA code  needs to flush the cache 
again, and it might be beneficial with a "cache_already_flushed" bool to 
some of the function apis.
2b) Use self-snooping where available regardless of the value of the 
"cache_already_flushed" bool.

3) set_pages_array_np():
This is a bit controversial, but will enable a certain valuable class of 
graphics optimizations. The idea is to, instead of marking the PTEs as 
wc or uc, marking them as non-present, np. This means that the TTM code 
does not need to bother with CPA if it wants to make quick cached reads 
from graphics buffers. Just use kmap_atomic() and make sure to clflush 
before unmap.
The caveat is that all np pages must be marked wb before hibernation 
since the hibernation code will try to read from the linear kernel map. 
But we have to deal with that today for uc / wc highmem pages today as 
well since the hibernation code will try to kmap() them with wb page 
attributes.

It would be nice to have some comments on these general ideas before 
starting to work on them.

/Thomas



