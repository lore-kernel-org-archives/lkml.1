Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZEJDkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZEJDkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 23:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZEJDkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 23:40:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753236AbZEJDkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 23:40:05 -0400
Date: Sat, 9 May 2009 20:34:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, gorcunov@openvz.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, cl@linux-foundation.org,
       riel@redhat.com, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [PATCH 1/2] mm: Introduce GFP_PANIC for early-boot allocations
Message-Id: <20090509203410.e88a1e94.akpm@linux-foundation.org>
In-Reply-To: <20090509091911.GA13784@elte.hu>
References: <1241795428.28600.60.camel@penberg-laptop>
	<20090508135632.9c041339.akpm@linux-foundation.org>
	<4A054156.60501@cs.helsinki.fi>
	<20090509091911.GA13784@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009 11:19:11 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Hi Andrew,
> >
> > Andrew Morton wrote:
> >> On Fri, 08 May 2009 18:10:28 +0300
> >> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >>
> >>> +#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY)
> >>
> >> urgh, you have to be kidding me.  This significantly worsens complexity
> >> and risk in core MM and it's just yuk.
> >>
> >> I think we can justify pulling such dopey party tricks to save 
> >> pageframe space, or bits in page.flags and such.  But just to 
> >> save a scrap of memory which would have been released during boot 
> >> anwyay?  Don't think so.
> >
> > No, I wasn't kidding and I don't agree that it "significantly 
> > worsens complexity". The point is not to save memory but to 
> > clearly annotate those special call-sites that really don't need 
> > to check for out-of-memory.
> 
> Frankly, i cannot believe that so many smart people dont see the 
> simple, universal, un-arguable truism in the following statement:
> 
>  it is shorter, tidier, more maintainable, more reviewable to write:
> 
> 	ptr = kmalloc(GFP_BOOT, size);
> 
>  than to write:
> 
> 	ptr = kmalloc(GFP_KERNEL, size);
> 	BUG_ON(!ptr);
> 
> We have a lot of such patterns in platform code. Dozens and dozens 
> of them.
> 
> There _might_ be some more nuanced second-level arguments: "yes, I 
> agree in principle, but complexity elsewhere or other side-effects 
> make this a net negative change."
> 
> Alas, those arguments would be wrong too:
> 
>  - we have a lot of such patterns and GFP_BOOT is unambigious 
> 
>  - post-bootup mis-use of GFP_BOOT could be warned about 
>    unconditionally if used after free_initmem(), if we care enough.
> 
>  - Pekka's patch is dead simple. There's no "complexity" anywhere.
> 
> Agreeing to this and introducing this should have been a matter of 
> 30 seconds of thinking. Why are we still arguing about this? Dont we 
> have enough bugs to worry about?
> 

Your reply has nothing at all to do with the email to which you
replied.  How strange.


Here's an example:

void *some_library_function(..., gfp_t gfpflags)
{
	...
	p = kmalloc(..., gfpflags | __GFP_NOFAIL);
	...
}

Now here we have a nice little hand-grenade.  If someone accidentally
does

	some_library_function(..., GFP_KERNEL | __GFP_NORETRY);

their code will happily pass testing.  Except one day someone's kernel
will run out of memory and instead of handling it properly, their kernel
will panic.

Another issue is that now all memory allocation functions which inspect
__GFP_NOFAIL or __GFP_NORETRY need to remember to check for the other
flag to filter out GFP_PANIC.  


Those two flags were well-chosen and it's a good bet that they will
never be used together.  But it's not certain, and the _results_ of
that mistake are really bad: a very small number of machines will crash
very rarely.


We have plenty of bits free there - six, I think.  And we could get
four more if needed by overlaying the `enum mapping_flags' on top of
certain __GFP_* flags and adding appropriate masking in
mapping_gfp_mask().

So I suggest that we add a new __GFP_foo.

