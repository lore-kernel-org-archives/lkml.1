Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbYB0H54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbYB0H54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYB0H5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:57:47 -0500
Received: from smtp-out.google.com ([216.239.45.13]:43567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbYB0H5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:57:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=woefRES5nzqQwR4oBXFHUtqVzfE44iVvUHfYt4jReECRxc8xunpSPABPUQsuPfPkV
	FzczVEPKqmIasjmShEoJA==
Date: Tue, 26 Feb 2008 23:56:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
In-Reply-To: <20080227165139.18e5933e.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.00.0802262349090.21857@chino.kir.corp.google.com>
References: <47C4F9C0.5010607@linux.vnet.ibm.com> <alpine.DEB.1.00.0802262201390.1613@chino.kir.corp.google.com> <20080227160746.425E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.1.00.0802262315030.11433@chino.kir.corp.google.com>
 <20080227165139.18e5933e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, KAMEZAWA Hiroyuki wrote:

> Hmm, but kswapd, which is main worker of page reclaiming, is per-node.
> And reclaim is done based on zone.
> per-zone/per-node throttling seems to make sense.
> 

That's another argument for not introducing the sysctl; the number of 
nodes and zones are a static property of the machine that cannot change 
without a reboot (numa=fake, mem=, introducing movable zones, etc).  We 
don't have node hotplug that can suddenly introduce additional zones from 
which to reclaim.

My point was that there doesn't appear to be any use case for tuning this 
via a sysctl that isn't simply attempting to workaround some other reclaim 
problem when the VM is stressed.  If that's agreed upon, then deciding 
between a config option that is either per-cpu or per-node should be based 
on the benchmarks that you've run.  At this time, it appears that per-node 
is the more advantageous.

> I know his environment has 4cpus per node but throttle to 3 was the best
> number in his measurement. Then it seems num-per-cpu is excessive.
> (At least, ratio(%) is better.)

That seems to indicate that the NUMA topology is more important than lock 
contention for the reclaim throttle.

		David
