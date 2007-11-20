Return-Path: <linux-kernel-owner+w=401wt.eu-S1763648AbXKTUq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763648AbXKTUq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760504AbXKTUqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:46:44 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35762 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757903AbXKTUqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:46:43 -0500
Date: Tue, 20 Nov 2007 12:46:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 23/45] cpu alloc: dmaengine conversion
In-Reply-To: <20071120125047.GC10127@Krystal>
Message-ID: <Pine.LNX.4.64.0711201245130.26745@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011337.156646718@sgi.com>
 <20071120125047.GC10127@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Mathieu Desnoyers wrote:

> > @@ -488,11 +487,8 @@ dma_async_memcpy_buf_to_buf(struct dma_c
> >  	tx->tx_set_dest(addr, tx, 0);
> >  	cookie = tx->tx_submit(tx);
> >  
> > -	cpu = get_cpu();
> > -	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
> > -	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
> > -	put_cpu();
> > -
> > +	__CPU_ADD(chan->local->bytes_transferred, len);
> > +	__CPU_INC(chan->local->memcpy_count);
> 
> I am wondering about the impact of the preempt disable removal here. It
> means that there is a statistically low probability that we will be
> moved to a different CPU between the bytes_transferred and the
> memcpy_count increments. I hope nobody relies on the fact that the
> per-cpu counts should match perfectly...

True. But as far as I can tell this is just statistics and technically the 
operation is not complete until this function has terminated. So one half 
was run on one and one half on the other. Where the statistics should be 
kept is ambiguous.

Having said that: We could leave the code unchanged if this is a concern.


