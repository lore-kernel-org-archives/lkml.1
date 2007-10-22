Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbXJVGiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbXJVGiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 02:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXJVGiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:38:12 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:27685 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbXJVGiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:38:11 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2007 02:38:11 EDT
X-IronPort-AV: E=Sophos;i="4.21,309,1188802800"; 
   d="scan'208";a="408794212"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Question about free/used memory on Linux
Date: Sun, 21 Oct 2007 23:28:37 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847E@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <471C3A17.5020400@linux.vnet.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question about free/used memory on Linux
Thread-Index: AcgUbo1/W9olNXFIQ4WY88MpvUMGWgABgmsw
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com> <471BA1D1.5040905@linux.vnet.ibm.com> <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847C@xmb-sjc-214.amer.cisco.com> <471C3A17.5020400@linux.vnet.ibm.com>
From: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Oct 2007 06:28:37.0712 (UTC) FILETIME=[C792FD00:01C81474]
Authentication-Results: sj-dkim-4; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vaidy,
I will use the metric you have suggested.

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
