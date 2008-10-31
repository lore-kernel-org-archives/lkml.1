Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbYJaQiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbYJaQiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYJaQil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:38:41 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57962 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYJaQik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:38:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=L6sO1dfscMz1WSy1QiwNXB+o9CUCidlkeOwyzzCPeBccvZOJIgLEf90+ojQHP0IC6
	F6LdjeOYq3cdq2gfoCF/g==
Date: Fri, 31 Oct 2008 09:36:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Chinner <david@fromorbit.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       Paul Menage <menage@google.com>, Derek Fults <dfults@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] cpuset writeback throttling
In-Reply-To: <20081030220344.GL4985@disturbed>
Message-ID: <alpine.DEB.2.00.0810310150160.8229@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com> <20081030210826.GR17077@disturbed> <Pine.LNX.4.64.0810301632030.3839@quilx.com> <20081030220344.GL4985@disturbed>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Dave Chinner wrote:

> This is a fairly major change in behaviour to the writeback path on
> NUMA systems and so has the potential to introduce subtle new
> issues. Hence I'm asking about the level of testing and exposure
> it has had. It doesn't really sound like it has had much coverage
> to me....
> 

I've regression tested it to ensure that there is no significant 
degradation for unconstrained (non-cpuset) configurations, which is 
identical to single system-wide cpuset configurations with ratios that 
match the global sysctls.

So there should be no noticeable difference for non-cpuset users or users 
who attach all system tasks to the root cpuset with this new feature.

To simulate large NUMA systems, numa=fake=32 was used on my small 4G 
machine for 32 system nodes.  A 4G file was created from /dev/zero and a 
non-iterative version of my aforementioned test program (see the end of 
this message) was used to mmap(), dirty, and msync().  This was done with 
Linus' latest -git both with and without this patchset.

Although only 32 nodes were online, these kernels both had a 
CONFIG_NODES_SHIFT of 8 to use the patchset's slowpath (the kmalloc() for 
a struct address_space's dirty_nodes) since MAX_NUMNODES > BITS_PER_LONG.

Without this patchset (five iterations):

	real	2m43.824s   2m41.842s   2m44.103s   2m42.176s   2m43.692s
	user	0m18.946s   0m18.875s   0m18.747s   0m18.969s   0m19.091s
	sys	0m7.722s    0m7.817s    0m7.618s    0m7.635s    0m7.450s

	Device:        tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
	sda         376.68        18.60        17.90       4269       4108
	sda         367.37        18.13        17.45       4269       4108
	sda         388.59        19.19        18.46       4269       4107
	sda         399.44        19.73        18.98       4269       4106
	sda         407.15        20.08        19.33       4271       4110

With this patchset (five iterations):

	real	2m46.337s   2m44.321s   2m46.406s   2m43.237s   2m47.165s
	user	0m19.014s   0m18.985s   0m19.146s   0m18.778s   0m18.937s
	sys	0m7.008s    0m7.180s    0m7.067s    0m7.116s    0m7.188s

	Device:        tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
	sda         399.10        19.71        18.97       4269       4109
	sda         396.85        19.55        18.78       4272       4111
	sda         404.72        19.96        19.23       4270       4112
	sda         403.51        19.93        19.18       4269       4108
	sda         396.33        19.54        18.80       4276       4114

> I'm concerned right now because Nick and others (including myself)
> have recently found lots of nasty data integrity problems in the
> writeback path that we are currently trying to test fixes for.
> It's not a good time to introduce new behaviours as that will
> definitely perturb any regression testing we are running....
> 

Do we need a development freeze of the writeback path for features that 
would be targeted to 2.6.29 at the earliest?

Nasty data integrity problems seem like something that would be addressed 
during the -rc stage.

		David
---
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
	void *addr;
	unsigned long length;
	unsigned long i;
	int fd;

	if (argc != 3) {
		fprintf(stderr, "usage: %s <filename> <length>\n",
			argv[0]);
		exit(1);
	}

	fd = open(argv[1], O_RDWR, 0644);
	if (fd < 0) {
		fprintf(stderr, "Cannot open file %s\n", argv[1]);
		exit(1);
	}

	length = strtoul(argv[2], NULL, 0);
	if (!length) {
		fprintf(stderr, "Invalid length %s\n", argv[2]);
		exit(1);
	}

	addr = mmap(0, length, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
		    0);
	if (addr == MAP_FAILED) {
		fprintf(stderr, "mmap() failed\n");
		exit(1);
	}

	for (i = 0; i < length; i++)
		(*(char *)(addr + i))++;
	msync(addr, length, MS_SYNC);
	return 0;
}
