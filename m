Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbYGQVro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbYGQVro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYGQVrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:47:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbYGQVre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:47:34 -0400
Date: Thu, 17 Jul 2008 17:46:51 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       joe@perches.com, nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 6/7] dynamic debug v2 - convert cpufreq
Message-ID: <20080717214651.GC13252@redhat.com>
References: <20080715213613.GG23331@redhat.com> <20080715230731.GA15208@isilmar.linta.de> <20080717210531.GA13252@redhat.com> <20080717211531.GA16569@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717211531.GA16569@kroah.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 02:15:31PM -0700, Greg KH wrote:
> On Thu, Jul 17, 2008 at 05:05:32PM -0400, Jason Baron wrote:
> > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > @@ -25,6 +25,7 @@
> >   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   */
> >  
> > +#include <linux/dynamic_debug_cpufreq.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> 
> kernel.h includes dynamic_debug.h right?  

yes

Then why not just put the
> _cpufreq.h stuff in the current cpufreq.h file(s)?
> 

1) cpufreq.h is included by other subsystems, and thus those other subsystems
potentially have the wrong debugging information.

2) For the case where CONFIG_CPU_FREQ_DEBUG is set and 
CONFIG_DYNAMIC_PRINTK_DEBUG is not set i need to be able get the proper
definition of 'dynamic_dbg_enabled()' out of dynamic_print.h (included by
kernel.h). This proper definition is obtained by setting 'DEBUG', and
thus i need to define this before the kernel.h include. 

We can solve #2 by defining an explicit definition for dynamic_dbg_enabled() 
when only CONFIG_CPU_FREQ_DEBUG within cpufreq.h. roughly:

#ifdef CONFIG_CPU_FREQ_DEBUG
#define cpufreq_debug_printk(flag) 
	if (cpufreq_debug & flag)
		 __cpufreq_debug_printk()

However, the way i have it now I don't need two definitions for 
cpufreq_debug_printk....

If we could pull the subsystem specific header in dynamic_printk.h for each 
subsytem that would do the trick and be really clean, but i'm not sure of an
easy way to do that...

-Jason





