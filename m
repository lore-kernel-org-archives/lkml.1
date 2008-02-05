Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbYBESzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbYBESzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYBESzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:55:12 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:48642 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYBESzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:55:11 -0500
Date: Tue, 5 Feb 2008 19:55:11 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: Support for statistics to help analyze allocator behavior
Message-Id: <20080205195511.b396ea4b.dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0802051007270.11705@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0802050923220.14675@sbz-30.cs.Helsinki.FI>
	<47A81513.4010301@cosmosbay.com>
	<Pine.LNX.4.64.0802050952300.16488@sbz-30.cs.Helsinki.FI>
	<Pine.LNX.4.64.0802051007270.11705@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 10:08:00 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 5 Feb 2008, Pekka J Enberg wrote:
> 
> > Heh, sure, but it's not exported to userspace which is required for 
> > slabinfo to display the statistics.
> 
> Well we could do the same as for numa stats. Output the global count and 
> then add
> 
> c<proc>=count
> 

Yes, or the reverse, to avoid two loops and possible sum errors (Sum of c<proc>=count different than the global count)

Since text##_show is going to be too big, you could use one function instead of several ones ?

(and char *buf is PAGE_SIZE, so you should add a limit ?)

Note I used for_each_possible_cpu() here instead of 'online' variant, or stats might be corrupted when a cpu goes offline.

static ssize_t text_show(struct kmem_cache *s, char *buf, unsigned int si)
{								
	unsigned long val, sum = 0;					
	int cpu;
	size_t off = 0;						
	size_t buflen = PAGE_SIZE;
								
	for_each_possible_cpu(cpu) {				
		val = get_cpu_slab(s, cpu)->stat[si];
#ifdef CONFIG_SMP
		if (val)
			off += snprintf(buf + off, buflen - off, "c%d=%lu ", cpu, val);
#endif
		sum += val;		
        }
	off += snprintf(buf + off, buflen - off, "%lu\n", sum);			
	return off;
}								


