Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbXJUUWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbXJUUWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 16:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbXJUUWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 16:22:30 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:49226 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXJUUW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 16:22:29 -0400
X-IronPort-AV: E=Sophos;i="4.21,307,1188802800"; 
   d="scan'208";a="240444785"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Question about free/used memory on Linux
Date: Sun, 21 Oct 2007 13:21:39 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847C@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <471BA1D1.5040905@linux.vnet.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question about free/used memory on Linux
Thread-Index: AcgUE7Wml5cZ/7q4SYC0uqo1F6fvIAABTQrw
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com> <471BA1D1.5040905@linux.vnet.ibm.com>
From: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Oct 2007 20:22:22.0423 (UTC) FILETIME=[16365E70:01C81420]
Authentication-Results: sj-dkim-2; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vaidy,
Thanks for clarifying several of my doubts.

To answer your question about my intention, we currently have a 
system with 2 GB RAM and I need to find out the actual used and 
free memory so that we can decide if the same setup(applications,
tmpfs etc.) can run on another system with lesser memory.

Is it correct to say that the "used" field "free -m" excluding
buffers/caches would give the correct idea of used memory
(I mean does it take care of shared memory, shared copies of 
libraries etc.) ? I assume it does not include /dev/shm usage
since that's also a tmpfs partition ?

If so, then I can add the memory used by tmpfs partitions to
the above and get the total memory used ?

For eg. if my "free -m" appears as below:
Linux(debug)# free -m
             total       used       free     shared    buffers
cached
Mem:          2014        984       1030          0         80
594
-/+ buffers/cache:        309       1705

Can I say that 309MB + 350 MB(size of tmpfs partitions including
/dev/shm)
is the used memory on my system ?

Thanks,
Ravi


-----Original Message-----
From: Vaidyanathan Srinivasan [mailto:svaidy@linux.vnet.ibm.com] 
Sent: Sunday, October 21, 2007 12:01 PM
To: Ravinandan Arakali (rarakali)
Cc: Linux Kernel
Subject: Re: Question about free/used memory on Linux

Ravinandan Arakali (rarakali) wrote:
> Hi kernel gurus,
> I am trying to find out the memory that's used on my linux box.
> I find that there are quite a few confusing metrics. How do I find out

> the "true" used memory ?

pagecache pages may be the reason for the confusion.  Most free memory
can be consumed under 'Cached' in /proc/meminfo

Most of this memory is easily reclaimable and can be considered 'free'.
However the cost of reclaim increases if the pages are memory mapped
and/or dirty.

Cached-Mapped-Dirty in /proc/meminfo can be seen as a easily freeable
memory and can be added to the 'Free' in /proc/meminfo count

What is your intention of finding free memory in the system?  Linux
kernel takes the best decision of using available RAM for file cache or
applications code/data as and when needed.  Ideally the 'Free' count
will be  a very low value on a heavily used system.  If application
needs more memory, then the kernel will shrink the caches and give the
reclaimed memory to the application.

> 
> 1. For eg. "free -m" shows free memory (excluding buffers/caches) as 
> 308 MB while I can see(from "df" output) that the the tmpfs partitions

> take up about 400 MB. So, does "free -m" not consider the tmpfs 
> partitions ?

Pages used from tmpfs should come under Mapped or Cached.  They are not
counted as free.

> 2. I try to add up RSS field of all processes reported by "ps aux" 
> command. But is it true that this would be misleading in that, shared 
> memory used by, say 2 processes would show up twice here although 
> there's only one copy in memory. Also does this consider the fact that

> there's only one copy of shared libraries ?
>

RSS is from each process point of view.  If the page is present in RAM,
it is counted.  If the pages is shared, then it is counted in both
process address space.

> 3. I guess "free -m" and "top" commands use /proc/meminfo and hence 
> all these outputs are same ?

Yes, all of them parse /proc/meminfo

--Vaidy
