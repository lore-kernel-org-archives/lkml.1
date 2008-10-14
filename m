Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbYJNSxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbYJNSxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 14:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYJNSxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 14:53:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52855 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYJNSx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 14:53:29 -0400
Date: Tue, 14 Oct 2008 13:53:20 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs: tagged directories not merged completely yet
Message-ID: <20081014185320.GA24908@us.ibm.com>
References: <20080922153455.GA6238@kroah.com> <48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org> <20081003101331.GH28946@ZenIV.linux.org.uk> <20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org> <20081007222726.GA9465@kroah.com> <48EBF21E.40709@kernel.org> <m1myh8rnf4.fsf@frodo.ebiederm.org> <48F45075.7000003@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F45075.7000003@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> >> Can somebody hammer the big picture regarding namespaces into my
> >> small head?
> > 
> > 100,000 foot view.  A namespace introduces a scope so multiple
> > objects can have the same name.  Like network devices.
> > 
> > 10,000 foot view.  The network namespace looks to user space
> > as if the kernel has multiple independent network stacks.
> > 
> > 1000 foot view.  I have two network devices named lo, and sysfs
> > does not currently have a place for me to put them.
> > 
> > Leakage and being able to fool an application that it has the entire
> > kernel to itself are not concerns.  The goal is simply to get the
> > entire object name to object translation boundary and the namespace
> > work is done.  We have largely achieved, and the code to do
> > so once complete is reasonable enough that it should be no
> > worse than dealing with any other kernel bug.
> 
> Yes, I'm aware of the goals.  What I'm curious about is the consensus
> regarding network namespace and all its implications.  It adds a lot
> of complexities over a lot of places.  e.g. following the sysfs code
> becomes quite a bit more difficult after the namespace changes (maybe
> it's just me but still).  So, I was asking whether people generally
> agree that having the namespace thing is worth the added complexities.
> 
> I think it serves pretty small group of users.  Hosting service

I don't think that's true.

Let's say i want to run debootstrap and set up a minimal image
to run postfix.  Now if I want to run that on my laptop as its own
minimal separate machine, I need to run qemu or kvm.  That's huge.

Once we finally get network namespaces(-sysfs) finished, I can set up a
10-line config file, download and install
https://sourceforge.net/projects/lxc/, run

	lxc-execute -n postfix-cont /bin/bash

and voila, I have postfix running as though on a separate machine,
but with none of the kvm/qemu overhead.  Which means that instead
of being able to do one at a time, i can do... hundreds?  So I
think this is something everyone will find useful - but of course
I *am* biased :)

> providers and people trying to migrate processes from one machine to
> another, both of which can be served pretty well with virtualization.
> It does have higher overhead both processing power and memory wise but
> IIUC the former is being actively worked on w/ new processor features
> like nested paging tables and all and memory is really cheap these
> days, so I'm a bit skeptical how much this is needed and how much we
> should pay for it.
> 
> Another venue to explore is whether the partial view of proc and sysfs
> can be implemented in less pervasive way.  Implementing it via FUSE
> might not be easier per-se but I think it would be better to do it

Again fuse doesn't address the *core* issue (sysfs needing a way to
create files for multiple devicenames with same name).  But I believe
Benjamin was looking into a minimal patch to fix that.  Benjamin,
have you gotten anywhere with that?

> that way if we can instead of adding complexities to both proc and
> sysfs.
> 
> One last thing that came to mind is, how would uevents be handled?
> ie. what happens if a network card which is presented as ethN in the
> namespace goes away?  How does the system deal with it?
> 
> Thanks.
> 
> -- 
> tejun
