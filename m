Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077Ab0AZPgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0AZPgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636Ab0AZPgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:36:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:32924 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab0AZPgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:36:51 -0500
Date: Tue, 26 Jan 2010 16:36:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
	mce_cpu_specific_poll
Message-ID: <20100126153646.GA6567@basil.fritz.box>
References: <20100121221711.GA8242@basil.fritz.box> <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu> <20100123075851.GA7098@liondog.tnic> <20100123090003.GA20056@elte.hu> <20100124100815.GA2895@liondog.tnic> <20100125131915.GA7801@basil.fritz.box> <20100126063343.GA18865@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126063343.GA18865@liondog.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 07:33:43AM +0100, Borislav Petkov wrote:
> Uuh, dmidecode doesn't even start to look usable in my book because you
> have to rely on BIOS vendors to fill out the information for you. Here
> are some assorted excerpts from dmidecode on my machines:

For most of the information in DMI decode you can't even
find it any other way. If you can't get it from the BIOS
it's simply not there.

One example are silkscreen labels, which are extremly important
for any kind of hardware error handling.

On my server class systems the information is largely correct. If it's not
on your system perhaps you need to complain to the vendor.

On non server class there are a lot of BIOS problems, but typically
the platforms there don't have enough support for good error
handling anyways.

> how is my L3 4-way set-associative and how do they come up with that???

Cache/CPU information is in lscpu. The important part are the motherboard
resources.

> on any system. And this tool should be distributed with the kernel
> sources like perf is, so that you don't have to jump through hoops to

Most distributions have some kind of summary tool to aggregate
complete system configuration.

It's not the same everywhere, but that's one of the strengths
of Linux imho, not a weakness.

> Oh yes, EDAC has the edac-utils too which access /sysfs files but even
> so, it is suboptimal and we really need a single interface/output
> channel/whatever you call a beast like that to reliably transfer human
> readable hw error info to userspace and/or network. And this has to be
> pushed from kernel space outwards as early as the gravity of the error
> suggests, IMO.

You just reinvented mcelog, congratulations.

> valid reasons to panic the machine. Imagine, for example, you encounter
> (as unlikely as it might be) a multibit error during L1 data cache
> scrubbing which hasn't been consumed yet. Now, technically, no data
> corruption has taken place yet so you can easily start the shell on

When no data corruption has been taken it's not a UC error.

An UC error in this case is defined as something that the hardware
tells us is a UC error, worse even a uncontained UC error

The reason the hardware tells us about that is that it wants us to prevent 
further damage. And the primary way to do that is to NOT write anything 
to disk, because that would risk corrupting it.

For contained memory UC errors I wrote all the infrastructure last year to 
handle them. Making hwpoison better is still an ongoing 
project, but it's already quite usable.

> And even if an UC causes data corruption, panicking the system doesn't
> mean that the error has been contained. Nothing can assure you that by
> the time do_machine_check() has run the corrupted data hasn't left the
> CPU core and landed in another core's cache (maybe even on a different

That is why the panic stops all cpus to prevent that.

But yes if the disk write happens at exactly the wrong point the error
could still escape, but we try to keep the window as small as possible.
Typically there's also some hardware help with that to catch currently
in flight transactions. It depends on the platform how well it works.

> Yes, I'm very well aware of that. I'm currently working on a solution.
> It's just an idea now but I might be able to read DIMM configuration
> on the SPD ROM on the DIMM along with their labels and position on the

The SPD ROM doesn't have labels. The only entity who knows them
is the BIOS (or someone who just studied the semantics of the motherboard,
but I don't think we can rely on that)

> 1. Resilient error reporting that reliably pushes decoded error info to
> userspace and/or network. That one might be tricky to do but we'll get
> there.

Not at all tricky.  At least on modern Intel platforms mcelog 
already does it.

> 
> 2. Error severity grading and acting upon each type accordingly. This
> might need to be vendor-specific.


mcelog does it mostly. It's not perfect yet, but not too bad.


> 3. Proper error format suiting all types of errors.

I plan to look into that.

But "suiting all types of errors" is probably a mistake,
I don't think it makes sense to try to  invent the one 
perfect error that covers everything. People have tried
that in the past and it was always a spectacular failure.

I suspect the better goal is rather a range of error formats
for common situations with a lot of flexibility.


> 5. Error thresholding, representation, etc all done in userspace (maybe
> even on a different machine).

mcelog does that for memory errors on modern systems.

> 6. Last but not least, and maybe this is wishful thinking, a good tool
> to dump hwinfo from the kernel. We do a great job of detecting that info
> already - we should do something with it, at least report it...

IMHO there are already enough of them.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
