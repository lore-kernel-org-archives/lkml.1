Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYA3HtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYA3HtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYA3Hsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:48:53 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57273 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYA3Hsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:48:52 -0500
Date: Wed, 30 Jan 2008 08:48:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Yi Yang <yi.y.yang@intel.com>
Cc: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
Message-ID: <20080130074852.GA19534@uranus.ravnborg.org>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com> <1201043126.3861.5.camel@yangyi-dev.bj.intel.com> <1201562058.12722.9.camel@yangyi-dev.bj.intel.com> <20080129084435.GA8962@uranus.ravnborg.org> <1201645363.12722.38.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201645363.12722.38.camel@yangyi-dev.bj.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 06:22:43AM +0800, Yi Yang wrote:
> On Tue, 2008-01-29 at 09:44 +0100, Sam Ravnborg wrote:
> > > +
> > > +static struct notifier_block __cpuinitdata cpuid_sysfs_cpu_notifier = {
> > > +	.notifier_call = cpuid_sysfs_cpu_callback,
> > > +};
> > Data is annotated _cpuintidata
> > 
> > but
> > 
> > > +
> > Data is annotated _cpuintidata
> > 
> > > @@ -217,11 +445,14 @@ static void __exit cpuid_exit(void)
> > >  {
> > >  	int cpu = 0;
> > >  
> > > -	for_each_online_cpu(cpu)
> > > +	for_each_online_cpu(cpu) {
> > >  		cpuid_device_destroy(cpu);
> > > +		remove_cpuid_sysfs(cpu);
> > > +	}
> > >  	class_destroy(cpuid_class);
> > >  	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
> > >  	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
> > > +	unregister_hotcpu_notifier(&cpuid_sysfs_cpu_notifier);
> > 
> > used in an __exit function.
> > 
> > You should have seen a Section mismatch warning for this.
> > The right fix is to annotate the cpuid_sysfs_cpu_notifier
> > with __initdata_refok (soon to be named __refdata)
> > Or even better to declare it const and use _refconst.
> I think __cpuinitdata is different from __initdata, i have tested it
> by insmod, rmmod, echo 0/1 > /sys/devices/system/cpu/cpu1/online
> repeatly, it hasn't any issue.

__cpuinit & _cpuinitdata have over time been used for 
different purposes:
a) To annotate code/data used in the init path and that in the
non HOTPLUG_CPU case can be discarded after init.
b) To annotate code/data used in the 'core' HOTPLUG_CPU
functionality that isonly in use if HOTPLUG_CPU='y'


The b) usage is questionable and the annotation
of cpuid_sysfs_cpu_notifier beongs in the b) category.

The correct solution would be to factor out the 'core'
HOTPLUG_CPU=y code to a set of separate files and used to
usual mechanishm in the Makefile to select when to include
this code in the kernel.

The improved section mismatch checks by modpost has just
brought this issue to the attention and now you add code
that does the wrong thing it is being discussed.

	Sam
