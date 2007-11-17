Return-Path: <linux-kernel-owner+w=401wt.eu-S1765637AbXKQUKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765637AbXKQUKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 15:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761651AbXKQUKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 15:10:46 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:48580 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694AbXKQUKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 15:10:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ohPGWEy4X5XxPvvnePLYXEthka9mRcWjCzlrxs7ZGwXHwkw8MAKWfMl36CxGNTlxf7UjQA1JQnw8PVK9ORvy8eFXLiYwOAQSU3Zky/ALHVKuTUv5xVISQMtf3chHRGliFuuMDnqJTyrCZ9cumm7oSdj42CzkwqHXB6BcZ8cLEMs=
Message-ID: <64bb37e0711171210x40dd500ap31e4ea4f8535349d@mail.gmail.com>
Date: Sat, 17 Nov 2007 21:10:44 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, "Andy Whitcroft" <apw@shadowen.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Jan Blunck" <jblunck@suse.de>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>
In-Reply-To: <Pine.LNX.4.64.0711171128530.7986@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <473DA608.1020804@linux.vnet.ibm.com>
	 <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
	 <20071117100507.912c5e5c.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0711171128530.7986@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 17, 2007 8:33 PM, Christoph Lameter <clameter@sgi.com> wrote:
> On Sat, 17 Nov 2007, Andrew Morton wrote:
>
> > That's slub.  It appears that list_lock is being taken from process context
> > in one place and from softirq in another.
>
> I kicked out some weird interrupt disable code in mm that was only run during
> NUMA bootstrap.

I'm using NUMA (Opteron), so this indeed fixes it.

A kernel complied with SLUB now outputs the same message as the SLAB
one, that lockdep annotations are needed at the place where nfs hangs.

> This should fix it but isnt there some mechanism to convince lockdep that
> it is okay to do these things during bootstrap?
>
> ---
>  mm/slub.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c    2007-11-17 11:31:21.044136631 -0800
> +++ linux-2.6/mm/slub.c 2007-11-17 11:32:17.364386560 -0800
> @@ -2044,7 +2044,9 @@ static struct kmem_cache_node *early_kme
>  #endif
>         init_kmem_cache_node(n);
>         atomic_long_inc(&n->nr_slabs);
> +       local_irq_disable();
>         add_partial(kmalloc_caches, page, 0);
> +       local_irq_enable();
>         return n;
>  }
>
>
>
