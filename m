Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbYFKIYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbYFKIYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 04:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYFKIYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 04:24:25 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:56838 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbYFKIYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 04:24:22 -0400
Date: Wed, 11 Jun 2008 11:23:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] always enable FW_LOADER unless EMBEDDED=y
Message-ID: <20080611082320.GM11685@cs181133002.pp.htv.fi>
References: <20080610160408.GB11685@cs181133002.pp.htv.fi> <20080610162450.GB13538@kroah.com> <20080610181206.GF11685@cs181133002.pp.htv.fi> <20080610212859.GB26249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080610212859.GB26249@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 02:28:59PM -0700, Greg KH wrote:
> On Tue, Jun 10, 2008 at 09:12:06PM +0300, Adrian Bunk wrote:
> > On Tue, Jun 10, 2008 at 09:24:50AM -0700, Greg KH wrote:
> > > On Tue, Jun 10, 2008 at 07:04:08PM +0300, Adrian Bunk wrote:
> > > > James Bottomley recently discovered that we have 
> > > > {request,release}_firmware() dummies for the case of the actual 
> > > > functions not being available and has a fix for the bug that was 
> > > > actually causing build errors for built-in users with 
> > > > CONFIG_FW_LOADER=m.
> > > > 
> > > > But now missing selects on FW_LOADER are no longer visible at 
> > > > compile-time at all and can become runtime problems.
> > > > 
> > > > FW_LOADER is infrastructure with relatively small codesize we can 
> > > > safely enable for everyone, and only for people who really need small 
> > > > kernels (and can be expected to know what they are doing) it matters 
> > > > being able to disable it.
> > > > 
> > > > This patch therefore always sets FW_LOADER=y and allows users only to 
> > > > disable it with EMBEDDED=y.
> > > > 
> > > > As a bonus, we can then get rid of all "select FW_LOADER" plus the due 
> > > > to it required "depends on HOTPLUG" which removes some complexity from 
> > > > our Kconfig files.
> > > 
> > > Well, we can't get rid of that if EMBEDDED is set, right?
> > 
> > No, if EMBEDDED is set and HOTPLUG is not set you will not be able to
> > enable FW_LOADER (the "depends on HOTPLUG" for FW_LOADER has to stay, 
> > but all the options that currently select FW_LOADER no longer need the 
> > dependency).
> 
> Ok, but what about the point that the options that are wanting FW_LOADER
> in that situation?  I know EMBEDDED is tough to get right as you can
> shoot yourself in the foot very easily, but this seems like we are going
> to make it even harder to use properly.

Currently missing selects can result in a build error.

After James' patch to fix the dummy functions (that should have worked 
from day 1) it will instead become a runtime problem.

And when the select gets added the dependency on HOTPLUG often gets 
forgotten.

If you worry about "EMBEDDED is tough to get right" a bigger problem 
would be the linux-tiny patches to add new config options - each might 
save a few kB when disabled but also offers a new way to shoot yourself 
into the foot.

I do care more about:
- that users for the common CONFIG_EMBEDDED=n case don't run into 
  unexpected problems (due to a missing select on FW_LOADER) and
- that we remove complexity from our kconfig dependencies so that
  they break less often.

I'm counting 6 commits that fix bugs in this area introduced since
2.6.25 (sic) under drivers/media/ alone.

And Davids firmware patches offer even more opportunities for people to 
forget the dependency on HOTPLUG (which will break only in the 
CONFIG_EMBEDDED=y case...). [1]

> > > You sent this as an RFC before, I thought people said to just fix up all
> > > of the dependancies with drivers that needed FW_LOADER to be enabled,
> > > that would be easier, right?
> > 
> > As far as I know there were zero answers to my RFC.
> > 
> > What are you referring to?
> 
> Sorry, I thought that was sent to the RFC, I think it was to a thread
> even before that.
>...

If it was in the "build issue #503 ..." thread it was even me who
said it - before I had the idea of hiding FW_LOADER behind EMBEDDED.

> thanks,
> 
> greg k-h

cu
Adrian

[1] and before anyone restarts the "kconfig is broken - select should 
    follow dependencies" FUD: I've seen much talk and zero code for
    this, and in my opinion the problem is much more difficult than
    it appears at first sight

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

