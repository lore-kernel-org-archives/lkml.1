Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYHYSkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYHYSkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYHYSkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:40:32 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45126 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751144AbYHYSkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:40:32 -0400
Message-ID: <48B2FC9D.3020300@sgi.com>
Date: Mon, 25 Aug 2008 11:40:29 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       cl@linux-foundation.org, tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of
 CPUs
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>	<20080820200709.12F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>	<20080820234615.258a9c04.akpm@linux-foundation.org> <20080821.001322.236658980.davem@davemloft.net>
In-Reply-To: <20080821.001322.236658980.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 20 Aug 2008 23:46:15 -0700
> 
>> On Wed, 20 Aug 2008 20:08:13 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>>> +	num_cpus_per_node = cpus_weight_nr(node_to_cpumask(node));

I think the more correct usage would be:

	{
		node_to_cpumask_ptr(v, node);
		num_cpus_per_node = cpus_weight_nr(*v);
		max /= num_cpus_per_node;

		return max(max, min_pages);
	}

which should load 'v' with a pointer to the node_to_cpumask_map[node] entry
[and avoid using stack space for the cpumask_t variable for those arch's
that define a node_to_cpumask_map (or similar).]  Otherwise a local cpumask_t
variable '_v' is created to which 'v' is pointing to and thus can be used
directly as an arg to the cpu_xxx ops.

Thanks,
Mike


>> sparc64 allmodconfig:
>>
>> mm/quicklist.c: In function `max_pages':
>> mm/quicklist.c:44: error: invalid lvalue in unary `&'
>>
>> we seem to have a made a spectacular mess of cpumasks lately.
> 
> It should explode similarly on x86, since it also defines node_to_cpumask()
> as an inline function.
> 
> IA64 seems to be one of the few platforms to define this as a macro
> evaluating to the node-to-cpumask array entry, so it's clear what
> platform Motohiro-san did build testing on :-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

