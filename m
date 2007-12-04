Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbXLDWRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbXLDWRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXLDWQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:16:54 -0500
Received: from waste.org ([66.93.16.53]:33164 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbXLDWQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:16:54 -0500
Date: Tue, 4 Dec 2007 16:15:25 -0600
From: Matt Mackall <mpm@selenic.com>
To: Mike McGrath <mmcgrath@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204221525.GG19691@waste.org>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com> <20071204165502.0a8f695e@the-village.bc.nu> <20071204180237.GU19691@waste.org> <20071204195021.GB7259@thunk.org> <20071204204036.484f11ac@the-village.bc.nu> <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4755C423.60907@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 03:18:27PM -0600, Mike McGrath wrote:
> Matt Mackall wrote:
> >which would have been in v2.6.22-rc4 through the normal CVE process.
> >The only other bits in there are wall time and utsname, so systems
> >with no CMOS clock would behave repeatably. Can we find out what
> >kernels are affected?
> >
> >  
> We can but it will likely take a few weeks to get a good sampling. UUID 
> is unique in the db so when someone checks in with the same UUID, the 
> old one gets overwritten.

We can probably assume that for whatever reason the two things with
duplicate UUID had the same seed. If not, we've got -much- bigger
problems.

> >>>   931 e2b67e1d-e325-4740-b938-795addb45280
> >>>
> >>>The left number is times this month someone has submitted a profile with
> >>>that UUID.  If we take the last one as an example has come from over 800
> >>>IP's in the last 20 days.  It seems very unlikely that one person would
> >>>find his way to 800 different IP's this month.  Let me know if you'd
> >>>like more.
> >
> >Any other details would be interesting.
> 
> We'll be able to get lots of stuff. Here's a profile of whats currently 
> in e2b67e1d-e325-4740-b938-795addb45280.
> 
> u_u_id: e2b67e1d-e325-4740-b938-795addb45280
> o_s: Fedora release 7.92 (Rawhide)
..
> kernel_version: 2.6.23.1-23.fc8

Hmmm, a kernel where the fingered bug is already fixed.

So what's being used for the seed here? I assume you either ship all
CDs with no seed file or the same seed file, yes? That leaves utsname,
presumably a constant across a large number of machines and time of day.
Still possible, I suppose, that's it's 931 boxes booted with the same
time of day. How many total machines are you tracking?

If it is a time of day weirdness (ie N machines with dead CMOS
batteries or no CMOS clock at all), then you'd expect to see a normal
distribution of collisions around the average time to get to the
initialization function, with a rapid falloff on either side. Or,
looked at from a histogram of collision counts, a round peak rapidly
rolling off.

Other failure modes would tend to give you a much more uniform (and
therefore likely invisible) distribution.

> platform: i686
> bogomips: 3660.33
> system_memory: 2025
> system_swap: 964
> vendor: Sony Corporation
> system: VGN-FE31Z C3LMPJWX
> cpu_vendor: GenuineIntel
> cpu_model: Intel(R) Core(TM)2 CPU T
> num_cp_us: 2
> cpu_speed: 1833
> language: en_US.UT
> default_runlevel: 5

Some bastard snuck a patch in to use ktime_get_real() in the pool init
function, so we should have nanosecond resolution here, but only a) if
TSC actually works and b) if all the clock sources get initialized
before the RNG. Otherwise, we might be using jiffies or worse here.

-- 
Mathematics is the supreme nostalgia of our time.
