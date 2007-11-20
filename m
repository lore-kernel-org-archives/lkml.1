Return-Path: <linux-kernel-owner+w=401wt.eu-S1764700AbXKTVsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764700AbXKTVsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764477AbXKTVsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:48:25 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:64316 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757646AbXKTVsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:48:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FABrlQkdMROHU/2dsb2JhbACBWw
Date: Tue, 20 Nov 2007 16:43:20 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 04/45] cpu alloc: Use in SLUB
Message-ID: <20071120214319.GA13825@Krystal>
References: <20071120011132.143632442@sgi.com> <20071120011332.652677710@sgi.com> <20071120124202.GA10127@Krystal> <Pine.LNX.4.64.0711201240160.26745@schroedinger.engr.sgi.com> <20071120212328.GA11291@Krystal> <Pine.LNX.4.64.0711201335430.27539@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711201335430.27539@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:42:50 up 17 days,  2:48,  6 users,  load average: 1.83, 2.44,
	1.88
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Tue, 20 Nov 2007, Mathieu Desnoyers wrote:
> 
> > > > > -			__slab_free(s, page, x, addr, c->offset);
> > > > > +		if (unlikely(page != __CPU_READ(c->page) ||
> > > > > +					__CPU_READ(c->node) < 0)) {
> > > > > +			__slab_free(s, page, x, addr, __CPU_READ(c->offset));
> > > > 
> > > > And same question as above : what happens if we fail after executing the
> > > > __slab_free.. is it valid to do it twice ?
> > > 
> > > __slab_free is always successful and will never cause a repeat of the 
> > > loop.
> > 
> > Then what happens if we are migrated between the end of __slab_free and
> > the CPU_CMPXCHG ? The cmpxchg would fail, and the __slab_free will be
> > done twice ?
> 
> Look at the control flow. The __slab_free can never be done twice.
> 
> {
>                 freelist = __CPU_READ(c->freelist);
>                 barrier();
>                 if (unlikely(page != __CPU_READ(c->page) ||
>                                         __CPU_READ(c->node) < 0)) {
>                         __slab_free(s, page, x, addr);
>                         break;
> 			^^^^^^^ no redo of the loop possible.
> 
>                 }
>                 set_freepointer(s, object, freelist);
>         } while (CPU_CMPXCHG(c->freelist, freelist, object) != freelist);
> 

oops, I should remember not to review code before my first coffee in the
morning ;)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
