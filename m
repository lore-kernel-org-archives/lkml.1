Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbZIBIDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbZIBIDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 04:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZIBIDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 04:03:53 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:57728 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbZIBIDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 04:03:51 -0400
Date: Wed, 2 Sep 2009 13:33:46 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] Fix fake numa on ppc
Message-ID: <20090902080346.GB3806@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <20090902060911.GA5728@in.ibm.com> <alpine.DEB.1.00.0909012326290.31814@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0909012326290.31814@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Sep 01, 2009 at 11:37:05PM -0700, David Rientjes wrote:
> On Wed, 2 Sep 2009, Ankita Garg wrote:
> 
> > Hi,
> > 
> > Below is a patch to fix a couple of issues with fake numa node creation
> > on ppc:
> > 
> > 1) Presently, fake nodes could be created such that real numa node
> > boundaries are not respected. So a node could have lmbs that belong to
> > different real nodes.
> > 
> 
> On x86_64, we can use numa=off to completely disable NUMA so that all 
> memory and all cpus are mapped to a single node 0.  That's an extreme 
> example of the above and is totally permissible.
> 
> > 2) The cpu association is broken. On a JS22 blade for example, which is
> > a 2-node numa machine, I get the following:
> > 
> > # cat /proc/cmdline
> > root=/dev/sda6  numa=fake=2G,4G,,6G,8G,10G,12G,14G,16G
> > # cat /sys/devices/system/node/node0/cpulist
> > 0-3
> > # cat /sys/devices/system/node/node1/cpulist
> > 4-7
> > # cat /sys/devices/system/node/node4/cpulist
> > 
> > #
> > 
> 
> This doesn't show what the true NUMA topology of the machine is, could you 
> please post the output of
> 
> 	$ cat /sys/devices/system/node/node*/cpulist
> 	$ cat /sys/devices/system/node/node*/distance
> 	$ ls -d /sys/devices/system/node/node*/cpu[0-8]
> 
> from a normal boot without any numa=fake?
>

Heres the output as requested by you:

# ls /sys/devices/system/node/
has_cpu  has_normal_memory  node0  node1  online  possible
# cat /sys/devices/system/node/node*/cpulist
0-3
4-7
# cat /sys/devices/system/node/node*/distance
10 20
20 10
# ls -d /sys/devices/system/node/node*/cpu[0-8]
/sys/devices/system/node/node0/cpu0  /sys/devices/system/node/node0/cpu3
/sys/devices/system/node/node1/cpu6
/sys/devices/system/node/node0/cpu1  /sys/devices/system/node/node1/cpu4
/sys/devices/system/node/node1/cpu7
/sys/devices/system/node/node0/cpu2  /sys/devices/system/node/node1/cpu5

 
> > So, though the cpus 4-7 should have been associated with node4, they
> > still belong to node1. The patch works by recording a real numa node
> > boundary and incrementing the fake node count. At the same time, a
> > mapping is stored from the real numa node to the first fake node that
> > gets created on it.
> > 
> 
> If there are multiple fake nodes on a real physical node, all cpus in that 
> node should appear in the cpulist for each fake node for which it has 
> local distance.

Currently, the behavior of fake numa is not so on x86 as well? Below is
a sample output from a single node x86 system booted with numa=fake=8:

# cat node0/cpulist

# cat node1/cpulist

...
# cat node6/cpulist

# cat node7/cpulist
0-7

Presently, just fixing the cpu association issue with ppc, as explained
in my previous mail.

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
