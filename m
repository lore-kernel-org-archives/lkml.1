Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752Ab0A2OX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab0A2OX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711Ab0A2OX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:23:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0A2OXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:23:25 -0500
Date: Fri, 29 Jan 2010 06:22:23 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
Message-ID: <20100129142223.GB12539@suse.de>
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
 <m1eil9v0j9.fsf@fess.ebiederm.org>
 <4B629E7F.5020200@redhat.com>
 <m1zl3xt49k.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zl3xt49k.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 05:44:07AM -0800, Eric W. Biederman wrote:
> Cong Wang <amwang@redhat.com> writes:
> 
> > Eric W. Biederman wrote:
> >> Amerigo Wang <amwang@redhat.com> writes:
> >>
> >>> Recently we met a lockdep warning from sysfs during s2ram or cpu hotplug.
> >>> As reported by several people, it is something like:
> >>>
> >>> [ 6967.926563] ACPI: Preparing to enter system sleep state S3
> >>> [ 6967.956156] Disabling non-boot CPUs ...
> >>> [ 6967.970401]
> >>> [ 6967.970408] =============================================
> >>> [ 6967.970419] [ INFO: possible recursive locking detected ]
> >>> [ 6967.970431] 2.6.33-rc2-git6 #27
> >>> [ 6967.970439] ---------------------------------------------
> >>> [ 6967.970450] pm-suspend/22147 is trying to acquire lock:
> >>> [ 6967.970460]  (s_active){++++.+}, at: [<c10d2941>]
> >>> sysfs_hash_and_remove+0x3d/0x4f
> >>> [ 6967.970493]
> >>> [ 6967.970497] but task is already holding lock:
> >>> [ 6967.970506]  (s_active){++++.+}, at: [<c10d4110>]
> >>> sysfs_get_active_two+0x16/0x36
> >>> [...]
> >>>
> >>> Eric already provides a patch for this[1], but it still can't fix the
> >>> problem. I add the missing part of Eric's patch and send these two patches
> >>> together, hopefully we can fix the warning completely.
> >>>
> >>> 1. http://lkml.org/lkml/2010/1/10/282
> >>>
> >>>
> >>> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >>> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> >>> Reported-by: Miles Lane <miles.lane@gmail.com>
> >>> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> >>> Signed-off-by: WANG Cong <amwang@redhat.com>
> >>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> >>> Cc: Tejun Heo <tj@kernel.org>
> >>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> >>
> >> Thanks for following up on this.
> >>
> >> I suspect we may want to create a separate class for each sysfs file
> >> instead of playing whack-a-mole and creating a subclass each time we
> >> have problems.
> >>
> >> I don't see why the rules for one sysfs file should be the same as for
> >> any other sysfs file.
> >>
> >
> > I am confused, we don't know who created sysfs files unless we
> > separate them by subclasses, the way of your patch is very straight
> > ward.
> 
> The assumption is that all entities in a class are used very similarly.
> What I was suggesting is that it may make sense, and be simpler to have
> a separate __key value and thus place each sysfs file in it's class.
> 
> Doing that is a lot more for lockdep to track, but it would not produce
> the confusing false positives that we see now.  From the reports I have
> seen we may have more that 16 subclasses in sysfs, and it will likely
> take us a while to find them all.

Heh, this whole mess is the very reason we didn't add lockdep support to
the driver core.  Nested devices that all look alike from the driver
core, are really different objects and the locking lifetimes are
separate, but lockdep can't see that.

I suggest we just remove the original patch, as it seems to be causing
way too many problems.

Any objections to that?

thanks,

greg k-h
