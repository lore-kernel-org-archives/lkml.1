Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbXISIpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbXISIpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbXISIpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:45:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:56788 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbXISIpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=R0cfOUaZLwfyafivwXsFeIvZvhQRMmMWxlfTyj7/B4EIQebty8IuA2GnqXfXvGI64zwB7riGKoQhijngn13YYM4cNfGyLc8uBm8QkgmI+LSOO3zdz3KaIpQbasmv++hich8BfF6QvrubFYZuEI5BiW/fgbo0gONwnHs7ulQ/1sE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 1/7] Immediate Values - Architecture Independent Code
Date: Wed, 19 Sep 2007 09:45:02 +0100
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070917184224.549435917@polymtl.ca> <200709182101.12284.vda.linux@googlemail.com> <20070918204718.GB12994@Krystal>
In-Reply-To: <20070918204718.GB12994@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709190945.02556.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 21:47, Mathieu Desnoyers wrote:
> * Denys Vlasenko (vda.linux@googlemail.com) wrote:
> > On Tuesday 18 September 2007 18:59, Mathieu Desnoyers wrote:
> > > * Denys Vlasenko (vda.linux@googlemail.com) wrote:
> > > > On Monday 17 September 2007 19:42, Mathieu Desnoyers wrote:
> > > > > Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
> > > > > ===================================================================
> > > > > --- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-09-17 13:25:06.000000000 -0400
> > > > > +++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-09-17 13:35:50.000000000 -0400
> > > > > @@ -122,6 +122,13 @@
> > > > >  		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
> > > > >  	}								\
> > > > >  									\
> > > > > +	/* Immediate values: pointers */				\
> > > > > +	__immediate : AT(ADDR(__immediate) - LOAD_OFFSET) {		\
> > > > > +		VMLINUX_SYMBOL(__start___immediate) = .;		\
> > > > > +		*(__immediate)						\
> > > > > +		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> > > > > +	}								\
> > > > > +									\
> > > > 
> > > > Why do you need an output section for that? IOW: will this work too?
> > > > 
> > > > .data : ... { 
> > > > ...
> > > > 
> > > > 		VMLINUX_SYMBOL(__start___immediate) = .;		\
> > > > 		*(__immediate)						\
> > > > 		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> > > > ...
> > > > }
> > > > 
> > > 
> > > This last one could cause alignment problems. We either have to use the
> > > proper ALIGN() before the section, or let AT(ADDR(__immediate) -
> > > LOAD_OFFSET) take care of it. I prefer the latter.
> > 
> > This adds yet another output section in vmlinux, and there is
> > no tools which need that. We already have 30+ sections there while we need ~20.
> > 
> > I am trying to fix the mess. Please don't add to it.
> > 
> > Re alignment: (1) do you really realy REALLY need it? Last I checked,
> > i386 was handling unaligned accesses just fine; and
> > (2) this works:
> > 
> > 		. = ALIGN(4)
> >  		VMLINUX_SYMBOL(__start___immediate) = .;		\
> >  		*(__immediate)						\
> >  		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> > 
> > 
> 
> Alignment: I need the __start___immediate and __stop___immediate values
> to be at the same alignment as the *(__immediate) content, or else we
> end up thinking that padding is data.
> 
> . = ALIGN(4) works fine as long as the structure within the section is
> not bigger or equal to 32 bytes: gcc has the habit to align 32 bytes
> structure on 32 bytes multiples. The safest way I found to do it is to

Yes, I'm painfully aware of that. gcc is too damn happy to align stuff.

> declare the section as I do: it will cause no breakage if anybody append
> data to the structure.

You can actively fight gcc's sadistic alignment tendencies instead:

struct __immediate {
       long var;               /* Identifier variable of the immediate value */
       long immediate;         /*
                                * Pointer to the memory location that holds
                                * the immediate value within the load immediate
                                * instruction.
                                */
       long size;              /* Type size. */
} __attribute__ ((aligned(sizeof(long))));  <================= HERE

Kernel is already using this technique a lot. Try

grep -r '^\} *__attribute__ *.*aligned' .
--
vda
