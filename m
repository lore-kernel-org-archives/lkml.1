Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbXJ2RVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbXJ2RVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbXJ2RVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:21:46 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:38038 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbXJ2RVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:21:45 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>, clameter@sgi.com,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20071027161955.e9d4d2db.pj@sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	 <20071025185506.8c373aa8.pj@sgi.com>
	 <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	 <1193412644.5032.13.camel@localhost>
	 <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	 <20071026120037.7b95a136.pj@sgi.com>
	 <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	 <1193433239.5032.95.camel@localhost>
	 <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	 <1193434278.5032.106.camel@localhost>
	 <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	 <20071026180713.aeedfac2.pj@sgi.com>
	 <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	 <20071026194144.6042316a.pj@sgi.com>
	 <alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
	 <20071027161955.e9d4d2db.pj@sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 29 Oct 2007 12:54:13 -0400
Message-Id: <1193676854.5035.121.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-27 at 16:19 -0700, Paul Jackson wrote:
> David wrote:
> > I think there's a mixup in the flag name [MPOL_MF_RELATIVE] there
> 
> Most likely.  The discussion involving that flag name was kinda mixed up ;).
> 
> > but I actually would recommend against any flag to effect Choice A.
> > It's simply going to be too complex to describe and is going to be a
> > headache to code and support. 
> 
> While I am sorely tempted to agree entirely with this, I suspect that
> Christoph has a point when he cautions against breaking this kernel API.
> 
> Especially for users of the set/get mempolicy calls coming in via
> libnuma, we have to be very careful not to break the current behaviour,
> whether it is documented API or just an accident of the implementation.
> 
> There is a fairly deep and important stack of software, involving a
> well known DBMS product whose name begins with 'O', sitting on that
> libnuma software stack.  Steering that solution stack is like steering
> a giant oil tanker near shore.  You take it slow and easy, and listen
> closely to the advice of the ancient harbor master.  The harbor masters
> in this case are or were Andi Kleen and Christoph Lameter.
> 
> > It's simply going to be too complex to describe and is going to be a
> > headache to code and support.
> 
> True, which is why I am hoping we can keep this modal flag, if such be,
> from having to be used on every set/get mempolicy call.  The ordinary
> coder of new code using these calls directly should just see Choice B
> behaviour.  However the user of libnuma should continue to see whatever
> API libnuma supports, with no change whatsoever, and various versions of
> libnuma, including those already shipped years ago, must continue to
> behave without any changes in node numbering.

If most apps use libnuma APIs instead of directly calling the sys calls,
libnuma could query something as simple as an environment variable, or a
new flag to get_mempolicy(), or the value of a file in it's current
cpuset--but I'd like to avoid a dependency on libcpuset--to determine
whether to implement "new" semantics.

> 
> There are two decent looking ways (and some ugly ways) that I can see
> to accomplish this:
> 
>  1) One could claim that no important use of Oracle over libnuma over
>     these memory policy calls is happening on a system using cpusets.
>     There would be a fair bit of circumstantial evidence for this
>     claim, but I don't know it for a fact, and would not be the
>     expert to determine this.  On systems making no use of cpusets,
>     these two Choices A and B are identical, and this is a non-issue.
>     Those systems will see no API changes whatsoever from any of this.

I'd certainly like to hear from Oracle what libnuma features they use
and their opinion of the changes being discussed here.

> 
>  2) We have a per-task mode flag selecting whether Choice A or B
>     node numbering apply to the masks passed in to set_mempolicy.
> 
>     The kernel implementation is fairly easy.  (Yeah, I know, I
>     too cringe everytime I read that line ;)
> 
>     If Choice A is active, then we continue to enforce the current
>     check, in mm/mempolicy.c: contextualize_policy(), that the passed
>     in mask be a subset of the current cpusets allowed memory nodes,
>     and we add a call to nodes_remap(), to map the passed in nodemask
>     from cpuset centric to system centric (if they asked for the
>     fourth node in their current cpuset, they get the fourth node in
>     the entire system.)
> 
>     Similarly, for masks passed back by get_mempolicy, if Choice A
>     is active, we use nodes_remap() to convert the mask from system
>     centric back to cpuset centric.
> 
>     There is a subtle change in the kernel API's here:
> 
> 	In current kernels, which are Choice A, if a task is moved from
> 	a big cpuset (many nodes) to a small cpuset and then -back-
> 	to a big cpuset, the nodemasks returned by get_mempolicy
> 	will still show the smaller masks (fewer set nodes) imposed
> 	by the smaller cpuset.
> 
> 	In todays kernels, once scrunched or folded down, the masks
> 	don't recover their original size after the task is moved
> 	back to a large cpuset.

