Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbZEFQxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbZEFQxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZEFQxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:53:42 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:46803 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbZEFQxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E1RhrTB7yEVEMlhE+6E+ZS7J23IC7vIBNOoeA3goA9wa9dnkxJgU3QXJlZYDf3pKsy
         XgZDfR7k/NfW6Ca5Di+Cm5iYLumft8lQyg/zhi30EgBuZpjfUC4kRvopwErElPtniBnk
         UuZrJnwmomBt7HkQgT84AyWykPgjjXU4CwbXo=
Date: Wed, 6 May 2009 18:53:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, cbe-oss-dev@ozlabs.org,
       srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sputrace: use the generic event tracer
Message-ID: <20090506165336.GC5997@nowhere>
References: <20090506102918.GA23278@lst.de> <20090506105748.GE25203@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506105748.GE25203@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 12:57:48PM +0200, Ingo Molnar wrote:
> 
> (Note: please Cc all tracing related patches to lkml.)
> 
> * Christoph Hellwig <hch@lst.de> wrote:
> 
> > I wrote sputrace before generic tracing infrastrucure was 
> > available. Now that we have the generic event tracer we can 
> > convert it over and remove a lot of code:
> > 
> >   8 files changed, 45 insertions(+), 285 deletions(-)
> 
> Nice! Needs also an Ack from PowerPC folks before we can do this. 
> The cross section to other powerpc code seems to be rather low.
> 
> A few comments:
> 
> > To use it make sure CONFIG_EVENT_TRACING is enabled and then enable
> > the spufs trace channel by
> > 
> >   echo 1 > /sys/kernel/debug/tracing/events/spufs/spufs_context
> > 
> > and then read the trace records using e.g.
> > 
> >   cat /sys/kernel/debug/tracing/trace
> > 
> > 
> > Note that the patch is ontop of the current tracing tree
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git#tracing/ftrace
> > 
> > as there have been some TRACE_EVENT changes in there that aren't in
> > mainline yet.
> > 
> > I don't have any cell hardware anymore so this is only compile tested.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Index: linux-2.6-tip/arch/powerpc/platforms/cell/spufs/sputrace.h
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6-tip/arch/powerpc/platforms/cell/spufs/sputrace.h	2009-05-06 10:17:20.000000000 +0000
> > @@ -0,0 +1,39 @@
> > +#if !defined(_TRACE_SPUFS_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_SPUFS_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM spufs
> > +
> > +TRACE_EVENT(spufs_context,
> > +	TP_PROTO(struct spu_context *ctx, struct spu *spu, const char *name),
> > +	TP_ARGS(ctx, spu, name),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(int, owner_tid)
> > +		__field(const char *, name)


Christoph,

I don't know much the code you are tracing. But it is rare that
a const char * is safe on tracing. Still it could be, you just have to
ensure the string cannot be freed in any way because this pointer
will be stored in the ring buffer and it can be read and dereferenced later
in a random time, could be several years :-)

So if this pointer references built-in data, no problem with that.
But if it can freed (comes from a module, __initdata, ...), then
you should use the __string() field which does an strcpy on the
ring buffer.

If you think this is safe, then it's the best choice because
storing a pointer is of course less costly than an strcpy.
If so I will add the support for char * in the filters (trivial).

Thanks,

Frederic.

