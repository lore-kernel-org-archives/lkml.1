Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbYKGXIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbYKGXIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYKGXIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:08:32 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:53324 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbYKGXIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:08:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAAdTFElMQWxa/2dsb2JhbACBdr1OCIsWglMIew
Date: Fri, 7 Nov 2008 18:08:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-ugly] kmemtrace: casting a gfp_t requires __force
Message-ID: <20081107230829.GA10636@Krystal>
References: <1226084321.11596.37.camel@brick> <20081107192029.GA4001@x200.localdomain> <20081107225015.GA5210@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081107225015.GA5210@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:05:02 up 156 days,  3:45,  7 users,  load average: 1.59, 0.81,
	0.76
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
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
> don't want to carry such types into the probe callbacks.

quote :
> It's a lot
> easier to see which u* an unsigned long fits into than it is for
> size_t.

why would you need to limit yourself to u8, u16, u32, u64 ?

sizeof(size_t) tells you for sure what the size of size_t is. You can
even export it to a trace header so that size is know when the trace is
analyzed, neat eh ? :)

Why would you ever want to create a macro to make typing more obscure
and to take considerably more space on architectures where a u64 is not
required ?

Mathieu


> So we take care of this inside a wrapper; the sooner, the better.
> 
> Also take into account that debugging code usually casts pointers to
> unsigned long. This can easily be seen by looking at _RET_IP_ definition
> or SLAB code. I think there's a very good reason to do so, since it adds
> opacity to something that's not supposed to be used as a pointer.
> 
> 
> 	Cheers,
> 	Eduard
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