Yeah.  This bothered me about policy remapping when I looked at it a
while back.  Worse, this behavior isn't documented as intended [or not].
I thought at the time that this could be solved by retaining the
original argument nodemask, but 1) I was worried about the size when ~1K
nodes are required to be supported and 2) it still doesn't solve the
problem of ensuring the same locality characteristics w/o a lot of
documentation about the implications of changing cpuset resources or
moving tasks between cpusets in such a way to preserve the locality
characteristics requested by the original mask.

Again, we stumble upon the notion of "intent".  If the intent is just to
spread allocations to share bandwidth, it probably doesn't matter.  If,
on the other hand, the original mask was carefully constructed, taking
into consideration the distances between the memories specified and
other resources [cpus in the cpuset, other memories in the cpuset, IO
adpater connection points, ...], there is a lot more to consider than
just preserving the cpuset relative positions of the nodes.

> 
> 	With this change, even a task asking for Choice A would,
> 	once back on a larger cpuset, again see the larger masks from
> 	get_mempolicy queries.  This is a change in the kernel API's
> 	visible to user space; but I really do not think that there
> 	is sufficient use of Oracle over libnuma on systems actively
> 	moving tasks between differing size cpusets for this to be
> 	a problem.
> 
> 	Indeed, if there was much such usage, I suspect they'd
> 	be complaining that the current kernel API was borked, and
> 	they'd be filing a request for enhancement -asking- for just
> 	this subtle change in the kernel API's here.  In other words,
> 	this subtle API change is a feature, not a bug ;)

Agreed. 

> 
>     The bulk of the kernel's mempolicy code is coded for Choice B.
> 
>     If Choice B is active, we don't enforce the subset check in
>     contextualize_policy(), and we don't invoke nodes_remap() in either
>     of the set or get mempolicy code paths.
> 
>     A new option to get_mempolicy() would query the current state of
>     this mode flag, and a new option to set_mempolicy() would set
>     and clear this mode flag.  Perhaps Christoph had this in mind
>     when he wrote in an earlier message "The alternative is to add
>     new set/get mempolicy functions."
> 
>     The default kernel API for each task would be Choice B (!).
> 
>     However, in deference to the needs of libnuma, if the following
>     call was made, this would change the mode for that task to
>     Choice A:
> 
> 	get_mempolicy(NULL, NULL, 0, 0, 0);
> 
>     This last detail above is an admitted hack.  *So far as I know*
>     it happens that all current infield versions of libnuma issue the
>     above call, as their first mempolicy query, to detemine whether
>     the active kernel supports mempolicy.

In libnuma in numactl-1.0.2 that I recently grabbed off Andi's site,
numa_available() indeed issues this call.  But, I don't see any internal
calls to numa_available() [comments says all other calls undefined when
numa_available() returns an error] nor any other calls to
get_mempolicy() with all null/0 args.  So, you'd be depending on the
application to call numa_available().  However, you could define an
additional MPOL_F_* flag to get_mempolicy() that is issued in library
init code to enable new behavior--again, based on some indication that
new behavior is desired or not.

> 
>     The mode for each task would be inherited across fork, and reset
>     to Choice (B) on exec.
> 
> If we determine that we must go with a new flag bit to be passed in
> on each and every get and set mempolicy call that wants Choice B node
> numbering rather than Choice A, then I will need (1) a bottle of rum,
> and (2) a credible plan in place to phase out this abomination ;).
> 
> There would be just way too many coding errors and coder frustrations
> introduced by requiring such a flag on each and every mempolicy system
> call that wants the alternative numbering.  

Only for apps that use the sys calls directly, right?  This can be
hidden by libnuma(), if all apps use that.  The "behavior switch" flag
suggested above would obviate a flag on each sys call and could also be
hidden by libnuma.  Any of these changes will require some better
documentation than we have now...

> There must be some
> international treaty that prohibits landmines capable of blowing ones
> foot off that would apply here.
> 
> There are two major user level libraries sitting on top of this API,
> libnuma and libcpuset.  Libnuma is well known; it was written by Andi
> Kleen.  I wrote libcpuset, and while it is LGPL licensed, it has not
> been publicized very well yet.  I can speak for libcpuset: it could
> adapt to the above proposal, in particular to the details in way (2),
> just fine.  Old versions of libcpuset running on new kernels will
> have a little bit of subtle breakage, but not in areas that I expect
> will cause much grief.  Someone more familiar with libnuma than I would
> have to examine the above proposal in way (2) to be sure that we weren't
> throwing libnuma some curveball that was unnecessarily troublesome.
> 

I worry more about applications that take a more physical view of the
node ids and that emphasize locality more than bandwidth spreading.  If
libnuma explicitly enables new behavior when requested, however that
might be implemented, I don't know that it would be a problem.

Lee

Lee

