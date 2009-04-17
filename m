Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZDQFgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZDQFgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZDQFg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:36:26 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:36926 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZDQFgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:36:25 -0400
Date: Fri, 17 Apr 2009 11:05:17 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [PATCH 01/10] Documentation
Message-ID: <20090417053517.GC26437@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-2-git-send-email-vgoyal@redhat.com> <20090312001146.74591b9d.akpm@linux-foundation.org> <20090312180126.GI10919@redhat.com> <49D8CB17.7040501@gmail.com> <20090407064046.GB20498@redhat.com> <20090408203756.GB10077@linux> <20090416183753.GE8896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416183753.GE8896@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 02:37:53PM -0400, Vivek Goyal wrote:
> On Wed, Apr 08, 2009 at 10:37:59PM +0200, Andrea Righi wrote:
> 
> [..]
> > > 
> > > - I can think of atleast one usage of uppper limit controller where we
> > >   might have spare IO resources still we don't want to give it to a
> > >   cgroup because customer has not paid for that kind of service level. In
> > >   those cases we need to implement uppper limit also.
> > > 
> > >   May be prportional weight and max bw controller can co-exist depending
> > >   on what user's requirements are.
> > >  
> > >   If yes, then can't this control be done at the same layer/level where
> > >   proportional weight control is being done? IOW, this set of patches is
> > >   trying to do prportional weight control at IO scheduler level. I think
> > >   we should be able to store another max rate as another feature in 
> > >   cgroup (apart from weight) and not dispatch requests from the queue if
> > >   we have exceeded the max BW as specified by the user?
> > 
> > The more I think about a "perfect" solution (at least for my
> > requirements), the more I'm convinced that we need both functionalities.
> > 

hard limits vs work conserving argument again :). I agree, we need
both of the functionalities. I think first the aim should be to get the
proportional weight functionality and then look at doing hard limits.

[..]

> > > 
> > > - Have you thought of doing hierarchical control? 
> > > 
> > 
> > Providing hiearchies in cgroups is in general expensive, deeper
> > hierarchies imply checking all the way up to the root cgroup, so I think
> > we need to be very careful and be aware of the trade-offs before
> > providing such feature. For this particular case (IO controller)
> > wouldn't it be simpler and more efficient to just ignore hierarchies in
> > the kernel and opportunely handle them in userspace? for absolute
> > limiting rules this isn't difficult at all, just imagine a config file
> > and a script or a deamon that dynamically create the opportune cgroups
> > and configure them accordingly to what is defined in the configuration
> > file.
> > 
> > I think we can simply define hierarchical dependencies in the
> > configuration file, translate them in absolute values and use the
> > absolute values to configure the cgroups' properties.
> > 
> > For example, we can just check that the BW allocated for a particular
> > parent cgroup is not greater than the total BW allocated for the
> > children. And for each child just use the min(parent_BW, BW) or equally
> > divide the parent's BW among the children, etc.
> 
> IIUC, you are saying that allow hiearchy in user space and then flatten it
> out and pass it to kernel?
> 
> Hmm.., agree that handling hierarchies is hard and expensive. But at the
> same time rest of the controllers like cpu and memory are handling it in
> kernel so it probably makes sense to keep the IO controller also in line.
> 
> In practice I am not expecting deep hiearchices. May be 2- 3 levels would
> be good for most of the people.
> 

FWIW, even in the CPU controller having deep hierarchies is not a good idea.
I think this can be documented for IO Controller as well. Beyond that,
we realized that having a proportional system and doing it in userspace
is not a good idea. It would require a lot of calculations dependending
on the system load. (Because, the sub-group should be just the same as a
process in the parent group). Having hierarchy in the kernel just makes it way
more easier and way more accurate.

> > 
> > > - What happens to the notion of CFQ task classes and task priority. Looks
> > >   like max bw rule supercede everything. There is no way that an RT task
> > >   get unlimited amount of disk BW even if it wants to? (There is no notion
> > >   of RT cgroup etc)
> > 
> > What about moving all the RT tasks in a separate cgroup with unlimited
> > BW?
> 
> Hmm.., I think that should work. I have yet to look at your patches in
> detail but it looks like unlimited BW group will not be throttled at all
> hence RT tasks can just go right through without getting impacted.
> 

This is where the cpu scheduler design helped a lot :). Having different
classes for differnet types of processes allowed us to handle them
separately.

thanks,
-- 
regards,
Dhaval
