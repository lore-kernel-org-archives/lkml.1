Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYKGWuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYKGWuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYKGWuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:50:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:44714 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYKGWuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:50:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=vXWbf8jwkQAoddtzYzMv8rQKIWoCZmiYgqi0JiBvLKOs2PN+E2hdHzegd19PBQ300S
         SXlSiobkwRwFAZABUBGO4PouA8PMZpg+cPef/X+LRdoCn1YpKd1LkF7vL74e5lrji9dB
         zKLoFhVAnzk4d16PgctRN2CEzmg3zOi9PwOw8=
Date: Sat, 8 Nov 2008 00:50:16 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-ugly] kmemtrace: casting a gfp_t requires __force
Message-ID: <20081107225015.GA5210@localhost>
References: <1226084321.11596.37.camel@brick> <20081107192029.GA4001@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107192029.GA4001@x200.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 10:20:29PM +0300, Alexey Dobriyan wrote:
> On Fri, Nov 07, 2008 at 10:58:41AM -0800, Harvey Harrison wrote:
> > --- a/include/linux/kmemtrace.h
> > +++ b/include/linux/kmemtrace.h
> > @@ -34,7 +34,7 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
> >  		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
> >  		   type_id, call_site, (unsigned long) ptr,
> >  		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
> > -		   (unsigned long) gfp_flags, node);
> > +		   (__force unsigned long)gfp_flags, node);
> 
> gfp_t is "unsigned int" actually. These casts are bogus.
> 
> Subject: How do I printk <type> correctly?
> 
> If variable is of Type	use	printk format specifier.
> ---------------------------------------------------------
> 		int			%d or %x
> 		unsigned int		%u or %x
> 		long			%ld ot %lx
> 		unsigned long		%lu or %lx
> 		long long		%lld or %llx
> 		unsigned long long	%llu or %llx
> 		size_t			%zu or %zx
> 		ssize_t			%zd or %zx
> 
> Raw pointer value SHOULD be printed with %p.
> 
> u64 SHOULD be printed with %llu/%llx, (unsigned long long):
> 
> 	printk("%llu", (unsigned long long)u64_var);
> 
> s64 SHOULD be printed with %lld/%llx, (long long):
> 
> 	printk("%lld", (long long)s64_var);
> 
> If type is dependent on config option (sector_t), use format specifier
> of biggest type and explicitly cast to it.
> 
> Reminder: sizeof() result is of type size_t.
> 
> Thank you for your cooperation.

Hi,

Actually, "%zu" was the first thing that crossed my mind too. But we
don't want to carry such types into the probe callbacks. It's a lot
easier to see which u* an unsigned long fits into than it is for
size_t. So we take care of this inside a wrapper; the sooner, the better.

Also take into account that debugging code usually casts pointers to
unsigned long. This can easily be seen by looking at _RET_IP_ definition
or SLAB code. I think there's a very good reason to do so, since it adds
opacity to something that's not supposed to be used as a pointer.


	Cheers,
	Eduard

