Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZCENzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZCENzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZCENzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:55:08 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:7420 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZCENzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:55:06 -0500
X-BigFish: VPS-36(zz1432R14e0Q98dR1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KG1DB7-02-G8Y-01
Date: Thu, 5 Mar 2009 14:54:44 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: msr architecture debug code
Message-ID: <20090305135444.GB7347@alberich.amd.com>
References: <1236008575.3332.2.camel@localhost.localdomain> <20090302205437.GB14471@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090302205437.GB14471@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Mar 2009 13:54:46.0679 (UTC) FILETIME=[F1AA3270:01C99D99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 09:54:37PM +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

Oops, didn't read this mail till the end.
Thus I missed this part.

> > +{
> > +	struct cpuinfo_x86 *cpu = &cpu_data(0);
> > +
> > +	if (!cpu_has(cpu, X86_FEATURE_MSR))
> > +		return -ENODEV;
> > +
> > +	msr_dir = debugfs_create_dir("msr", arch_debugfs_dir);
> > +
> > +	msr_file = debugfs_create_file("msr", S_IRUGO, msr_dir,
> > +					NULL, &msr_fops);
> > +	pmc_file = debugfs_create_file("pmc", S_IRUGO, msr_dir,
> > +					NULL, &pmc_fops);
> 
> I think it would be possible to have a much more intuitive file 
> layout under /debug/x86/msr/ than these two /debug/x86/msr/msr 
> and /debug/x86/msr/pmc files.
> 
> Firstly, it should move one level deeper, to /debug/x86/cpu/msr/ 
> - because the MSR is really a property of the CPU, and there are 
> other properties of the CPU we might want to expose in the 
> future.
> 
> Secondly, the picking of debugfs (as opposed to sysfs) is a good 
> choice, because we probably want to tweak the layout a number of 
> times and want to keep flexibility, without being limited by the 
> sysfs ABI.
> 
> So i like the idea - but we really want to do even more and add 
> more structure to this. If we just want dumb msr enumeration we 
> already have /dev/msr.
> 
> Regarding the msr directory: one good approach would be to have 
> have several "topic" directories under /debug/x86/cpu/msr/.
> 
> One such topic would be the 'pmu', with a structure like:
> 
>  /debug/x86/cpu/msr/pmu/
>  /debug/x86/cpu/msr/pmu/pmc_0/
>  /debug/x86/cpu/msr/pmu/pmc_0/counter
>  /debug/x86/cpu/msr/pmu/pmc_0/eventsel
> 
> There would also be a /debug/x86/cpu/msr/raw/ directory with all 
> MSR numbers we know about explicitly, for example:
> 
>  /debug/x86/cpu/msr/raw/0x372/value
>  /debug/x86/cpu/msr/raw/0x372/width

Having this stuff in the kernel unnecessarily bloats up kernel code.
What the kernel needs to provide is a reliable interface to access
MSRs -- to pass the data to userspace. This interface is already there.

IMHO all kind of parsing and grouping of that data belongs in user
space.

One exception are MSRs that need to be checked early during boot
(e.g. MTRRs). For debugging purposes you might want to dump certain
MSRs early. But then you will use printk and not debugfs.

> Maybe a symlink pointing it back to the topic directory would be 
> useful as well. For example:
> 
>  /debug/x86/cpu/msr/raw/0x372/topic_dir -> /debug/x86/cpu/msr/pmu/pmc_0/
> 
> Other "topic directories" are possible too: a 
> /debug/x86/cpu/msr/apic/ layout would be very useful and 
> informative as well, and so are some of the other MSRs we tweak 
> during bootup.

All nice suggestions but why in-kernel?

Just hack some script to do this. This is much more maintainable.
You don't need a kernel update to add support for new CPUs or to fix
bugs in this code itself -- you just have to tweak your script.


Regards,
Andreas


