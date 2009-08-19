Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZHSVCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZHSVCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZHSVCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:02:52 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:12101 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbZHSVCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:02:52 -0400
Date: Wed, 19 Aug 2009 15:02:51 -0600
From: Alex Chiang <achiang@hp.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
Message-ID: <20090819210251.GD13061@ldl.fc.hp.com>
References: <20090814163618.GQ7185@ldl.fc.hp.com> <1250276831.3077.17.camel@sbs-t61.sc.intel.com> <20090814192730.GA6431@ldl.fc.hp.com> <1250279799.3077.41.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250279799.3077.41.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh,

Thanks for having the patience to educate me. I appreciate the
effort. :)

A few more questions...

* Suresh Siddha <suresh.b.siddha@intel.com>:
> On Fri, 2009-08-14 at 12:27 -0700, Alex Chiang wrote:
> > Hm, I'm not entirely sure about that, for two reasons.
> > 
> > First (and this is the weaker reason), I'd prefer not to keep
> > adding new fields to /proc/cpuinfo if we can help it, as it just
> > makes for a continually more complicated ABI/API for userspace.
> 
> Overriding same field with different values based on the system will be
> confusing. On some systems it will be derived from cpuid, some will be
> based on physical slots. This is too confusing.
> 
> > Second, I guess I'm not sure what else 'physical id' /should/
> > represent. I'm willing to be corrected on this point, so if I'm
> > wrong, just call it simple ignorance. :)
> 
> As far as possible we kept these fields closer to what the cpuid
> instruction says, so that firmware won't mess up the topology detection
> etc by having wrong values in the bios tables.

I understand your point about keeping the output of /proc/cpuinfo
close to what the cpuid instruction says.

But in regard to the particular field that we're talking about
here -- 'physical id' -- that doesn't seem to be represented from
cpuid anyway. We're stuffing an APIC ID into that field, even
when we already have other APIC ID output.

So my point was that we're already kinda doing something funny to
'physical id' and I'd like to fix it for my platform so that it
matches the actual chassis.

> > My quick grep earlier led me to believe that as long as the
> > phys_proc_ids were /consistent/ then it didn't seem to matter
> > what their /values/ were.
> 
> This is correct. But there are several assumptions in the patch that
> might break in the future and where ever possible we simply don't want
> to depend on what bios says and rather depend on what the cpu/hardware
> says.
> 
> For example, we shouldn't assume that original phys proc id's calculated
> from cpuid etc need not be contiguous and start from 0 etc. This is
> platform dependent and may vary from one version to another version of
> processor etc.

Sorry, I'm having a hard time parsing this sentence. Do you mean
to say:

	we shouldn't assume that phys_proc_id calculated from
	cpuid are contiguous and start from 0

?

I agree with you (although I thought that they should be 0-based)
but this quirk addresses a specific platform, where I can assume
certain things about the BIOS, etc.

> Also, you are selecting the fixup table based on number of present cpu
> etc. I am just nervous that how this all workout across cpu generations
> having different cores, sparsely populated sockets in the platform etc.
> We just can't afford to go and fix all the old kernels if we have any
> problem in the future config setups.
 
I agree with you in general, but again, this is a specific
platform quirk where I have a good idea of what is a supported
configuration.

I take your point though, and can rework the patch so that if we
don't find a configuration that we're expecting (either 4p or 8p)
then just revert to the default behaviour and don't break
anything.

> Easiest route will be to add a new entry in /proc/cpuinfo

Well, if you remain unconvinced that fixing up 'physical id' is
the proper thing to do, here are some alternate proposals:

	/proc/cpuinfo/chassis id
	/sys/devices/system/cpu/$cpu/chassis id
	/sys/devices/system/cpu/$cpu/topology/chassis id

Thoughts?

Thanks.

/ac

