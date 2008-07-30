Return-Path: <linux-kernel-owner+w=401wt.eu-S1762302AbYG3OK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbYG3OK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762178AbYG3OJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:09:45 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:33082 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756599AbYG3OJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:09:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EANwSkEhMRKxB/2dsb2JhbACBW4lEpyE
Date: Wed, 30 Jul 2008 10:09:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Module : call synchronize_sched() between module
	exit() and free.
Message-ID: <20080730140938.GC18210@Krystal>
References: <20080717155724.897537670@polymtl.ca> <20080729211543.GB17097@redhat.com> <20080729224115.GA5209@Krystal> <200807301140.59745.rusty@rustcorp.com.au> <20080730022751.GA15866@Krystal> <20080730114035.GD27711@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080730114035.GD27711@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:05:51 up 55 days, 18:46,  4 users,  load average: 0.54, 0.73,
	0.96
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> On Tue, Jul 29, 2008 at 10:27:51PM -0400, Mathieu Desnoyers wrote:
> > [...]
> > Actually, it's not placing a marker/tracepoint in a module which causes
> > a problem, this is a simple function call after all, and correctly dealt
> > with by current module.c code.
> > [...]
> 
> Just to spell it out, it is this scenario I'd like to see documented:
> 
> module-foo.c:
>    foo() { ... trace_mark (foo, "..."); ... }
> 
> module-bar.c:
>    setup() { ... marker_probe_register ("foo" , ..., &foo_handler ); }
>    teardown() { ... marker_probe_unregister ("foo" , ..., &foo_handler ); }
>    foo_handler() { }
> 
> 1)  module-foo loads
> 2)  module-bar loads
> 3)  module-bar.c:setup()
> 4)  module-foo unloads
> 
> What happens here?  Certainly no more calls to foo_handler, but is
> that all?

Yep, that's it. However a hash table still keeps track of the "foo"
handler so that it's reconnected whenever module-foo is reloaded.

>(Would it not be desirable for an active marker to cause
> module-foo's refcount to increase, so as to prevent unloading at this
> time?)

No, because I want to be able to unload the marked module and I don't
want the fact that a probe is connected to it to change that.

> 
> 5)  module-bar.c:teardown()
> 
> Can this teardown code succeed fully even if module-foo is already
> dead and gone?
>   

Yes.

Actually there is a detail missing here. Your teardown should be :
 teardown() { ... marker_probe_unregister ("foo" , ..., &foo_handler );
                  synchronize_sched(); /* Before returning from exit */ }

This makes sure that every live marker call are finished and that it is
safe to unload module-bar (the probe).

Mathieu
> 
> - FChE

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
