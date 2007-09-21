Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbXIUNhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbXIUNhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbXIUNhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:37:24 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:49003 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759557AbXIUNhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:37:22 -0400
Date: Fri, 21 Sep 2007 09:37:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 1/8] Immediate Values - Global Modules List and Module Mutex
Message-ID: <20070921133719.GC13129@Krystal>
References: <20070911004541.GA4360@Krystal> <1189487938.20631.53.camel@localhost.localdomain> <20070911142733.GA7850@Krystal> <1189662432.32322.1.camel@localhost.localdomain> <20070913212107.GA15826@Krystal> <1189725317.7262.23.camel@localhost.localdomain> <20070914153230.GA29743@Krystal> <1190069659.7262.141.camel@localhost.localdomain> <20070918134131.GA22690@Krystal> <1190291351.7262.248.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1190291351.7262.248.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:31:31 up 53 days, 13:50,  4 users,  load average: 0.32, 0.90, 0.84
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Tue, 2007-09-18 at 09:41 -0400, Mathieu Desnoyers wrote:
> > * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > > On Fri, 2007-09-14 at 11:32 -0400, Mathieu Desnoyers wrote:
> > > > * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > > > > Alternatively, if you called it "immediate_init" then the semantics
> > > > > change slightly, but are more obvious (ie. only use this when the value
> > > > > isn't being accessed yet).  But it can't be __init then anyway.
> > > > > 
> > > > 
> > > > I think your idea is good. immediate_init() could be used to update the
> > > > immediate values at boot time _and_ at module load time, and we could
> > > > use an architecture specific arch_immediate_update_init() to support it.
> > > 
> > > Right.
> > > 
> > > > As for "when" to use this, it should be used at boot time when
> > > > interrupts are still disabled, still running in UP. It can also be used
> > > > at module load time before any of the module code is executed, as long
> > > > as the module code pages are writable (which they always are, for
> > > > now..). Therefore, the flag seems inappropriate for module load
> > > > arch_immediate_update_init. It cannot be put in __init section neither
> > > > though if we use it like this.
> > > 
> > > I think from a user's POV it would be nice to have a 1:1 mapping with
> > > normal initialization semantics (ie. it will work as long as you don't
> > > access this value until initialized).  And I think this would be the
> > > case.  eg:
> > > 
> > >         int foo_func(void)
> > >         {
> > >         	if (immediate_read(&some_immediate))
> > >         		return 0;
> > >         	...
> > >         }
> > >         
> > >         int some_init(void)
> > >         {
> > >         	immediate_init(some_immediate, 0);
> > >         	register_foo(foo_func);
> > >         	...
> > >         }
> > > 
> > 
> > There are other considerations that differs between the boot-time case
> > and the general "init" case: the write-protection flag must be
> > cleared-saved/restored when the kernel is running to patch read-only
> > text, but we don't want to modify cr0 at early boot on i386 because
> > paravirt is not executed yet (at boot time, pages are not
> > write-protected yet).
> > 
> > And I am not sure that it buys us anything to create an immediate_init()
> > when we can do exactly the same job with immediate_set. Yes, it might be
> > a bit slower, but we are not on a fast path.
> 
> Good points.  Well I'd say hiding it all behind a friendly
> "immediate_set()" interface is the best option then.
> 

Then we can't benefit of the __init section to have the code removed
after boot. I don't see the point in doing so.

> > > OK, but can you justify the use of immediates within the nmi or mce
> > > handlers?  They don't strike me as useful candidates for optimization.
> > 
> > Yes, immediate values are used by the Linux Kernel Markers, which
> > instrument many code paths, including functions called from nmi and mce
> > contexts (including printk).
> 
> Is this really worth worrying about?  Isn't there already a problem with
> printk() in nmi?
> 

printk() is just an example taken from my current instrumentation. Let's
say I plan to instrument kmalloc() (which will happen someday): it's
used in every context, including NMI. And it's not because printk is
broken that its instrumentation can afford to be broken even further,
that logic seems wrong to me. Somebody go fix printk then ;)

Mathieu

> Cheers,
> Rusty.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
