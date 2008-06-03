Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbYFCVle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbYFCVle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbYFCVlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:41:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755686AbYFCVlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:41:22 -0400
Date: Tue, 3 Jun 2008 14:40:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: kosaki.motohiro@jp.fujitsu.com, clameter@sgi.com, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmallocinfo: Add NUMA informations
Message-Id: <20080603144054.973284bb.akpm@linux-foundation.org>
In-Reply-To: <4844BC75.8040705@cosmosbay.com>
References: <48439916.2070108@cosmosbay.com>
	<20080602160548.B6D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<4844BC75.8040705@cosmosbay.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2008 05:37:25 +0200
Eric Dumazet <dada1@cosmosbay.com> wrote:

> [PATCH] vmallocinfo: Add NUMA informations

Using multipart-mixed MIME makes it a bit hard to handle and reply to a
patch.

> Christoph recently added /proc/vmallocinfo file to get information about 
> vmalloc allocations.
> 
> This patch adds NUMA specific information, giving number of pages 
> allocated on each memory node.
> 
> This should help to check that vmalloc() is able to respect NUMA policies.
> 
> Example of output on a four nodes machine (one cpu per node)
> 
> 1) network hash tables are evenly spreaded on four nodes (OK)
>   (Same point for inodes and dentries hash tables)
> 2) iptables tables (x_tables) are correctly allocated on each cpu node 
> (OK).
> 3) sys_swapon() allocates its memory from one node only.
> 4) each loaded module is using memory on one node.
> 
> Sysadmins could tune their setup to change points 3) and 4) if necessary.
> 
> grep "pages="  /proc/vmallocinfo
> 0xffffc20000000000-0xffffc20000201000 2101248 
> alloc_large_system_hash+0x204/0x2c0 pages=512 vmalloc N0=128 N1=128 
> N2=128 N3=128
> 0xffffc20000201000-0xffffc20000302000 1052672 
> alloc_large_system_hash+0x204/0x2c0 pages=256 vmalloc N0=64 N1=64 N2=64 
> N3=64

Yet it did nothing to prevent massive wordwrapping in the changelog :(

> 0xffffc20004904000-0xffffc20004bec000 3047424 sys_swapon+0x640/0xac0 
> pages=743 vmalloc vpages N0=743
> 0xffffffffa0000000-0xffffffffa000f000   61440 
> sys_init_module+0xc27/0x1d00 pages=14 vmalloc N1=14
> 0xffffffffa000f000-0xffffffffa0014000   20480 
> sys_init_module+0xc27/0x1d00 pages=4 vmalloc N0=4
> 0xffffffffa0014000-0xffffffffa0017000   12288 
> sys_init_module+0xc27/0x1d00 pages=2 vmalloc N0=2
> 0xffffffffa0017000-0xffffffffa0022000   45056 
> sys_init_module+0xc27/0x1d00 pages=10 vmalloc N1=10
> 0xffffffffa0022000-0xffffffffa0028000   24576 
> sys_init_module+0xc27/0x1d00 pages=5 vmalloc N3=5

akpm:/usr/src/25> grep -ri vmallocinfo Documentation 
akpm:/usr/src/25> 

Sigh.

> 
> [vmallocinfo_numa.patch  text/plain (944B)]
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 6e45b0f..d2bbd85 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -931,6 +931,27 @@ static void s_stop(struct seq_file *m, void *p)
>  	read_unlock(&vmlist_lock);
>  }
>  
> +static void show_numa_infos(struct seq_file *m, struct vm_struct *v)

"show_numa_info" would be more grammatical.

> +{
> +	if (NUMA_BUILD) {
> +		unsigned int *counters, nr;
> +
> +		counters = kzalloc(nr_node_ids * sizeof(unsigned int),

This is kcalloc().  If you like that sorts of thing - I think kcalloc()
is pretty pointless personally.

> +				   GFP_KERNEL);

We're running under read_lock(&vmlist_lock) here, aren't we?  If so,
please tape Documentation/SubmitChecklist to the bathroom door.  If
not, what prevents *v from vanishing?

Do we actually need dynamic allocation here?  There's a small,
constant, known-at-compile-time upper bound to the number of nodes IDs?


> +		if (!counters)
> +			return;

Will this just lock up until some memory comes free?

> +		for (nr = 0; nr < v->nr_pages; nr++)
> +			counters[page_to_nid(v->pages[nr])]++;
> +
> +		for_each_node_state(nr, N_HIGH_MEMORY)
> +			if (counters[nr])
> +				seq_printf(m, " N%u=%u", nr, counters[nr]);
> +
> +		kfree(counters);
> +	}
> +}
> +
>  static int s_show(struct seq_file *m, void *p)
>  {
>  	struct vm_struct *v = p;
> @@ -967,6 +988,7 @@ static int s_show(struct seq_file *m, void *p)
>  	if (v->flags & VM_VPAGES)
>  		seq_printf(m, " vpages");
>  
> +	show_numa_infos(m, v);
>  	seq_putc(m, '\n');
>  	return 0;
>  }
> 
