Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYIQTN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYIQTN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYIQTNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:13:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbYIQTNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:13:17 -0400
Date: Wed, 17 Sep 2008 14:46:18 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v6
Message-ID: <20080917184618.GB6486@redhat.com>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <20080917015543.27172da4.akpm@linux-foundation.org> <20080917092732.GB32107@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917092732.GB32107@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 11:27:32AM +0200, Ingo Molnar wrote:
> (Jason Cc:-ed)
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 17 Sep 2008 01:27:41 -0700 Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > 
> > >     KERN_PCI
> > >     KERN_ACPI
> > > v4: fix some checkpatch error and warning
> > > v5: add default with DEFINE_LOGLEVE_SETUP_DEF
> > >     KERN_APIC
> > > v6: set the default only one time
> > > 
> > > usage:
> > > 	in .h to have
> > > 		#define KERN_PCI "<pci>"
> > > 	in .c to have
> > > 		DEFINE_LOGLEVEL_SETUP(pci, KERN_PCI, "pci:");
> > > 	then could use
> > > 		printk(KERN_DEBUG KERN_PCI fmt, ...);
> > > 	and command line
> > > 		loglevel=3,pci:8
> > > 
> > > you can add different printk to different files of one subsys if you like
> > > not just one susbsys one tag, and don't need to update kernel.h to add more tags
> > 
> > This all looks dreadfully similar to Jason Baron's "dynamic debug v2".
> 
> yeah, but s/dreadfully/luckily
> 
> > Similar enough that we couldn't justify merging both.
> 
> agreed.
> 
> Here's the summary as i see it: Jason's "dynamic debug" mainly relies on 
> automatically creating a section of tags associated with each pr_debug() 
> callsite. The unit of filtering is the .c file - which lends itself well 
> to things like individual drivers but is not quite good for more generic 
> entities like full subsystems.
> 
> I think a better model is what hpa suggested: add string tags at the 
> call site and make it all a sub-case of printk, via ASCII space tags. 
> OTOH, a pr_debug() variant could be offered that just inserts a __FILE__ 
> tag into the output - this would enable most of the "dynamic debug" 
> functionality that Jason's patch series implements IMO.
> 
> There's also a wider robustness argument why this is better: we want to 
> keep printk simple by default, hence doing these things via the ASCII 
> space is good design. "dynamic debug" does it all programmatically via 
> extra sections, etc., which is eventually a source of bugs and 
> unrobustness.
> 
> 	Ingo


hi,

indeed both proposals seem to be addressing a similar core issue - being
able to dynamically (as opposed to re-compiling) change the amount of
verbosity that the kernel spews. I would liken it to adding a -verbose
flag to the kernel.

Beyond that the 2 approaches differ in a number of ways as I see:

1)

Filtering Unit. 'Boot printk', or Yinghai's approach explicitly defines
filtering units via tags. 'dynamic debug' is implicitly based
around "KBUILD_MODNAME", not .c files, which seems to be a good unit for
most parts of the kernel. For full subsystems, it is not appropriate.
There, i have introduced the conecpt, of 'logical modname', which is very
roughly similar to the 'boot printk' tag concept. Basically, subsystems
could be grouped together using this 'logical modname'.

2)

kernel impact. Part of the design of 'dynamic debug' was to be very low
impact. in fact, when its disabled, we basically jump around the printk
with a test and a jump. So, there is only a 2 instruction overhead per
call-site. I believe (and please correct me if i'm wrong) that 'boot
printk' is filtering after printk has been called...So you have at least
the overhead of a fucntion call plus the overhead of the printk()
function.

3)

usefullness beyond just doing 'printk'. The basic building block of
dynamic debug is simply: 'dynamic_debug_enabled()'. So blocks of code are built
up as:

if (dynamic_debug_enabled()) {
        do debugging work
}

printk is then simply:

if (dynamic_debug_enabled()) {
        printk();
}

or:

define pr_debug()
        (dynamic_debug_enabled()) {
                printk();
        }

The intent here was to dynamically be able to turn 'printk' or other
debugging code dynamically off and on.


4)

ability to compile out the code. 'dynamic debug' has 3 modes of
compilation. If 'DEBUG' is set then then dynamic_debug_enabled() simply
is defined to 1. If 'DYNAMIC_DEBUG' is set dynamic_debug_enabled()
becomes the test and jump i desscribe in #2. If neither 'DEBUG' is set
nor 'DYNAMIC_DEBUG' then the code is compiled out (no impact). So to
enable 'dynamic debug' for the entire kernel, 'DYNAMIC_DEBUG' is
defined for all compilation units. Additionally subsystems, can define
there own: CONFIG_SUBSYSTEM_DEBUG, and CONFIG_SUBSYSTEM_DEBUG_DYNAMIC,
which sets either 'DEBUG' or 'DYNAMIC_DEBUG' for their particular
subsystem. I believe this approach provides a good level of flexibility.

5)

debug filtering. In my survey of subsystems, not only were levels used,
but also 'flags' ie a set of debug flags can be set for a particular
subsystem. In 'dynamic debug' this is implemented in
dynamic_debug_enabled() before printk is called. In 'boot printk' this
is implemented in printk() itself. 'dynamic printk' defines 3 types of
filtering: TYPE_BOOLEAN , TYPE_LEVEL, and TYPE_FLAG. Seems like 'boot
printk' at least at the moment has type level.

6)

compatibility with existing code. In 'dynamic debug' I tried to reduce
code churn as much as possible. Thus, pr_debug() and dev_dbg() calls
don't need to be changed at all. Further, subsystem specfic printing,
for example, subsystem_dprintk(), can be implemented in 'dynamic debug'
by simply just changing the definition of ubsystem_dprintk(). The callers
do not need to be modified.

7) 'robustness'. Dynamic debug does add extra kernel sections. But if
they are designed carefully I don't think they are very risky. Further,
'boot printk' also defines extra sections. So unless i'm missing
something i don't see how that makes 'boot printk' more or less robust.

thanks,

-Jason



