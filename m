Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbXISLhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbXISLhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbXISLhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:37:41 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:46039 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbXISLhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:37:40 -0400
Date: Wed, 19 Sep 2007 07:37:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070919113737.GA18177@Krystal>
References: <20070918211324.161373216@polymtl.ca> <20070918211459.193904061@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070918211459.193904061@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:35:40 up 51 days, 11:54,  4 users,  load average: 2.58, 1.77, 1.51
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> The marker activation functions sits in kernel/marker.c. A hash table is used
> to keep track of the registered probes and armed markers, so the markers within
> a newly loaded module that should be active can be activated at module load
> time.
> 
> marker_query has been removed. marker_get_first, marker_get_next and
> marker_release should be used as iterators on the markers.
> 
> Changelog:
> - markers_mutex now nests inside module_mutex rather than the opposite.
> - Iteration on modules is now done in module.c.
> - module_mutex is not exported anymore.
> 
 [...]
> Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-09-14 10:11:18.000000000 -0400
> +++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-09-14 10:11:31.000000000 -0400
> @@ -12,7 +12,11 @@
>  /* .data section */
>  #define DATA_DATA							\
>  	*(.data)							\
> -	*(.data.init.refok)
> +	*(.data.init.refok)						\
> +	. = ALIGN(8);							\
> +	VMLINUX_SYMBOL(__start___markers) = .;				\
> +	*(__markers)							\
> +	VMLINUX_SYMBOL(__stop___markers) = .;
>  
>  #define RO_DATA(align)							\
>  	. = ALIGN((align));						\
> @@ -129,6 +133,11 @@
>  		VMLINUX_SYMBOL(__stop___immediate) = .;			\
>  	}								\
>  									\
> +	/* Markers: strings */						\
> +        __markers_strings : AT(ADDR(__markers_strings) - LOAD_OFFSET) {	\
> +		*(__markers_strings)					\
> + 	}								\
> +									\
>  	/* Kernel symbol table: strings */				\
>          __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
>  		*(__ksymtab_strings)					\
[...]

Do you think I should also remove the __markers_strings section from here ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
