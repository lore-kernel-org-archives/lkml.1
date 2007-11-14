Return-Path: <linux-kernel-owner+w=401wt.eu-S1764226AbXKNGOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764226AbXKNGOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759014AbXKNGOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:14:09 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:63080 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759968AbXKNGOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:14:07 -0500
X-IronPort-AV: E=Sophos;i="4.21,414,1188802800"; 
   d="scan'208";a="186552117"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Question about free/used memory on Linux
Date: Tue, 13 Nov 2007 22:14:06 -0800
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B859E@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <471C3A17.5020400@linux.vnet.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question about free/used memory on Linux
Thread-Index: AcgUbo1/W9olNXFIQ4WY88MpvUMGWgSFnpSA
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com> <471BA1D1.5040905@linux.vnet.ibm.com> <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847C@xmb-sjc-214.amer.cisco.com> <471C3A17.5020400@linux.vnet.ibm.com>
From: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Nov 2007 06:14:06.0678 (UTC) FILETIME=[8FE5FF60:01C82685]
Authentication-Results: sj-dkim-2; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vaidy,
What do you think is the right way to get the memory usage of a
process, I mean the actual physical memory used ? Basically,
I'm interested in the incremental cost of a process, which
means, I don't want to include the text segments of shared
libraries which would remain even after the process is killed
(since it would be used by other processes).

Is the RSS field of "ps aux" command the right one or use 
"pmap" command and look at the "writeable" segments ?

Thanks,
Ravi 

-----Original Message-----
From: Vaidyanathan Srinivasan [mailto:svaidy@linux.vnet.ibm.com] 
Sent: Sunday, October 21, 2007 10:50 PM
To: Ravinandan Arakali (rarakali)
Cc: Linux Kernel
Subject: Re: Question about free/used memory on Linux


Ravinandan Arakali (rarakali) wrote:
> Hi Vaidy,
> Thanks for clarifying several of my doubts.
> 
> To answer your question about my intention, we currently have a system

> with 2 GB RAM and I need to find out the actual used and free memory 
> so that we can decide if the same setup(applications, tmpfs etc.) can 
> run on another system with lesser memory.
> 
> Is it correct to say that the "used" field "free -m" excluding 
> buffers/caches would give the correct idea of used memory (I mean does

> it take care of shared memory, shared copies of libraries etc.) ? I 
> assume it does not include /dev/shm usage since that's also a tmpfs 
> partition ?

Thats correct. The used excluding the buffer caches gives most of the
memory used by the system.  You have excludes _all_ file backed memory
including shm.

> 
> If so, then I can add the memory used by tmpfs partitions to the above

> and get the total memory used ?
> 
> For eg. if my "free -m" appears as below:
> Linux(debug)# free -m
>              total       used       free     shared    buffers
> cached
> Mem:          2014        984       1030          0         80
> 594
> -/+ buffers/cache:        309       1705
> 
> Can I say that 309MB + 350 MB(size of tmpfs partitions including
> /dev/shm)
> is the used memory on my system ?

Two problems with this logic:

1. all of tmpfs may not be really used.  You are over committing.
2. You still miss the pages needed to map the program code.  They are
file backed too. Though this will be very less amount of memory compared
to data  and shared memory.

Let me suggest a metric:

1. Take the used part excluding the buffers (309MB) in your case and add
'Mapped' and 'Dirty' from /proc/meminfo

This may be better than adding tmpfs/shmdev size.

2. Once your system is running will all applications loaded, cleanup the
pagecache (file data cached in memory)

sync
echo 1 > /proc/sys/vm/drop_caches

The first sync will bring down 'Dirty' count and drop_caches will
reclaim all 'not needed' file cache memory.

Now if you use 'free' and take the used count _with_ the buffers and
file cache, this will provide a realistic value. (Actually Free in
/proc/meminfo)

Do not exclude buffers they are _needed_ for optimum system operation.
With the above figure you can probably add 10% or more memory as extra
memory for file cache when the system is operating with full load.

If you want to be sure of these experiments boot you system with less
memory using mem=xxx kernel parameter and run some performance tests to
ensure the degradation is under acceptable limits.

--Vaidy
