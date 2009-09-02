Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZIBF6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZIBF6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 01:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZIBF6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 01:58:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33505 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbZIBF6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 01:58:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=YQo4qN/6vJAFW/MX2wDkHSJohZNLIahNQeniVNIbLL9JJpYUcu2o6r0AyLLLre4Ku
	47kF0gpdccn9vnQrXl15w==
Date: Tue, 1 Sep 2009 22:58:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ankita Garg <ankita@in.ibm.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix fake numa on ppc
In-Reply-To: <20090902053653.GA3806@in.ibm.com>
Message-ID: <alpine.DEB.1.00.0909012246350.26930@chino.kir.corp.google.com>
References: <20090901050316.GA4076@in.ibm.com> <20090901055753.GB5563@balbir.in.ibm.com> <20090901092407.GC4076@in.ibm.com> <20090901142729.GA5022@balbir.in.ibm.com> <20090902053653.GA3806@in.ibm.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009, Ankita Garg wrote:

> > > With the patch,
> > > 
> > > # cat /proc/cmdline
> > > root=/dev/sda6  numa=fake=2G,4G,,6G,8G,10G,12G,14G,16G
> > > # cat /sys/devices/system/node/node0/cpulist
> > > 0-3
> > > # cat /sys/devices/system/node/node1/cpulist
> > > 
> > 
> > Oh! interesting.. cpuless nodes :) I think we need to fix this in the
> > longer run and distribute cpus between fake numa nodes of a real node
> > using some acceptable heuristic.
> >
> 
> True. Presently this is broken on both x86 and ppc systems. It would be
> interesting to find a way to map, for example, 4 cpus to >4 number of
> fake nodes created from a single real numa node!
>  

We've done it for years on x86_64.  It's quite trivial to map all fake 
nodes within a physical node to the cpus to which they have affinity both 
via node_to_cpumask_map() and cpu_to_node_map().  There should be no 
kernel space dependencies on a cpu appearing in only a single node's 
cpumask and if you map each fake node to its physical node's pxm, you can 
index into the slit and generate local NUMA distances amongst fake nodes.

So if you map the apicids and pxms appropriately depending on the 
physical topology of the machine, that is the only emulation necessary on 
x86_64 for the page allocator zonelist ordering, task migration, etc.  (If 
you use CONFIG_SLAB, you'll need to avoid the exponential growth of alien 
caches, but that's an implementation detail and isn't really within the 
scope of numa=fake's purpose to modify.)
