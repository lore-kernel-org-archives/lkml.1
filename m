Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbZCMT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbZCMT2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 15:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZCMT2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 15:28:00 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:64741 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZCMT17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 15:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YFGzAQZ2cbFjjUl0c9iKEVF9KKjjS3zM+VOZzDLsLKbtBJ3W4Oh/BXOc2HYZzE+lOq
         gq1Teiinf4ewRS85QvoYTsB4Jy7xbwOBusmoBebomyV2abwlLKE5qntgeYtDpE40RcG8
         g8npp70romTWT4r0NJ7B3dNZNPQijql7UFCmQ=
Date: Fri, 13 Mar 2009 22:35:00 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Ying Han <yinghan@google.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, mingo@elte.hu, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, xemul@openvz.org,
       tglx@linutronix.de
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Message-ID: <20090313193500.GA2285@x200.localdomain>
References: <1234479845.30155.220.camel@nimitz> <20090226155755.GA1456@x200.localdomain> <20090310215305.GA2078@x200.localdomain> <49B775B4.1040800@free.fr> <20090312145311.GC12390@us.ibm.com> <1236891719.32630.14.camel@bahia> <20090312212124.GA25019@us.ibm.com> <604427e00903122129y37ad791aq5fe7ef2552415da9@mail.gmail.com> <20090313053458.GA28833@us.ibm.com> <alpine.LFD.2.00.0903131018390.3940@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903131018390.3940@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 10:27:54AM -0700, Linus Torvalds wrote:
> On Thu, 12 Mar 2009, Sukadev Bhattiprolu wrote:
> 
> > Ying Han [yinghan@google.com] wrote:
> > | Hi Serge:
> > | I made a patch based on Oren's tree recently which implement a new
> > | syscall clone_with_pid. I tested with checkpoint/restart process tree
> > | and it works as expected.
> > 
> > Yes, I think we had a version of clone() with pid a while ago.
> 
> Are people _at_all_ thinking about security?
> 
> Obviously not.

For the record, OpenVZ always have CAP_SYS_ADMIN check on restore.
And CAP_SYS_ADMIN will be in version to be sent out.

Not having it is one big security hole.

> There's no way we can do anything like this. Sure, it's trivial to do 
> inside the kernel. But it also sounds like a _wonderful_ attack vector 
> against badly written user-land software that sends signals and has small 
> races.
> 
> Quite frankly, from having followed the discussion(s) over the last few 
> weeks about checkpoint/restart in various forms, my reaction to just about 
> _all_ of this is that people pushing this are pretty damn borderline. 
> 
> I think you guys are working on all the wrong problems. 
> 
> Let's face it, we're not going to _ever_ checkpoint any kind of general 
> case process. Just TCP makes that fundamentally impossible in the general 
> case, and there are lots and lots of other cases too (just something as 
> totally _trivial_ as all the files in the filesystem that don't get rolled 
> back).

What do you mean here? Unlinked files?

> So unless people start realizing that
>  (a) processes that want to be checkpointed had better be ready and aware 
>      of it, and help out

This is not going to happen. Userspace authors won't do anything
(nor they shouldn't).

>  (b) there's no way in hell that we're going to add these kinds of 
>      interfaces that have dubious upsides (just teach the damn program 
>      you're checkpointing that pids will change, and admit to everybody 
>      that people who want to be checkpointed need to do work) and are 
>      potential security holes.

I personally don't understand why on earth clone_with_pid() is again
with us.

As if pids are somehow unique among other resources.

It was discussed when IPC objects creation with specific parameters were
discussed.

"struct pid" and "struct pid_namespace" can be trivially restored
without leaking to userspace.

People probably assume that task should be restored with clone(2) which
is unnatural given relations between task_struct, nsproxy and individual
struct foo_namespace's

>  (c) if you are going to play any deeper games, you need to have 
>      privileges. IOW, "clone_with_pid()" is ok for _root_, but not for 
>      some random user. And you'd better keep that in mind EVERY SINGLE 
>      STEP OF THE WAY.
> 
> I'm really fed up with these discussions. I have seen almost _zero_ 
> critical thinking at all. Probably because anybody who is in the least 
> doubtful about it simply has tuned out the discussion. So here's my input: 
> start small, start over, and start thinking about other issues than just 
> checkpointing.
