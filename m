Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbZLODxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbZLODxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 22:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758154AbZLODxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 22:53:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:36205 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233AbZLODxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 22:53:42 -0500
Message-ID: <4B270841.2000203@kernel.org>
Date: Tue, 15 Dec 2009 12:53:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 1/8] this_cpu_ops: page allocator conversion
References: <20091214220320.665065925@quilx.com> <20091214220339.160361197@quilx.com>
In-Reply-To: <20091214220339.160361197@quilx.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/15/2009 07:03 AM, Christoph Lameter wrote:
>  static __meminit void zone_pcp_init(struct zone *zone)
>  {
> -	int cpu;
> -	unsigned long batch = zone_batchsize(zone);
> +	/* Use boot pagesets until we have the per cpu allocator up */
> +	zone->pageset = &per_cpu_var(boot_pageset);

Ummm... this scares me a little bit.  Before it was a pointer to
statically allocated area which can be used from basically anywhere.
Now, it's being initialized to a percpu pointer which won't be
available before setup_per_cpu_areas() is complete and the above
initialization takes place from setup_arch() which is before percpu
initialization.  I don't think there's anything which would access
page allocator between the two places, but it still seems a bit risky.
Maybe it's better to keep the boot_pageset a static array?  Or am I
misunderstanding something?

Thanks.

-- 
tejun
