Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYL2VgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYL2VgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYL2VgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:36:14 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54665 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYL2VgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:36:13 -0500
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chandru <chandru@in.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <18772.11376.339295.42622@cargo.ozlabs.ibm.com>
References: <200812241325.49404.chandru@in.ibm.com>
	 <20081224233536.b067c9da.akpm@linux-foundation.org>
	 <18772.11376.339295.42622@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 13:36:07 -0800
Message-Id: <1230586567.19452.100.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-26 at 11:59 +1100, Paul Mackerras wrote:
> 
> > diff -puN arch/powerpc/mm/numa.c~2628-rc9-panics-with-crashkernel=256m-while-booting arch/powerpc/mm/numa.c
> > --- a/arch/powerpc/mm/numa.c~2628-rc9-panics-with-crashkernel=256m-while-booting
> > +++ a/arch/powerpc/mm/numa.c
> > @@ -995,10 +995,11 @@ void __init do_init_bootmem(void)
> >                                 start_pfn, end_pfn);
> >  
> >               free_bootmem_with_active_regions(nid, end_pfn);
> > +     }
> > +
> > +     for_each_online_node(nid) {
> >               /*
> > -              * Be very careful about moving this around.  Future
> > -              * calls to careful_allocation() depend on this getting
> > -              * done correctly.
> > +              * Be very careful about moving this around.
> >                */
> >               mark_reserved_regions_for_nid(nid);
> >               sparse_memory_present_with_active_regions(nid);

I think this reintroduces one of the bugs that I squashed.  You *have*
to call mark_reserved_regions_for_nid() right after you do
free_bootmem_with_active_regions().  Otherwise, someone else can
bootmem_alloc() a reserved region from that node.

Perhaps I need to make that comment a bit more forceful. :)

/*
 * Don't break this loop out.  Period.  Never.  Ever.
 * No, seriously.  Don't do it.  I mean it.  Really!
 */

-- Dave

