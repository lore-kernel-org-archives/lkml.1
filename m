Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbYHEUER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbYHEUER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758888AbYHEUEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:04:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703AbYHEUEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:04:00 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080805005132.GA3661@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com>
	 <1217896374.27684.53.camel@localhost.localdomain>
	 <20080805005132.GA3661@kroah.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 15:46:03 -0400
Message-Id: <1217965563.27684.159.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 17:51 -0700, Greg KH wrote:
> On Mon, Aug 04, 2008 at 08:32:54PM -0400, Eric Paris wrote:

> Oh, and after that, not using a binary interface, have we not learned
> from the ioctl mess?  I sure thought we had...

I don't see a reason why we can't use strings and key=value pairs for
any metadata being sent back and forth.  That seem more reasonable?



> > > Heh, so if you want to write a "virus" for Linux, just implement this
> > > flag.  What's to keep a "rogue" program from telling the kernel that all
> > > programs on the system are to be excluded?
> > 
> > Processes can only get this flag one of 2 ways.
> > 
> > 1) register as a client to make access decisions
> 
> How do you do that?

open the magic "vetting" file RW and you are a client who can answer
access decisions.

> > 2) echo 1 into the magic file to enable the flag for themselves
> 
> Simple enough :)
> 
> > > > 10. Filesystem exclusions
> > > > -------------------------
> > > > One pretty important optimization is not to scan things like /proc, /sys
> > > > or similar. Basically all filesystems where user can not store
> > > > arbitrary, potentially malicious, content could and should be excluded
> > > > from scanning.
> > > 
> > > Why, does scanning these files take extra time?  Just curious.
> > 
> > Perf win, why bothering looking for malware in /proc when it can't
> > exist?  It doesn't take longer it just takes time having to do
> > 
> > userspace -> kernel -> userspace -> kernel -> userspace
> > 
> > just to cat /proc/mounts, all of this could probably be alliviated if we
> > cached access on non block backed files but then we have to come up with
> > a way to exclude only nfs/cifs.  I'd rather list the FSs that don't need
> > scanning every time than those that do....
> 
> How long does this whole process take?  Seriously is it worth the added
> kernel code for something that is not measurable?

Is it worth having 2 context switches for every open when none are
needed?  I plan to get numbers on that.

> 
> > > > 11. Path exclusions
> > > > -------------------
> > > > The need for exclusions can be demonstrated with an example of a MySQL
> > > > server. It's data files are frequently modified which means they would
> > > > need to be constantly rescanned which is very bad for performance. Also,
> > > > it is most often not even possible to reasonably scan them. Therefore
> > > > the best solution is not to scan its database store which can simply be
> > > > implemented by excluding the store subdirectory.
> > > > 
> > > > It is a relatively simple implementation which allows run-time
> > > > configuration of a list of sub directories or files to exclude.
> > > > Exclusion paths are relative to each process root. So for example if we
> > > > want to exclude /var/lib/mysql/ and we have a mysql running in a chroot
> > > > where from the outside that directory actually lives
> > > > in /chroot/mysql/var/lib/mysql, /var/lib/mysql should actually be added
> > > > to the exclusion list.
> > > > 
> > > > This is also not included in the initial patch set but will be coming
> > > > shortly after.
> > > 
> > > Again, what's to keep all files to be marked as excluded?
> > 
> > You have to be root and I'll probably add an LSM hook?
> 
> Why an LSM hook?  You aren't an LSM.

Maybe a new hook, maybe just a capability call, something to make root
not the 

> > > > Closing remarks
> > > > ---------------
> > > > Although some may argue some of the filters are not necessary or may
> > > > better be implemented in userspace, we think it is better to have them
> > > > in kernel primarily for performance reasons.
> > > 
> > > Why?  What numbers do you have that say the kernel is faster in
> > > implementing this?  This is the first mention of such a requirement, we
> > > need to see real data to back it up please.
> > 
> > In kernel caching is clearly a huge perf win.
> 
> Why?  If the cache is also in userspace, it should be the same, right?

In kernel cache has 0 context switches for every open.  Userspace
caching has 2.  Every open has to block, switch to the context of the
userspace client/cache, get that decisions, and then switch back to the
original process.

