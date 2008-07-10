Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbYGJNzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbYGJNzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbYGJNzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:55:07 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52942 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505AbYGJNzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:55:05 -0400
Subject: Re: [RFC] simple dprobe like markers for the kernel
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <20080710033943.GA19022@Krystal>
References: <1215638551.3444.39.camel@localhost.localdomain>
	 <20080710033943.GA19022@Krystal>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 08:55:01 -0500
Message-Id: <1215698101.3353.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-09 at 23:39 -0400, Mathieu Desnoyers wrote:
> * James Bottomley (James.Bottomley@HansenPartnership.com) wrote:
> > I've been looking at using the existing in kernel markers for dtrace
> > named probing in systemtap.  What I find is that they're a bit
> > heavyweight when compared to what dtrace does (because of the way they
> > drop stubbable calling points).
> > 
> > This patch adds incredibly simple markers which are designed to be used
> > via kprobes.  All it does is add an extra section to the kernel (and
> > modules) which annotates the location in source file/line of the marker
> > and a description of the variables of interest.  Tools like systemtap
> > can then use the kernel dwarf2 debugging information to transform this
> > to a precise probe point that gives access to the named variables.
> > 
> > The beauty of this scheme is that it has zero cost in the unactivated
> > case (the extra section is discardable if you're not interested in the
> > information, and nothing is actually added into the routine being
> > marked).  The disadvantage is that it's really unusable for rolling your
> > own marker probes because it relies on the dwarf2 information to locate
> > the probe point for kprobes and unravel the local variables of interest,
> > so you need an external tool like systemtap to help you.
> > 
> > The scheme uses a printk format like string to describe the variables of
> > interest, so if those variables disappear, the compile breaks (even in
> > the unmarked case) which should help us keep the marked probe points
> > current.
> > 
> > For instance, this is what SCSI would look like with a probe point added
> > just before the command goes to the low level device
> > 
> > 		trace_simple(queuecommand, "Command being queued %p Done function %p", cmd, scsi_done);
> > 		rtn = host->hostt->queuecommand(cmd, scsi_done);
> > 		trace_simple(queuecommand_return, "Command returning %p Return value %d", cmd, rtn);
> > 
> > Here you can see that each trace point describes two variables whose
> > values can be viewed at that point by the relevant tools.  The format
> > strings and variables can be used by a tool to perform dtrace -l like
> > functionality:
> > 
> > MODULE    FUNCTION         NAME                DESCRIPTION
> > scsi_mod  scsi_dispatch_io queuecommand        Command being queued $sdev; Done function $scsi_done
> > scsi_mod  scsi_dispatch_io queuecommand_return Command being queued $sdev; Return value $ret
> > 
> > So the trace points recommend to the user what variables to use and
> > briefly what they mean.
> > 
> > James
> > 
> 
> Hi James,
> 
> It's interesting to see this try at a stubless marker scheme. A few
> things as you and Frank pointed out :
> - It depends on an external tool to parse the dwarf info, so it cannot
>   be used by in-kernel tracers such as ftrace.

Actually, I think I listed that as one of the issues.

> - It does not require variable liveliness at the marker site : the
>   compiler can freely optimize out the variable whenever it needs to.

Correct ... by design a zero impact probe must not affect the
optimisation.

> Besides those core concerns, I went through your patch, a small detail
> seems incorrect. Please see the comment below.
> 
> > ---
> > 
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index f054778..c0c38b8 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -299,6 +299,8 @@
> >  		.debug_funcnames 0 : { *(.debug_funcnames) }		\
> >  		.debug_typenames 0 : { *(.debug_typenames) }		\
> >  		.debug_varnames  0 : { *(.debug_varnames) }		\
> > +		/* simple markers (depends on dwarf2 debugging info) */	\
> > +		__simple_marker (INFO) : { *(__simple_marker) }		\
> >  
> >  		/* Stabs debugging sections.  */
> >  #define STABS_DEBUG							\
> > diff --git a/include/linux/simple_marker.h b/include/linux/simple_marker.h
> > new file mode 100644
> > index 0000000..675f5b1
> > --- /dev/null
> > +++ b/include/linux/simple_marker.h
> > @@ -0,0 +1,41 @@
> > +#include <linux/stringify.h>
> > +
> > +/* To be used for string format validity checking with gcc */
> > +static inline void __printf(1, 2)
> > +__trace_simple_check_format(const char *fmt, ...)
> > +{
> > +}
> > +
> > +#ifdef CONFIG_DEBUG_INFO
> > +#define trace_simple(name, format, args...)				\
> > +	do {								\
> > +		static const char __simple_name_##name[]		\
> > +		__attribute__((section("__simple_marker")))		\
> > +		__attribute__((__used__))				\
> > +		= #name;						\
> > +		static const char __simple_file_##name[]		\
> > +		__attribute__((section("__simple_marker")))		\
> > +		__attribute__((__used__))				\
> > +		= __FILE__;						\
> > +		static const char __simple_line_##name[]		\
> > +		__attribute__((section("__simple_marker")))		\
> > +		__attribute__((__used__))				\
> > +		= __stringify(__LINE__);				\
> > +		static const char __simple_format_##name[]		\
> > +		__attribute__((section("__simple_marker")))		\
> > +		__attribute__((__used__))				\
> > +		= #format;						\
> > +		static const char __simple_args_##name[]		\
> > +		__attribute__((section("__simple_marker")))		\
> > +		__attribute__((__used__))				\
> > +		= #args;						\
> 
> All those variables placed in the __simple_marker section are not
> guaranteed to be placed nicely together. There should be a structure
> containing pointers to name, file, line, format and args strings (all
> together) in a special section, and then those strings could be emitted
> in another section. Otherwise, the compiler can freely choose to
> interleave different strings from various tracing statements.

This is just an RFC and a proof of concept.  In practice the whole
section will have to be constructed so that it's versioned (in case more
information has to be added).  Realistically, string optimisation also
needs to be done (since file will be repeated over and over again),
which is also less easy to do.  However, the idea of using strings is
deliberate since they're easier to parse than specific structures which
have to be shared between tools (particularly when the information is
variable length).

James


