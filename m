Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbZFSQT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbZFSQT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 12:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbZFSQTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 12:19:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:56493 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZFSQTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 12:19:21 -0400
Message-ID: <4A3BB9F9.6090203@kernel.org>
Date: Fri, 19 Jun 2009 09:16:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Nathan Lynch <ntl@pobox.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux-foundation.org>, mingo@elte.hu, mel@csn.ul.ie,
       tglx@linutronix.de, hpa@zytor.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       rusty@rustcorp.com.au, steiner@sgi.com, rientjes@google.com,
       containers@lists.linux-foundation.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: clear N_HIGH_MEMORY map before se set it again -v4
References: <4A05269D.8000701@kernel.org> <20090512111623.GG25923@csn.ul.ie> <4A0A64FB.4080504@kernel.org> <20090513145950.GB28097@csn.ul.ie> <4A0C4910.7090508@kernel.org> <4A0C4A2A.6080009@kernel.org> <20090514095414.ba8356e5.akpm@linux-foundation.org> <4A0C4F67.5080802@kernel.org> <20090514102554.b3a36f19.akpm@linux-foundation.org> <4A0C563A.3020100@kernel.org> <4A2758CB.9090404@kernel.org> <alpine.DEB.1.10.0906041236520.5377@gentwo.org> <4A27FAD4.2010104@kernel.org> <alpine.DEB.1.10.0906041309230.8080@gentwo.org> <4A2803D1.4070001@kernel.org> <m3bpokiv0u.fsf@pobox.com> <4A3B49BA.40100@kernel.org> <m3prd0havh.fsf@pobox.com>
In-Reply-To: <m3prd0havh.fsf@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>>> I bisected to the commit containing this change.  Reverting fixes the
>>> problem.
>>>
>> can you use following patch to see what happens to that nodemask?
> 
> # dmesg | grep node_states
> before clear: node_states [3]: 1
> after online check: node_states [3]: 0
> 

/*
 * Array of node states.
 */
nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
        [N_POSSIBLE] = NODE_MASK_ALL,
        [N_ONLINE] = { { [0] = 1UL } },
#ifndef CONFIG_NUMA
        [N_NORMAL_MEMORY] = { { [0] = 1UL } },
#ifdef CONFIG_HIGHMEM
        [N_HIGH_MEMORY] = { { [0] = 1UL } },
#endif
        [N_CPU] = { { [0] = 1UL } },
#endif  /* NUMA */
};
EXPORT_SYMBOL(node_states);

preset that


and

Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001fff0
  HighMem  0x0001fff0 -> 0x0001fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0001fff0
before clear: node_states [3]: 1
On node 0 totalpages: 130959
free_area_init_node: node 0, pgdat c0976960, node_mem_map c1151000
  DMA zone: 60 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3939 pages, LIFO batch:0
  Normal zone: 1860 pages used for memmap
  Normal zone: 125100 pages, LIFO batch:31
after online check: node_states [3]: 0


you don't have high mem, so we should it.

really hate those preset value assume node 0 has RAM...


YH
