Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbYKGXWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbYKGXWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYKGXWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:22:16 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:34253 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYKGXWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:22:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tXlUIIc0PFBFWGPKyH4KdkO/lYSHBpNrphVvbM21SYdawW+QbXq0t7yC7DA4edq2MY
         CWnbNYSQTThj7mIvbSmsYCQYvBUOl49riVyWoUohPLh9cSH8EkLZmaysbExGcCEm49uT
         Q7DlbWyAB33ivHH2EMcNmjeYwMjEup6HgodyU=
Date: Sat, 8 Nov 2008 02:25:35 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-ugly] kmemtrace: casting a gfp_t requires __force
Message-ID: <20081107232535.GA3869@x200.localdomain>
References: <1226084321.11596.37.camel@brick> <20081107192029.GA4001@x200.localdomain> <20081107225015.GA5210@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107225015.GA5210@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 12:50:16AM +0200, Eduard - Gabriel Munteanu wrote:
> On Fri, Nov 07, 2008 at 10:20:29PM +0300, Alexey Dobriyan wrote:
> > On Fri, Nov 07, 2008 at 10:58:41AM -0800, Harvey Harrison wrote:
> > > --- a/include/linux/kmemtrace.h
> > > +++ b/include/linux/kmemtrace.h
> > > @@ -34,7 +34,7 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
> > >  		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
> > >  		   type_id, call_site, (unsigned long) ptr,
> > >  		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
> > > -		   (unsigned long) gfp_flags, node);
> > > +		   (__force unsigned long)gfp_flags, node);
> > 
> > gfp_t is "unsigned int" actually. These casts are bogus.
> > 
> > Subject: How do I printk <type> correctly?
> > 
> > If variable is of Type	use	printk format specifier.
> > ---------------------------------------------------------
> > 		int			%d or %x
> > 		unsigned int		%u or %x
> > 		long			%ld ot %lx
> > 		unsigned long		%lu or %lx
> > 		long long		%lld or %llx
> > 		unsigned long long	%llu or %llx
> > 		size_t			%zu or %zx
> > 		ssize_t			%zd or %zx
> > 
> > Raw pointer value SHOULD be printed with %p.
> > 
> > u64 SHOULD be printed with %llu/%llx, (unsigned long long):
> > 
> > 	printk("%llu", (unsigned long long)u64_var);
> > 
> > s64 SHOULD be printed with %lld/%llx, (long long):
> > 
> > 	printk("%lld", (long long)s64_var);
> > 
> > If type is dependent on config option (sector_t), use format specifier
> > of biggest type and explicitly cast to it.
> > 
> > Reminder: sizeof() result is of type size_t.
> > 
> > Thank you for your cooperation.
> 
> Hi,
> 
> Actually, "%zu" was the first thing that crossed my mind too. But we
> don't want to carry such types into the probe callbacks. It's a lot
> easier to see which u* an unsigned long fits into than it is for
> size_t. So we take care of this inside a wrapper; the sooner, the better.

Format specifiers are apparently hard.

> Also take into account that debugging code usually casts pointers to
> unsigned long. This can easily be seen by looking at _RET_IP_ definition
> or SLAB code.

You got "const void *" in this wrapper.

> I think there's a very good reason to do so, since it adds
> opacity to something that's not supposed to be used as a pointer.

What is not supposed to be used as pointer? _RET_IP_?
