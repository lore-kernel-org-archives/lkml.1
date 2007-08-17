Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbXHQUhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbXHQUhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbXHQUhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:37:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46314 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753673AbXHQUhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:37:07 -0400
Date: Fri, 17 Aug 2007 13:37:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org, pj@sgi.com
Subject: Re: [PATCH 00/23] per device dirty throttling -v9
In-Reply-To: <1187335158.6114.119.camel@twins>
Message-ID: <Pine.LNX.4.64.0708171333370.9404@schroedinger.engr.sgi.com>
References: <20070816074525.065850000@chello.nl> 
 <Pine.LNX.4.64.0708161424010.18861@schroedinger.engr.sgi.com>
 <1187335158.6114.119.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Peter Zijlstra wrote:

> Currently we do: 
>   dirty = total_dirty * bdi_completions_p * task_dirty_p
> 
> As dgc pointed out before, there is the issue of bdi/task correlation,
> that is, we do not track task dirty rates per bdi, so now a task that
> heavily dirties on one bdi will also get penalised on the others (and
> similar issues).

I think that is tolerable.
> 
> If we were to change it so:
>   dirty = cpuset_dirty * bdi_completions_p * task_dirty_p
> 
> We get additional correlation issues: cpuset/bdi, cpuset/task.
> Which could yield surprising results if some bdis are strictly per
> cpuset.

If we do not do the above then the dirty page calculation for a small 
cpuset (F.e. 1 node of a 128 node system) could allow an amount of dirty
pages that will fill up all the node.

> The cpuset/task correlation has a strict mapping and could be solved by
> keeping the vm_dirties counter per cpuset. However, this would seriously
> complicate the code and I'm not sure if it would gain us much.

The patchset that I referred to has code to calculate the dirty count and 
ratio per cpuset by looping over the nodes. Currently we are having 
trouble with small cpusets not performing writeout correctly. This 
sometimes may result in OOM conditions because the whole node is full of 
dirty pages. If the cpu boundaries are enforced in a strict way then the 
application may fail with an OOM.

We can compensate by recalculating the dirty_ratio based on the smallest 
cpuset but then larger cpusets are penalized. Also one cannot set the 
dirty_ratio below a certain mininum.

