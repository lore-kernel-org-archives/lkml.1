Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbZCEOIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbZCEOIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZCEOIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:08:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbZCEOIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:08:18 -0500
Date: Thu, 5 Mar 2009 15:08:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: msr architecture debug code
Message-ID: <20090305140809.GA27962@elte.hu>
References: <1236008575.3332.2.camel@localhost.localdomain> <20090302205437.GB14471@elte.hu> <20090305135444.GB7347@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305135444.GB7347@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> On Mon, Mar 02, 2009 at 09:54:37PM +0100, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> Oops, didn't read this mail till the end.
> Thus I missed this part.
> 
> > > +{
> > > +	struct cpuinfo_x86 *cpu = &cpu_data(0);
> > > +
> > > +	if (!cpu_has(cpu, X86_FEATURE_MSR))
> > > +		return -ENODEV;
> > > +
> > > +	msr_dir = debugfs_create_dir("msr", arch_debugfs_dir);
> > > +
> > > +	msr_file = debugfs_create_file("msr", S_IRUGO, msr_dir,
> > > +					NULL, &msr_fops);
> > > +	pmc_file = debugfs_create_file("pmc", S_IRUGO, msr_dir,
> > > +					NULL, &pmc_fops);
> > 
> > I think it would be possible to have a much more intuitive file 
> > layout under /debug/x86/msr/ than these two /debug/x86/msr/msr 
> > and /debug/x86/msr/pmc files.
> > 
> > Firstly, it should move one level deeper, to /debug/x86/cpu/msr/ 
> > - because the MSR is really a property of the CPU, and there are 
> > other properties of the CPU we might want to expose in the 
> > future.
> > 
> > Secondly, the picking of debugfs (as opposed to sysfs) is a good 
> > choice, because we probably want to tweak the layout a number of 
> > times and want to keep flexibility, without being limited by the 
> > sysfs ABI.
> > 
> > So i like the idea - but we really want to do even more and add 
> > more structure to this. If we just want dumb msr enumeration we 
> > already have /dev/msr.
> > 
> > Regarding the msr directory: one good approach would be to have 
> > have several "topic" directories under /debug/x86/cpu/msr/.
> > 
> > One such topic would be the 'pmu', with a structure like:
> > 
> >  /debug/x86/cpu/msr/pmu/
> >  /debug/x86/cpu/msr/pmu/pmc_0/
> >  /debug/x86/cpu/msr/pmu/pmc_0/counter
> >  /debug/x86/cpu/msr/pmu/pmc_0/eventsel
> > 
> > There would also be a /debug/x86/cpu/msr/raw/ directory with all 
> > MSR numbers we know about explicitly, for example:
> > 
> >  /debug/x86/cpu/msr/raw/0x372/value
> >  /debug/x86/cpu/msr/raw/0x372/width
> 
> Having this stuff in the kernel unnecessarily bloats up kernel code.

it should be a default-off Kconfig option and it is in debugfs 
so there's no real bloat issue here.

> What the kernel needs to provide is a reliable interface to 
> access MSRs -- to pass the data to userspace. This interface 
> is already there.
> 
> IMHO all kind of parsing and grouping of that data belongs in 
> user space.
> 
> One exception are MSRs that need to be checked early during 
> boot (e.g. MTRRs). For debugging purposes you might want to 
> dump certain MSRs early. But then you will use printk and not 
> debugfs.

Well it's really nice to know the _kernel's_ enumeration of MSRs 
and its knowledge about the structure of those MSRs.

Sure, we can and do export the flat MSR space to user-space, but 
the kernel also enumerates them internally, in various places. 
The debugfs interface shows them in one way - and as such also 
acts as a central force to keep these things tidy.

a VFS namespace is also pretty educative. You can see which MSRs 
matter to the lapic for example, you can see their symbolic 
names, their current state, etc. etc.

> > Maybe a symlink pointing it back to the topic directory 
> > would be useful as well. For example:
> > 
> >  /debug/x86/cpu/msr/raw/0x372/topic_dir -> /debug/x86/cpu/msr/pmu/pmc_0/
> > 
> > Other "topic directories" are possible too: a 
> > /debug/x86/cpu/msr/apic/ layout would be very useful and 
> > informative as well, and so are some of the other MSRs we 
> > tweak during bootup.
> 
> All nice suggestions but why in-kernel?
> 
> Just hack some script to do this. This is much more 
> maintainable. You don't need a kernel update to add support 
> for new CPUs or to fix bugs in this code itself -- you just 
> have to tweak your script.

the kernel tends to know a lot about these MSRs already so we 
just provide that information in a more structured form as well.

Such more structured form, beyond the debugging and 
education/development advantages, also acts as a counter-force 
back to the MSR enumeration code of the kernel and makes them 
more structured. It will no doubt also extend the kernel's 
knowledge of MSRs - read-only MSRs we dont normally read.

There's also a few other things like the IRR readout in the APIC 
code or the perfcounters status dump can also be done cleanly 
via /debug/x86/cpu/msr/.

Eventually i'd like /debug/x86/ to become a full CPU state dump: 
the kernel pagetable dumping code could go there, we could show 
control registers, we could show the GDT and IDT settings and 
contents, etc. etc.

	Ingo
