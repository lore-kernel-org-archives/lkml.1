Return-Path: <linux-kernel-owner+w=401wt.eu-S1764107AbXHOA5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764107AbXHOA5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbXHOA5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:57:34 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:64538 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763AbXHOA5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=URp1DjA3lu3ewfW9RbhbnsnPwmL1TxNpBH5Y9n6QP+MYZ+uQdowmnQcYFAWNCXP+zqI4NGK/oQ83DEKQoBeEtC1WRfKWW/svdUEn9wB8gmt6/o4xj1syJtZMUdi0h3uks7ZLlOcFPdQj3vKFH/xvNMxwtJMnENjKZPn4Z5/BSic=
Message-ID: <dc1166600708141757q26c005d7o4c9c4d69e9d28460@mail.gmail.com>
Date: Wed, 15 Aug 2007 10:57:32 +1000
From: "Michael Ellerman" <michael@ellerman.id.au>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: SLUB doesn't work with kdump kernel on Cell
Cc: "Lucio Correia" <ljhc@br.ibm.com>, linux-kernel@vger.kernel.org,
       "Arnd Bergmann" <arndb@arndb.de>
In-Reply-To: <Pine.LNX.4.64.0708141241450.30435@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186604151.3608.46.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com>
	 <1187106239.3298.2.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0708141241450.30435@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 6943c7b93fe64e94
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Tue, 14 Aug 2007, Lucio Correia wrote:
>
> > > SLAB boots because it falls back to node 0 for the control structures. So
> > > it creates useless control structures for node 1. These are then never
> > > used since any allocation  attempt to node 1 falls back to node 0.
> >
> > Hi Christoph,
> >
> > Shouldn't SLUB falls back to other node also for the case it can't
> > allocate memory?
>
> Yes SLUB will fall back but not during bootstrap. Bootstrap needs to
> carefully place structures on the right nodes. We fail during bootstrap
> because there is *no* memory available on it.

Sure, you want to have the structures on the right node if possible.
But seeing as there's no memory available, what is wrong with just
falling back?

Something like:

diff --git a/mm/slub.c b/mm/slub.c
index 9b2d617..0fc29d2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1876,6 +1876,8 @@ static struct kmem_cache_node * __init early_kmem_cache_no
        BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));

        page = new_slab(kmalloc_caches, gfpflags | GFP_THISNODE, node);
+       if (!page)
+               page = new_slab(kmalloc_caches, gfpflags, node);

        BUG_ON(!page);
        n = page->freelist;
