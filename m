Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbXKTVhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbXKTVhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758605AbXKTVg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:36:59 -0500
Received: from relay1.sgi.com ([192.48.171.29]:60650 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758439AbXKTVg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:36:58 -0500
Date: Tue, 20 Nov 2007 13:36:58 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 04/45] cpu alloc: Use in SLUB
In-Reply-To: <20071120212328.GA11291@Krystal>
Message-ID: <Pine.LNX.4.64.0711201335430.27539@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011332.652677710@sgi.com>
 <20071120124202.GA10127@Krystal> <Pine.LNX.4.64.0711201240160.26745@schroedinger.engr.sgi.com>
 <20071120212328.GA11291@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Mathieu Desnoyers wrote:

> > > > -			__slab_free(s, page, x, addr, c->offset);
> > > > +		if (unlikely(page != __CPU_READ(c->page) ||
> > > > +					__CPU_READ(c->node) < 0)) {
> > > > +			__slab_free(s, page, x, addr, __CPU_READ(c->offset));
> > > 
> > > And same question as above : what happens if we fail after executing the
> > > __slab_free.. is it valid to do it twice ?
> > 
> > __slab_free is always successful and will never cause a repeat of the 
> > loop.
> 
> Then what happens if we are migrated between the end of __slab_free and
> the CPU_CMPXCHG ? The cmpxchg would fail, and the __slab_free will be
> done twice ?

Look at the control flow. The __slab_free can never be done twice.

{
                freelist = __CPU_READ(c->freelist);
                barrier();
                if (unlikely(page != __CPU_READ(c->page) ||
                                        __CPU_READ(c->node) < 0)) {
                        __slab_free(s, page, x, addr);
                        break;
			^^^^^^^ no redo of the loop possible.

                }
                set_freepointer(s, object, freelist);
        } while (CPU_CMPXCHG(c->freelist, freelist, object) != freelist);

