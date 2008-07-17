Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbYGQWfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbYGQWfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760239AbYGQWfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:35:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:56374 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094AbYGQWfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:35:45 -0400
Date: Thu, 17 Jul 2008 15:32:22 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080717223222.GA28016@kroah.com>
References: <20080715213108.GB23331@redhat.com> <20080717070103.GA21961@kroah.com> <20080717212040.GB13252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717212040.GB13252@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 05:20:40PM -0400, Jason Baron wrote:
> On Thu, Jul 17, 2008 at 12:01:03AM -0700, Greg KH wrote:
> > Return-Path: <greg@kroah.com>
> > On Tue, Jul 15, 2008 at 05:31:08PM -0400, Jason Baron wrote:
> > > diff --git a/include/linux/device.h b/include/linux/device.h
> > > index 1a06026..fb03dbc 100644
> > > --- a/include/linux/device.h
> > > +++ b/include/linux/device.h
> > > @@ -592,7 +592,11 @@ extern const char *dev_driver_string(struct device *dev);
> > >  #define dev_info(dev, format, arg...)		\
> > >  	dev_printk(KERN_INFO , dev , format , ## arg)
> > >  
> > > -#ifdef DEBUG
> > > +#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
> > > +#define dev_dbg(dev, format, ...) do { \
> > > +	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
> > > +	} while (0)
> > > +#elif defined(DEBUG)
> > >  #define dev_dbg(dev, format, arg...)		\
> > >  	dev_printk(KERN_DEBUG , dev , format , ## arg)
> > >  #else
> > 
> > In looking at your follow-on patches, where you add this to subsystems,
> > it seems that you have to add a lot of #include <linux/dynamic_printk.h>
> > lines.
> > 
> > And in looking at this modification to device.h, I think lots of the
> > kernel should break, but you are getting it "for free" by including the
> > .h file within kernel.h.
> > 
> > Why not also include it here in device.h?
> > 
> 
> I don't believe the follow-on patches include "<linux/dynamic_printk.h>". 
> However, some of them do include a subsystem specific #include. For example,
> the cpufreq subsystem include, <linux/dynamic_debug_cpufreq.h>:

Ah, you are correct, sorry about that, I misread.

> +++ b/include/linux/dynamic_debug_cpufreq.h
> @@ -0,0 +1,8 @@
> +#define DYNAMIC_DEBUG_NUM_FLAGS "3"
> +#define DYNAMIC_DEBUG_FLAG_NAMES "CPUFREQ_DEBUG_CORE,CPUFREQ_DEBUG_DRIVER,CPUFREQ_DEBUG_GOVERNOR"
> +#define DYNAMIC_DEBUG_TYPE "2"
> +#define DYNAMIC_DEBUG_MODNAME "cpufreq_shared"
> +
> +#ifdef CONFIG_CPU_FREQ_DEBUG
> +#define DEBUG 1
> +#endif
> 
> This header file conveys that cpufreq subsystem, wants non-default options-it
> has 3 debugging flags that can be set, and all modules in the subsystem are
> tied together using the module name: "cpufreq_shared".  
> 
> I don't have an explicit #include of kernel.h in device.h b/c it already picked
> up.
> 
> > Also, with this change, code that is already using dev_dbg() today is
> > instantly converted over to this logic now, right?
> > 
> 
> that is correct. any callers of dev_dbg() don't have to do anything. its really
> only the more complex debugging, where there are flags or levels that need to
> make adjustments to work with the new infrastructure.

For this reason alone, I see no reason why your patch should not be
merged today.  You don't need the other subsystems at this point in time
in my opinion, it's benifit is huge already.

Not to say that you shouldn't also go after these subsystems in your
overall scheme here, but please, don't feel it should hold your code up
at this point in time :)

Because of that, do you want me to try to merge the basic infrastructure
and dev_dbg() support through the driver-core tree?  This code has been
in the past -mm and linux-next releases, right?

thanks,

greg k-h
