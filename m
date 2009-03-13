Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbZCMVvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbZCMVvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbZCMVvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:51:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53742 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZCMVvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:51:44 -0400
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Ying Han <yinghan@google.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, mingo@elte.hu, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, xemul@openvz.org,
       tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.00.0903131401070.3940@localhost.localdomain>
References: <1234479845.30155.220.camel@nimitz>
	 <20090226155755.GA1456@x200.localdomain>
	 <20090310215305.GA2078@x200.localdomain> <49B775B4.1040800@free.fr>
	 <20090312145311.GC12390@us.ibm.com> <1236891719.32630.14.camel@bahia>
	 <20090312212124.GA25019@us.ibm.com>
	 <604427e00903122129y37ad791aq5fe7ef2552415da9@mail.gmail.com>
	 <20090313053458.GA28833@us.ibm.com>
	 <alpine.LFD.2.00.0903131018390.3940@localhost.localdomain>
	 <20090313193500.GA2285@x200.localdomain>
	 <alpine.LFD.2.00.0903131401070.3940@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 14:51:37 -0700
Message-Id: <1236981097.30142.251.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 14:01 -0700, Linus Torvalds wrote:
> On Fri, 13 Mar 2009, Alexey Dobriyan wrote:
> > > Let's face it, we're not going to _ever_ checkpoint any kind of general 
> > > case process. Just TCP makes that fundamentally impossible in the general 
> > > case, and there are lots and lots of other cases too (just something as 
> > > totally _trivial_ as all the files in the filesystem that don't get rolled 
> > > back).
> > 
> > What do you mean here? Unlinked files?
> 
> Or modified files, or anything else. "External state" is a pretty damn 
> wide net. It's not just TCP sequence numbers and another machine.

This is precisely the reason that we've focused so hard on containers,
and *didn't* just jump right into checkpoint/restart; we're trying
really hard to constrain the _truly_ external things that a process can
interact with.  

The approach so far has largely been to make things are external to a
process at least *internal* to a container.  Network, pid, ipc, and uts
namespaces, for example.  An ipc/sem.c semaphore may be external to a
process, so we'll just pick the whole namespace up and checkpoint it
along with the process.

In the OpenVZ case, they've at least demonstrated that the filesystem
can be moved largely with rsync.  Unlinked files need some in-kernel TLC
(or /proc mangling) but it isn't *that* bad.

We can also make the fs problem much easier by using things like dm or
btrfs snapshotting of the block device, or restricting to where on a fs
a container is allowed to write with stuff like r/o bind mounts.

-- Dave

