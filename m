Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXFGITF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXFGITF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXFGISs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:18:48 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:59369 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbXFGISr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:18:47 -0400
Date: Thu, 7 Jun 2007 01:18:32 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/22] 2.6.22-rc3 perfmon2 : generic kernel modifications
Message-ID: <20070607081832.GD14081@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmG1Y019632@frankl.hpl.hp.com> <alpine.DEB.0.99.0706040810500.11881@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706040810500.11881@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Mon, Jun 04, 2007 at 08:13:41AM -0700, David Rientjes wrote:
> On Tue, 29 May 2007, Stephane Eranian wrote:
> 
> > Only in linux-2.6.22/Documentation: perfmon2.txt
> 
> You need to send -N to diff(1) so this and perfmon.h, perfmon_dfl_smpl.h, 
> perfmon_fmt.h, and perfmon_pmu.h will be included in the patch.  A 
> patchset should compile and work correctly at any time when each patch is 
> applied consecutively.  Providing perfmon.h, for example, in patch 13 
> doesn't allow individual testing of all prior patches.
> 
The 'patch set' I publish on LKML is artificially created from the perfmon
patch tarball. As such, it does not have the property yuo are talking about here.
There is no independence of each patch. They are all more or less nedeed to get
the kernel to compile.

> > +++ linux-2.6.22/drivers/oprofile/oprofile_files.c	2007-05-29 03:24:14.000000000 -0700
> > +
> > +static ssize_t implementation(struct file * file, char __user * buf, size_t count, loff_t * offset)
> > +{
> > +	return oprofilefs_str_to_user(oprofile_ops.implementation, buf, count, offset);
> > +}
> > +
> > +
> > +static struct file_operations implementation_fops = {
> > +	.read		= implementation,
> > +};
> > +
> >  void oprofile_create_files(struct super_block * sb, struct dentry * root)
> >  {
> >  	oprofilefs_create_file(sb, root, "enable", &enable_fops);
> > @@ -127,6 +137,7 @@ void oprofile_create_files(struct super_
> >  	oprofilefs_create_ulong(sb, root, "buffer_watershed", &fs_buffer_watershed);
> >  	oprofilefs_create_ulong(sb, root, "cpu_buffer_size", &fs_cpu_buffer_size);
> >  	oprofilefs_create_file(sb, root, "cpu_type", &cpu_type_fops); 
> > +	oprofilefs_create_file(sb, root, "implementation", &implementation_fops);
> >  	oprofilefs_create_file(sb, root, "backtrace_depth", &depth_fops);
> >  	oprofilefs_create_file(sb, root, "pointer_size", &pointer_size_fops);
> >  	oprofile_create_stats_files(sb, root);
> 
> The commentary for how to interpret this new file is lacking; it appears 
> as though it will return "timer", "oprofile", or "nmi_timer" for existing 
> i386 subsystems and "perfmon2" with this addition.  This should be 
> documented.
> 
> It isn't set generically in oprofile_arch_init() for other architectures.

This modification of oprofile was one to allow the user level oprofile daemon
to determine which kernel "implementation" of oprofile it is running on. This
way tool could transparently run on existing Oprofile and also on systems
with both perfmon and Oprofile.

Andi suggested that during a transition period, we let Oprofile and perfmon
co-exist as opposed to moving Oprofile on top of perfmon right away. I think this
is a good suggestion. As a consequence, I will remove this Oprofile extension.

> > diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/kernel/sched.c linux-2.6.22/kernel/sched.c
> > --- linux-2.6.22.base/kernel/sched.c	2007-05-29 03:17:57.000000000 -0700
> > +++ linux-2.6.22/kernel/sched.c	2007-05-29 03:24:14.000000000 -0700
> > @@ -53,6 +53,7 @@
> >  #include <linux/kprobes.h>
> >  #include <linux/delayacct.h>
> >  #include <linux/reciprocal_div.h>
> > +#include <linux/perfmon.h>
> 
> perfmon.h isn't included in this patch so the inclusion of it here is a 
> mystery but I suspect it's for pfm_ctxsw() later.
> 
Yes most likely.

thanks for your feedback.

-- 

-Stephane
