Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZFEP0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZFEP0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZFEPZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:25:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbZFEPZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:25:58 -0400
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1243865115.24278.8.camel@nathan.suse.cz>
References: <1243865115.24278.8.camel@nathan.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Fri, 05 Jun 2009 17:25:59 +0200
Message-Id: <1244215559.1604.12.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik píše v Po 01. 06. 2009 v 16:05 +0200:
> The handling of various sections in the VDSO linker script
> looks pretty haphazard. This patch cleans it up in this
> regards:
> 
>  - re-order sections to more closely match the result of
>    a normal shared link
>  - discard sections which are not useful to user-space
>  - issue a linker error if a section is encountered which
>    is known not to work
>  - check that the .got section is empty, except for the
>    three entries defined by the ABI
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

Any comments on this? It doesn't change anything. It only makes it
harder to break vDSOs by accident (such as the latest buglet with TSC
synchronization).

Petr Tesarik

> ---
>  Makefile          |    5 ++--
>  vdso-layout.lds.S |   57 +++++++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 51 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> index 16a9020..8c7f06a 100644
> --- a/arch/x86/vdso/Makefile
> +++ b/arch/x86/vdso/Makefile
> @@ -23,7 +23,8 @@ $(obj)/vdso.o: $(obj)/vdso.so
>  
>  targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
>  
> -export CPPFLAGS_vdso.lds += -P -C
> +vdso-cppflags = -P -C
> +export CPPFLAGS_vdso.lds += -m64 $(vdso-cppflags)
>  
>  VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
>  		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
> @@ -68,7 +69,7 @@ vdso32.so-$(VDSO32-y)		+= sysenter
>  
>  vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
>  
> -CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
> +CPPFLAGS_vdso32.lds = -m32 $(vdso-cppflags)
>  VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
>  
>  # This makes sure the $(obj) subdirectory exists even though vdso32/
> diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
> index 634a2cf..1f4b215 100644
> --- a/arch/x86/vdso/vdso-layout.lds.S
> +++ b/arch/x86/vdso/vdso-layout.lds.S
> @@ -22,16 +22,15 @@ SECTIONS
>  	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
>  
>  	.dynamic	: { *(.dynamic) }		:text	:dynamic
> +	.got		: { *(.got.plt) *(.got) }	:text
>  
> -	.rodata		: { *(.rodata*) }		:text
> +	.rodata		: {
> +		*(.rodata .rodata.* .gnu.linkonce.r.*)
> +	}
>  	.data		: {
> -	      *(.data*)
> -	      *(.sdata*)
> -	      *(.got.plt) *(.got)
> -	      *(.gnu.linkonce.d.*)
> -	      *(.bss*)
> -	      *(.dynbss*)
> -	      *(.gnu.linkonce.b.*)
> +		*(.data .data.* .gnu.linkonce.d.*)
> +		*(.bss .bss.* .gnu.linkonce.b.*)
> +		*(COMMON)
>  	}
>  
>  	.altinstructions	: { *(.altinstructions) }
> @@ -43,9 +42,49 @@ SECTIONS
>  	 */
>  	. = ALIGN(0x100);
>  
> -	.text		: { *(.text*) }			:text	=0x90909090
> +	.text		: {
> +		*(.text .text.* .gnu.linkonce.t.*)
> +	}						:text	=0x90909090
> +
> +	/* We would need a more sophisticated dynamic linker for the
> +	 * vDSO to make the following sections work.  Put them into
> +	 * a special section and raise a link-time error if they get
> +	 * used.
> +	 */
> +	.broken		: {
> +		/* Code in the Procedure Linkage Table will segfault */
> +		*(.plt)
> +
> +		/* Relocation will not be done, so any pointers will
> +		 * still point to the prelinked address, which is wrong
> +		 */
> +		*(.data.rel.ro*)
> +		*(.gnu.linkonce.d.rel.ro.*)
> +
> +		/* Initialization/termination won't work this way */
> +		*(.init) *(.fini)
> +		*(.preinit_array) *(.init_array*)
> +		*(.fini_array*)
> +
> +		/* Thread-local data cannot be defined like this */
> +		*(.tdata .tdata.* .gnu.linkonce.td.*)
> +		*(.tbss .tbss.* .gnu.linkonce.tb.*)
> +		*(.tcommon)
> +	}
> +
> +	/* These sections are not useful */
> +	/DISCARD/	: {
> +		*(.gnu.warning.*)
> +		*(.note.GNU-stack)
> +	}
>  }
>  
> +ASSERT(!SIZEOF(.broken), "VDSO contains sections that don't work properly");
> +
> +/* Check that GOT has only the three entries defined by the ABI */
> +ASSERT(SIZEOF(.got) == 3*__SIZEOF_POINTER__,
> +	"Found extra GOT entries. Check your use of external vars.");
> +
>  /*
>   * Very old versions of ld do not recognize this name token; use the constant.
>   */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

