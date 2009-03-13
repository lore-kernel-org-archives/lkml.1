Return-Path: <linux-kernel-owner+w=401wt.eu-S1759879AbZCMWRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbZCMWRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZCMWRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:17:30 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:50186 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbZCMWR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:17:29 -0400
Message-ID: <49BADAE5.8070900@cs.columbia.edu>
Date: Fri, 13 Mar 2009 18:15:01 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, hpa@zytor.com, mingo@elte.hu,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
 do?
References: <1234479845.30155.220.camel@nimitz>	<20090226155755.GA1456@x200.localdomain>	<20090310215305.GA2078@x200.localdomain> <49B775B4.1040800@free.fr>	<20090312145311.GC12390@us.ibm.com> <1236891719.32630.14.camel@bahia>	<20090312212124.GA25019@us.ibm.com>	<604427e00903122129y37ad791aq5fe7ef2552415da9@mail.gmail.com>	<20090313053458.GA28833@us.ibm.com>	<alpine.LFD.2.00.0903131018390.3940@localhost.localdomain>	<20090313193500.GA2285@x200.localdomain>	<alpine.LFD.2.00.0903131401070.3940@localhost.localdomain> <1236981097.30142.251.camel@nimitz>
In-Reply-To: <1236981097.30142.251.camel@nimitz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Fri, 2009-03-13 at 14:01 -0700, Linus Torvalds wrote:
>> On Fri, 13 Mar 2009, Alexey Dobriyan wrote:
>>>> Let's face it, we're not going to _ever_ checkpoint any kind of general 
>>>> case process. Just TCP makes that fundamentally impossible in the general 
>>>> case, and there are lots and lots of other cases too (just something as 
>>>> totally _trivial_ as all the files in the filesystem that don't get rolled 
>>>> back).
>>> What do you mean here? Unlinked files?
>> Or modified files, or anything else. "External state" is a pretty damn 
>> wide net. It's not just TCP sequence numbers and another machine.
> 
> This is precisely the reason that we've focused so hard on containers,
> and *didn't* just jump right into checkpoint/restart; we're trying
> really hard to constrain the _truly_ external things that a process can
> interact with.  
> 
> The approach so far has largely been to make things are external to a
> process at least *internal* to a container.  Network, pid, ipc, and uts
> namespaces, for example.  An ipc/sem.c semaphore may be external to a
> process, so we'll just pick the whole namespace up and checkpoint it
> along with the process.
> 
> In the OpenVZ case, they've at least demonstrated that the filesystem
> can be moved largely with rsync.  Unlinked files need some in-kernel TLC
> (or /proc mangling) but it isn't *that* bad.

And in the Zap we have successfully used a log-based filesystem
(specifically NILFS) to continuously snapshot the file-system atomically
with taking a checkpoint, so it can easily branch off past checkpoints,
including the file system.

And unlinked files can be (inefficiently) handled by saving their full
contents with the checkpoint image - it's not a big toll on many apps
(if you exclude Wine and UML...). At least that's a start.

> 
> We can also make the fs problem much easier by using things like dm or
> btrfs snapshotting of the block device, or restricting to where on a fs
> a container is allowed to write with stuff like r/o bind mounts.

(or NILFS)

So we argue that the FS snapshotting is related, but orthogonal in terms
of implementation to c/r.

Oren.

