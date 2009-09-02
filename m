Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbZIBGhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbZIBGhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 02:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbZIBGhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 02:37:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37767 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbZIBGhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 02:37:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=n/s5g5qNHUiG4iEvW6UsAtrdYmlBwDOpXx5yJaqmX14AQ0hfGfvdqxGMQNIfGIv2E
	kAlak3OUcWxUrk/RF8QzQ==
Date: Tue, 1 Sep 2009 23:37:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ankita Garg <ankita@in.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] Fix fake numa on ppc
In-Reply-To: <20090902060911.GA5728@in.ibm.com>
Message-ID: <alpine.DEB.1.00.0909012326290.31814@chino.kir.corp.google.com>
References: <20090902060911.GA5728@in.ibm.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009, Ankita Garg wrote:

> Hi,
> 
> Below is a patch to fix a couple of issues with fake numa node creation
> on ppc:
> 
> 1) Presently, fake nodes could be created such that real numa node
> boundaries are not respected. So a node could have lmbs that belong to
> different real nodes.
> 

On x86_64, we can use numa=off to completely disable NUMA so that all 
memory and all cpus are mapped to a single node 0.  That's an extreme 
example of the above and is totally permissible.

> 2) The cpu association is broken. On a JS22 blade for example, which is
> a 2-node numa machine, I get the following:
> 
> # cat /proc/cmdline
> root=/dev/sda6  numa=fake=2G,4G,,6G,8G,10G,12G,14G,16G
> # cat /sys/devices/system/node/node0/cpulist
> 0-3
> # cat /sys/devices/system/node/node1/cpulist
> 4-7
> # cat /sys/devices/system/node/node4/cpulist
> 
> #
> 

This doesn't show what the true NUMA topology of the machine is, could you 
please post the output of

	$ cat /sys/devices/system/node/node*/cpulist
	$ cat /sys/devices/system/node/node*/distance
	$ ls -d /sys/devices/system/node/node*/cpu[0-8]

from a normal boot without any numa=fake?

> So, though the cpus 4-7 should have been associated with node4, they
> still belong to node1. The patch works by recording a real numa node
> boundary and incrementing the fake node count. At the same time, a
> mapping is stored from the real numa node to the first fake node that
> gets created on it.
> 

If there are multiple fake nodes on a real physical node, all cpus in that 
node should appear in the cpulist for each fake node for which it has 
local distance.
