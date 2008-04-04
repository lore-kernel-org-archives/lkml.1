Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYDDQpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYDDQpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 12:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbYDDQp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 12:45:26 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:53100 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017AbYDDQpZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 12:45:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADv49UdMQWoK/2dsb2JhbACBWqos
Date: Fri, 4 Apr 2008 12:40:22 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tom Zanussi <zanussi@us.ibm.com>
Subject: Re: [PATCH] relay: add buffer-only functionality, allowing for
	early kernel tracing
Message-ID: <20080404164022.GA1762@Krystal>
References: <20080404183303.2e239a20@linux360.ro> <20080404160623.GC32126@Krystal> <20080404191943.2d708cbf@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080404191943.2d708cbf@linux360.ro>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:25:01 up 35 days, 12:35,  6 users,  load average: 0.53, 0.59,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Fri, 4 Apr 2008 12:06:23 -0400
> Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > I like this :) But could we trace event sooner if we did not depend on
> > vmalloc to allocate the buffers ?
> > 
> > I am thinking of receiving a kernel parameter that would reserve a
> > buffer in the linear kernel mapping (kmalloc ?), or to compile-in a
> > static buffer, which could be used by relay instead of the vmalloc'd
> > buffer. That would permit to trace the memory allocator and some other
> > very early stuff. Basically, relay would have it's "memory pool" to
> > manage and would do its allocations from this fixed buffer. No free
> > would be required.
> > 
> > Mathieu
> 
> Sure. I'm doing this as part of my GSoC application (well, I haven't
> been accepted yet). I had also proposed this to Pekka Enberg, my
> mentor, but he was reluctant to hack the relay code more invasively. Now
> that you agree with this, I'll work on it.
> 
> kmalloc() doesn't work before kmem_cache_init() and relay code uses
> kmalloc(), not vmalloc(), IIRC.
> 

It currently uses both :

It uses alloc_page and vmap to allocate the buffers and it uses
kzalloc/kmalloc to allocate the relay structures.

> I would go another way. Have the relay client call __get_free_pages()
> or similar function, allocate the buffer and pass it on to a variant of
> relay_open(), let's name it relay_early_open(). __get_free_pages() can
> be used before kmem_cache_init() as far as I know. No free is required,
> since early tracing code implies it's built into the kernel and not as
> a module. What do you say?
> 

Then I guess we would depend on page_alloc_init(). It's not that bad,
but I guess the question is : do we prefer to let users specify the
buffer size to reserve for tracing on the kernel command line (that
would require __get_free_pages()) or do we compile-in a static buffer
size, which can be specified in the kernel configuration. I think
providing both could be an option : flexibility _and_ *very* early
tracing.

So making this relay interface flexible enough to receive a buffer
either reserved by __get_free_pages() or a static buffer seems like a
good compromise. It would also have to receive the buffer size from the
caller.

> Will you merge this or wait until I finish the very early tracing stuff?
> 

As far as I am concerned, I can only merge this in the LTTng project to
try it. I've added Tom Zanussi, the author of relay, who might have some
ideas to share with us. I would wait until we have a more precise idea
of the API before I modify LTTng to start using it.

Regards,

Mathieu

> Cheers,
> Eduard
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
