Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbYGJDjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbYGJDjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 23:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYGJDjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 23:39:47 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:55486 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753599AbYGJDjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 23:39:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AikFAM0fdUhMQWVt/2dsb2JhbACBW654
Date: Wed, 9 Jul 2008 23:39:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] simple dprobe like markers for the kernel
Message-ID: <20080710033943.GA19022@Krystal>
References: <1215638551.3444.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1215638551.3444.39.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:34:09 up 35 days,  8:15,  4 users,  load average: 2.99, 3.46,
	3.32
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* James Bottomley (James.Bottomley@HansenPartnership.com) wrote:
> I've been looking at using the existing in kernel markers for dtrace
> named probing in systemtap.  What I find is that they're a bit
> heavyweight when compared to what dtrace does (because of the way they
> drop stubbable calling points).
> 
> This patch adds incredibly simple markers which are designed to be used
> via kprobes.  All it does is add an extra section to the kernel (and
> modules) which annotates the location in source file/line of the marker
> and a description of the variables of interest.  Tools like systemtap
> can then use the kernel dwarf2 debugging information to transform this
> to a precise probe point that gives access to the named variables.
> 
> The beauty of this scheme is that it has zero cost in the unactivated
> case (the extra section is discardable if you're not interested in the
> information, and nothing is actually added into the routine being
> marked).  The disadvantage is that it's really unusable for rolling your
> own marker probes because it relies on the dwarf2 information to locate
> the probe point for kprobes and unravel the local variables of interest,
> so you need an external tool like systemtap to help you.
> 
> The scheme uses a printk format like string to describe the variables of
> interest, so if those variables disappear, the compile breaks (even in
> the unmarked case) which should help us keep the marked probe points
> current.
> 
> For instance, this is what SCSI would look like with a probe point added
> just before the command goes to the low level device
> 
> 		trace_simple(queuecommand, "Command being queued %p Done function %p", cmd, scsi_done);
> 		rtn = host->hostt->queuecommand(cmd, scsi_done);
> 		trace_simple(queuecommand_return, "Command returning %p Return value %d", cmd, rtn);
> 
> Here you can see that each trace point describes two variables whose
> values can be viewed at that point by the relevant tools.  The format
> strings and variables can be used by a tool to perform dtrace -l like
> functionality:
> 
> MODULE    FUNCTION         NAME                DESCRIPTION
> scsi_mod  scsi_dispatch_io queuecommand        Command being queued $sdev; Done function $scsi_done
> scsi_mod  scsi_dispatch_io queuecommand_return Command being queued $sdev; Return value $ret
> 
> So the trace points recommend to the user what variables to use and
> briefly what they mean.
> 
> James
> 

Hi James,

It's interesting to see this try at a stubless marker scheme. A few
things as you and Frank pointed out :
- It depends on an external tool to parse the dwarf info, so it cannot
  be used by in-kernel tracers such as ftrace.
- It does not require variable liveliness at the marker site : the
  compiler can freely optimize out the variable whenever it needs to.

Besides those core concerns, I went through your patch, a small detail
seems incorrect. Please see the comment below.

> ---
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index f054778..c0c38b8 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -299,6 +299,8 @@
>  		.debug_funcnames 0 : { *(.debug_funcnames) }		\
>  		.debug_typenames 0 : { *(.debug_typenames) }		\
>  		.debug_varnames  0 : { *(.debug_varnames) }		\
> +		/* simple markers (depends on dwarf2 debugging info) */	\
> +		__simple_marker (INFO) : { *(__simple_marker) }		\
>  
>  		/* Stabs debugging sections.  */
>  #define STABS_DEBUG							\
> diff --git a/include/linux/simple_marker.h b/include/linux/simple_marker.h
> new file mode 100644
> index 0000000..675f5b1
> --- /dev/null
> +++ b/include/linux/simple_marker.h
> @@ -0,0 +1,41 @@
> +#include <linux/stringify.h>
> +
> +/* To be used for string format validity checking with gcc */
> +static inline void __printf(1, 2)
> +__trace_simple_check_format(const char *fmt, ...)
> +{
> +}
> +
> +#ifdef CONFIG_DEBUG_INFO
> +#define trace_simple(name, format, args...)				\
> +	do {								\
> +		static const char __simple_name_##name[]		\
> +		__attribute__((section("__simple_marker")))		\
> +		__attribute__((__used__))				\
> +		= #name;						\
> +		static const char __simple_file_##name[]		\
> +		__attribute__((section("__simple_marker")))		\
> +		__attribute__((__used__))				\
> +		= __FILE__;						\
> +		static const char __simple_line_##name[]		\
> +		__attribute__((section("__simple_marker")))		\
> +		__attribute__((__used__))				\
> +		= __stringify(__LINE__);				\
> +		static const char __simple_format_##name[]		\
> +		__attribute__((section("__simple_marker")))		\
> +		__attribute__((__used__))				\
> +		= #format;						\
> +		static const char __simple_args_##name[]		\
> +		__attribute__((section("__simple_marker")))		\
> +		__attribute__((__used__))				\
> +		= #args;						\

All those variables placed in the __simple_marker section are not
guaranteed to be placed nicely together. There should be a structure
containing pointers to name, file, line, format and args strings (all
together) in a special section, and then those strings could be emitted
in another section. Otherwise, the compiler can freely choose to
interleave different strings from various tracing statements.

Mathieu

> +		if (0)							\
> +			__trace_simple_check_format(format, ## args);	\
> +	} while(0)
> +#else
> +#define trace_simple(name, format, args...)				\
> +	do {								\
> +		if (0)							\
> +			__trace_simple_check_format(format, ## args);	\
> +	 } while(0)
> +#endif
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
