Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbZECQyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbZECQyu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 12:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZECQyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 12:54:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53984 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZECQyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 12:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EdwXSpFuLe80jz6XhCJ4spkAjzvRyM5RmE/FIrS7jO8AAxdh84fdxTzjNJnda7rOXU
         b3cTBOZlAsGPUUi+jkjRDtM3GMAzunPp/QmTXUN3jEGL1wPqKoMkkg5cs0oNeRKruiqU
         yjvTEuYXDhhfx2J7bg1PL3ZWQuV0d/OO3Jt5A=
MIME-Version: 1.0
In-Reply-To: <20090503143824.GF4615@lenovo>
References: <20090501195638.GC4633@lenovo> <20090501200937.GD4633@lenovo>
	 <20090501202511.GE4633@lenovo> <20090501203123.GA10878@sgi.com>
	 <20090503084847.GA20394@elte.hu>
	 <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com>
	 <84144f020905030259i59ea304ftdc9224e6a9b5c285@mail.gmail.com>
	 <20090503121228.GC4615@lenovo>
	 <1241353621.27683.3.camel@penberg-laptop>
	 <20090503143824.GF4615@lenovo>
Date: Sun, 3 May 2009 19:54:38 +0300
X-Google-Sender-Auth: eab9e368a754365c
Message-ID: <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in uv_system_init
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 3, 2009 at 5:38 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Pekka Enberg - Sun, May 03, 2009 at 03:27:00PM +0300]
> | Hi Cyrill,
> |
> | On Sun, 2009-05-03 at 16:12 +0400, Cyrill Gorcunov wrote:
> | > [Pekka Enberg - Sun, May 03, 2009 at 12:59:13PM +0300]
> | > | Hi David,
> | > |
> | > | On Sun, May 3, 2009 at 12:09 PM, David Rientjes <rientjes@google.com> wrote:
> | > | > SLUB stores two new slab allocation orders: the cache's adjustable order
> | > | > which is calculated at kmem_cache_create(), and the smallest order that
> | > | > can accommodate at least one object allocation.  The latter is used as a
> | > | > fallback when the former fails in the page allocator.
> | > | >
> | > | > So for __GFP_PANIC to work in this case, it could not be implemented in
> | > | > the page allocator (SLUB also passes __GFP_NORETRY for new slabs) but
> | > | > rather above it in allocate_slab().  It would then be a no-op for
> | > | > alloc_pages().
> | > |
> | > | It's probably better to implement __GFP_PANIC in alloc_pages() because
> | > | of kmalloc_large(). You can easily mask the __GFP_PANIC from the first
> | > | call to alloc_slab_page() where we use __GFP_NOWARN to suppress
> | > | out-of-memory warnings.
> | > |
> | > | But anyway, enough talk, show me the patch! :-)
> | > |
> | > |                                           Pekka
> | > |
> | >
> | > I was thinking about the approach showed below.
> | >
> | > Note even if we will agree on this idea a number
> | > of questions remain opened -- like where is a better
> | > place to define kmalloc_panic in slub/slab_def.h
> | > or rather in slab.h. Should we include kernel.h
> | > to have panic and pr_ properly defined?
> | >
> | > I don't dare start/introduce handling of __GFP_PANIC
> | > flag since it would require more efforts to be done
> | > correctly and what is more important -- for most
> | > cases we would just don't need it.
> | >
> | >     -- Cyrill
> | >
> | > ---
> | >  include/linux/slab_def.h |   12 ++++++++++++
> | >  1 file changed, 12 insertions(+)
> | >
> | > Index: linux-2.6.git/include/linux/slab_def.h
> | > =====================================================================
> | > --- linux-2.6.git.orig/include/linux/slab_def.h
> | > +++ linux-2.6.git/include/linux/slab_def.h
> | > @@ -220,4 +220,16 @@ found:
> | >
> | >  #endif     /* CONFIG_NUMA */
> | >
> | > +static inline void *kmalloc_panic(size_t size, gfp_t flags)
> | > +{
> | > +   void *p = kmalloc(size, flags);
> | > +
> | > +   if (size && ZERO_OR_NULL_PTR(p)) {
> | > +           pr_emerg("Failed to allocate: %z bytes\n", size);
> | > +           panic("Out of memory\n");
> | > +   }
> | > +
> | > +   return p;
> | > +}
> | > +
> | >  #endif     /* _LINUX_SLAB_DEF_H */
> |
> | I don't like this approach because you'd need to do a kzalloc_panic()
> | and so on for it to be truly useful. What's wrong with adding a
> | __GFP_PANIC check in __alloc_pages_internal() (or whatever it's called
> | in -mm now) next to __GFP_NOWARN?
> |
> |                       Pekka
> |
>
> Hi Pekka,
>
> ufortunatelly __alloc_pages_internal is not the only place where
> we do return NULL from kmalloc. As example - failslab facility
> (in slab_alloc call). Anyway -- I'll take a closer look.

Right. I think failslab needs some fixing _not_ to return NULL if
__GFP_PANIC is set.
