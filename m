Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbZEDQdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbZEDQdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZEDQdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:33:13 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47391 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755126AbZEDQdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:33:12 -0400
Date: Mon, 4 May 2009 12:32:51 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>
Subject: Re: [PATCH v2 0/6] macros for section name cleanup
In-Reply-To: <20090504142732.GA8237@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0905041209570.10610@vinegar-pot.mit.edu>
References: <1241121253-32341-1-git-send-email-tabbott@mit.edu> <20090501213118.GA28126@uranus.ravnborg.org> <alpine.DEB.1.10.0905011916530.10966@vinegar-pot.mit.edu> <20090502220132.GA4130@uranus.ravnborg.org> <20090504142732.GA8237@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Sam Ravnborg wrote:

> I'm especially fond of the "minimal" linker script
> contained in the beginning of the file.

I like this a lot too.

> + *   /DISCARD/ : {  
> + *           EXIT_TEXT
> + *           EXIT_DATA
> + *           *(.exitcall.exit)
> + *   }

You may want to create an EXIT_CALL macro, to remove the explicit mention 
of .exitcall.exit, which is the only input section referenced directly in 
the example script.

> +#define READ_MOSTLY_DATA(align)					\
> +	. = ALIGN(align);						\
> +	*(.data.read_mostly)

Should READ_MOSTLY_DATA have an ALIGN(align) at the end as well?  If the 
goal is to isolate READ_MOSTLY_DATA from other data at the given alignment 
level, this would seem appropriate.  Something similar may apply to 
CACHELINE_ALIGNED_DATA as well.

> +/*
> + * bss (Block started by Symbol) - uninitialized data
> + * zeroed during startup
> + */
> +#define SBSS								\
> +	.sbss : AT(ADDR(.sbss) - LOAD_OFFSET) {				\
> +		*(.sbss)						\
> +		*(.scommon)						\
> +	}

I notice that s390 and powerpc reference a ".dynsbss"; does that belong 
here?

> +#ifdef CONFIG_BLK_DEV_INITRD
> +#define INIT_RAM_FS							\
> +	. = ALIGN(PAGE_SIZE);						\
> +	VMLINUX_SYMBOL(__initramfs_start) = .;				\
> +	*(.init.ramfs)							\
> +	VMLINUX_SYMBOL(__initramfs_end) = .;
> +#else
> +#define INITRAMFS
> +#endif

I think you want the #else clause to be INIT_RAM_FS here.

> +/*
> + * Definition of the high level *_SECTION macros
> + * They will fit only a subset of the architectures
> + */

Do we want a TEXT_SECTION macro here as well that looks like what appears 
above in the example script?

> +#define RW_DATA_SECTION(page_align, readmostly_align, cache_align, 
inittask_align) \
> +     . = ALIGN(PAGE_SIZE);                                           \
> +     .data : AT(ADDR(.data) - LOAD_OFFSET) {                         \
> +             DATA_DATA                                               \
> +             CONSTRUCTORS                                            \
> +             NOSAVE_DATA                                             \
> +             PAGE_ALIGNED_DATA(page_align)                           \
> +             READMOSTLY_DATA(readmostly_align)                       \
> +             CACHELINE_ALIGNED_DATA(cache_align)                     \
> +             INIT_TASK(inittask_align)                               \
> +     }       

How did you pick the order of the sections here?  I would think that to 
pack the .data section efficiently, you'd want to sort by alignment 
requirements so that e.g. all the at-least-page aligned sections are 
adjacent (INIT_TASK and the page-aligned sections are separated by some 
much smaller aligments here).  So it would like either the following or 
the following reversed:

     . = ALIGN(PAGE_SIZE);                                           \
     .data : AT(ADDR(.data) - LOAD_OFFSET) {                         \
             INIT_TASK(inittask_align)                               \
             NOSAVE_DATA                                             \
             PAGE_ALIGNED_DATA(page_align)                           \
             READMOSTLY_DATA(readmostly_align)                       \
             CACHELINE_ALIGNED_DATA(cache_align)                     \
             DATA_DATA                                               \
             CONSTRUCTORS                                            \
     }       

	-Tim Abbott
