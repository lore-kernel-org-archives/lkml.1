Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZFIH1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZFIH1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbZFIH0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:26:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbZFIH0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:26:52 -0400
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
From: Petr Tesarik <ptesarik@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
In-Reply-To: <20090605200701.GB23195@uranus.ravnborg.org>
References: <1243865115.24278.8.camel@nathan.suse.cz>
	 <1244215559.1604.12.camel@nathan.suse.cz>
	 <20090605200701.GB23195@uranus.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Tue, 09 Jun 2009 09:26:58 +0200
Message-Id: <1244532418.5199.24.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg píše v Pá 05. 06. 2009 v 22:07 +0200:
> > > diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> > > index 16a9020..8c7f06a 100644
> > > --- a/arch/x86/vdso/Makefile
> > > +++ b/arch/x86/vdso/Makefile
> > > @@ -23,7 +23,8 @@ $(obj)/vdso.o: $(obj)/vdso.so
> > >  
> > >  targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
> > >  
> > > -export CPPFLAGS_vdso.lds += -P -C
> > > +vdso-cppflags = -P -C
> > > +export CPPFLAGS_vdso.lds += -m64 $(vdso-cppflags)
> 
> I am wondering why we need -P -C here - but we do not need it for lds.S files?
> Seems like something we could let go.

Frankly, I don't know, but it's been there for ages, and I don't see
what you mean, anyway. Doesn't the top-level Makefile contain this line,
for example:

export CPPFLAGS_vmlinux.lds += -P -C -U$(ARCH)

> > >  VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
> > >  		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
> > > @@ -68,7 +69,7 @@ vdso32.so-$(VDSO32-y)		+= sysenter
> > >  
> > >  vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
> > >  
> > > -CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
> > > +CPPFLAGS_vdso32.lds = -m32 $(vdso-cppflags)
> > >  VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
> > >  
> > >  # This makes sure the $(obj) subdirectory exists even though vdso32/
> > > diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
> > > index 634a2cf..1f4b215 100644
> > > --- a/arch/x86/vdso/vdso-layout.lds.S
> > > +++ b/arch/x86/vdso/vdso-layout.lds.S
> > > @@ -22,16 +22,15 @@ SECTIONS
> > >  	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
> > >  
> > >  	.dynamic	: { *(.dynamic) }		:text	:dynamic
> > > +	.got		: { *(.got.plt) *(.got) }	:text
> 
> The style we try to introduce for .lds files in
> arch/$ARCH/kernel/vmlinux.lds.S is much more C-like.
> The above would have been:
> 	.got : {
> 		*(.got.plt)
> 		*(.got)
> 	} :text
> 
> Please use this all over so we have a consistent style in linker scripts.

OK, so should I first post a patch which doesn't change anything but
adjusts the coding style of vdso-layout.lds.S?


> > >  	.data		: {
> > > -	      *(.data*)
> > > -	      *(.sdata*)
> > > -	      *(.got.plt) *(.got)
> > > -	      *(.gnu.linkonce.d.*)
> > > -	      *(.bss*)
> > > -	      *(.dynbss*)
> > > -	      *(.gnu.linkonce.b.*)
> > > +		*(.data .data.* .gnu.linkonce.d.*)
> > > +		*(.bss .bss.* .gnu.linkonce.b.*)
> > > +		*(COMMON)
> > >  	}
> Where did *(.sdata*) go?

Nothing changed, really. This section is never produced for i386 or
x86_64. The line might have been a remnant of the (long abandoned) idea
that x86_64 would have .sdata and .data, but it then turned to be
rather .data and .ldata.

> Why do we need *(.data .data.*) rather than *(.data*)?
> *(.dynbss*)?

I don't have any strong opinion here, but the former is exactly what the
default linker script has.

> In your changelog you say:
> "discard sections which are not useful to user-space" - but as you do not
> list which one it is hard to tell what you removed on purpose
> and what you removed by accident.

All those which end up in the section ".broken". I'll make a better
wording next time.

> > >  
> > >  	.altinstructions	: { *(.altinstructions) }
> > > @@ -43,9 +42,49 @@ SECTIONS
> > >  	 */
> > >  	. = ALIGN(0x100);
> 
> What is 0x100?

Um. No idea. Roland, you added this line in commit
f6b46ebf904f69a73907a5e6b1ed2228e3f03d9e. Can you shed some light on
this magic constant?

> > > -	.text		: { *(.text*) }			:text	=0x90909090
> > > +	.text		: {
> > > +		*(.text .text.* .gnu.linkonce.t.*)
> > > +	}						:text	=0x90909090
> > > +
> > > +	/* We would need a more sophisticated dynamic linker for the
> > > +	 * vDSO to make the following sections work.  Put them into
> > > +	 * a special section and raise a link-time error if they get
> > > +	 * used.
> > > +	 */
> > > +	.broken		: {
> > > +		/* Code in the Procedure Linkage Table will segfault */
> > > +		*(.plt)
> > > +
> > > +		/* Relocation will not be done, so any pointers will
> > > +		 * still point to the prelinked address, which is wrong
> > > +		 */
> > > +		*(.data.rel.ro*)
> > > +		*(.gnu.linkonce.d.rel.ro.*)
> > > +
> > > +		/* Initialization/termination won't work this way */
> > > +		*(.init) *(.fini)
> > > +		*(.preinit_array) *(.init_array*)
> > > +		*(.fini_array*)
> > > +
> > > +		/* Thread-local data cannot be defined like this */
> > > +		*(.tdata .tdata.* .gnu.linkonce.td.*)
> > > +		*(.tbss .tbss.* .gnu.linkonce.tb.*)
> > > +		*(.tcommon)
> > > +	}
> > > +
> > > +	/* These sections are not useful */
> > > +	/DISCARD/	: {
> > > +		*(.gnu.warning.*)
> > > +		*(.note.GNU-stack)
> > > +	}
> > >  }
> > >  
> > > +ASSERT(!SIZEOF(.broken), "VDSO contains sections that don't work properly");
> Can you give any better hints where to look and what to look for?

What would you expect? The linker script language is quite limited in
its capabilities... Best I could do is split the ".broken" section into
several sections and move the descriptions from the individual comments
above here. If this muckle of empty ".broken.*" sections gets correctly
discarded and triggers no bug in binutils, I can probably do it.

> > > +
> > > +/* Check that GOT has only the three entries defined by the ABI */
> > > +ASSERT(SIZEOF(.got) == 3*__SIZEOF_POINTER__,
> > > +	"Found extra GOT entries. Check your use of external vars.");
> Can you give any better hints where to look and what to look for?

What would you consider a better hint? If there are any entries in the
GOT, this means that the vDSO tries to access an external function or
variable. But since we don't have a real in-kernel linker for the vDSO,
these references will remain unresolved (and most likely cause a
segmentation fault at run-time).

Cheers,
Petr Tesarik

