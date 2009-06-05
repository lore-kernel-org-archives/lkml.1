Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbZFEUEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbZFEUEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 16:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZFEUEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 16:04:46 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:48371 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZFEUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 16:04:46 -0400
Date: Fri, 5 Jun 2009 22:07:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
Message-ID: <20090605200701.GB23195@uranus.ravnborg.org>
References: <1243865115.24278.8.camel@nathan.suse.cz> <1244215559.1604.12.camel@nathan.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244215559.1604.12.camel@nathan.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> > index 16a9020..8c7f06a 100644
> > --- a/arch/x86/vdso/Makefile
> > +++ b/arch/x86/vdso/Makefile
> > @@ -23,7 +23,8 @@ $(obj)/vdso.o: $(obj)/vdso.so
> >  
> >  targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
> >  
> > -export CPPFLAGS_vdso.lds += -P -C
> > +vdso-cppflags = -P -C
> > +export CPPFLAGS_vdso.lds += -m64 $(vdso-cppflags)

I am wondering why we need -P -C here - but we do not need it for lds.S files?
Seems like something we could let go.

> >  
> >  VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
> >  		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
> > @@ -68,7 +69,7 @@ vdso32.so-$(VDSO32-y)		+= sysenter
> >  
> >  vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
> >  
> > -CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
> > +CPPFLAGS_vdso32.lds = -m32 $(vdso-cppflags)
> >  VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
> >  
> >  # This makes sure the $(obj) subdirectory exists even though vdso32/
> > diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
> > index 634a2cf..1f4b215 100644
> > --- a/arch/x86/vdso/vdso-layout.lds.S
> > +++ b/arch/x86/vdso/vdso-layout.lds.S
> > @@ -22,16 +22,15 @@ SECTIONS
> >  	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
> >  
> >  	.dynamic	: { *(.dynamic) }		:text	:dynamic
> > +	.got		: { *(.got.plt) *(.got) }	:text

The style we try to introduce for .lds files in
arch/$ARCH/kernel/vmlinux.lds.S is much more C-like.
The above would have been:
	.got : {
		*(.got.plt)
		*(.got)
	} :text

Please use this all over so we have a consistent style in linker scripts.

> >  	.data		: {
> > -	      *(.data*)
> > -	      *(.sdata*)
> > -	      *(.got.plt) *(.got)
> > -	      *(.gnu.linkonce.d.*)
> > -	      *(.bss*)
> > -	      *(.dynbss*)
> > -	      *(.gnu.linkonce.b.*)
> > +		*(.data .data.* .gnu.linkonce.d.*)
> > +		*(.bss .bss.* .gnu.linkonce.b.*)
> > +		*(COMMON)
> >  	}
Where did *(.sdata*) go?
Why do we need *(.data .data.*) rather than *(.data*)?
*(.dynbss*)?

In your changelog you say:
"discard sections which are not useful to user-space" - but as you do not
list which one it is hard to tell what you removed on purpose
and what you removed by accident.

> >  
> >  	.altinstructions	: { *(.altinstructions) }
> > @@ -43,9 +42,49 @@ SECTIONS
> >  	 */
> >  	. = ALIGN(0x100);

What is 0x100?

> >  
> > -	.text		: { *(.text*) }			:text	=0x90909090
> > +	.text		: {
> > +		*(.text .text.* .gnu.linkonce.t.*)
> > +	}						:text	=0x90909090
> > +
> > +	/* We would need a more sophisticated dynamic linker for the
> > +	 * vDSO to make the following sections work.  Put them into
> > +	 * a special section and raise a link-time error if they get
> > +	 * used.
> > +	 */
> > +	.broken		: {
> > +		/* Code in the Procedure Linkage Table will segfault */
> > +		*(.plt)
> > +
> > +		/* Relocation will not be done, so any pointers will
> > +		 * still point to the prelinked address, which is wrong
> > +		 */
> > +		*(.data.rel.ro*)
> > +		*(.gnu.linkonce.d.rel.ro.*)
> > +
> > +		/* Initialization/termination won't work this way */
> > +		*(.init) *(.fini)
> > +		*(.preinit_array) *(.init_array*)
> > +		*(.fini_array*)
> > +
> > +		/* Thread-local data cannot be defined like this */
> > +		*(.tdata .tdata.* .gnu.linkonce.td.*)
> > +		*(.tbss .tbss.* .gnu.linkonce.tb.*)
> > +		*(.tcommon)
> > +	}
> > +
> > +	/* These sections are not useful */
> > +	/DISCARD/	: {
> > +		*(.gnu.warning.*)
> > +		*(.note.GNU-stack)
> > +	}
> >  }
> >  
> > +ASSERT(!SIZEOF(.broken), "VDSO contains sections that don't work properly");
Can you give any better hints where to look and what to look for?
> > +
> > +/* Check that GOT has only the three entries defined by the ABI */
> > +ASSERT(SIZEOF(.got) == 3*__SIZEOF_POINTER__,
> > +	"Found extra GOT entries. Check your use of external vars.");
Can you give any better hints where to look and what to look for?

	Sam
