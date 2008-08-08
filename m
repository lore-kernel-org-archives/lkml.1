Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYHHNan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYHHNan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 09:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYHHNaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 09:30:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbYHHNaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 09:30:35 -0400
Date: Fri, 8 Aug 2008 09:29:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Keith Owens <kaos@ocs.com.au>, Jay Lan <jlan@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080808132953.GB3840@redhat.com>
References: <20080807200659.GJ24801@one.firstfloor.org> <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com> <20080808022916.GM24801@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808022916.GM24801@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 04:29:16AM +0200, Andi Kleen wrote:
> > panic() is the only place where kdump gets a chance to run first and
> > panic notifiers are not executed.
> 
> To be fully clear panic() that is called outside oops/exception context
> 
> s/panic/die notifiers/
> 
> > 
> > To me so far only in kernel debugger seems to be a reasonable candiate
> 
> Yes a kernel debugger should be able to hook into panic()
> 
> In fact it can do that already by just setting a break point,
> but clearly having a real notifier is preferable.
> 
> The use case would be then that the kernel debugger would
> have some command to trigger a dump.
> 
> > which needs to run before kdump after a panic event. If a debugger
> > is really getting merged into the kernel, then I think debugger can
> 
> kgdb is already merged. Also the x86 notifiers are general
> enough that there are a couple of debuggers floating around
> that are just using existing interfaces (as in need very little in terms
> of core patching) 
> 
> > put a hook in the panic() before kdump. Wouldn't this solve the problem?
> 
> Yes it would, but right now there is no such hook. Also if there 
> was such a hook kdump could use it like everyone else.  
> 
> There's a priority scheme in notifiers so you can still run usually last.

Hi Andi,

IIUC, there are two lists for exception and panic notifications. All the
exceptios, NMI related notifications go through "die_chain" and
all the panic notifications are done through "panic_notifier_list".

Are you suggesting that kdump should be put onto panic_notifier_list, in
such a way so that it runs last?

Just few points to ponder.

- panic_notifier_list is exported and any module can register and make use
  of it. As you mentioned in your other mail, there are lot of drivers out
  there with crappy code and if we do it, all the drivers get a chance
  to do stuff after panic() and there is no gurantee that kdump code will
  ever get a chance to run.

- Kdump is built on the philosophy that after a panic(), one should do as
  as little as possible in the kernel and all the actions should be
  deferred to new kernel. That's why we recommend that all the panic
  notifier actions (except debugger), should be done in second kernel. It
  does introduce a little delay in notification but it also makes it more
  reliable.

- Neil Horman, has already provided infrastructure so that one can put
  it user space code in second kernel's initrd and it will be executed. 
  This can be easily done for modules also. 

But somehow nobody seems to be interested in doing things in second kernel
and everybody wants to run its post panic code in the first kernel. So
far, except debugger, we have not run into any strong case which needs to
run post panic code in first kernel and things will not work out if post
panic actions are taken in second kernel.

That's why there is always resistance from our side to move kdump to panic
notifier list so that we can make modules do the right thing and that
is, run in second kernel. The moment kdump is put onto panic_notifier_list,
nobody will think of doing anything in second kernel (because it takes extra
effort). Everybody will register a panic notifier handler in first kernel
and be happy..

If everybody thinks that they can do something meaningful in a crashed
kernel after panic() and that's the way to go, then so be it. In that
case we should export all the panic_notifier_list registered users to 
userspace (throug /sysfs or something) and then let user change the 
priority of various tools on the list based on his needs.

Adding all the infrastructure for changing priority of handlers from user
space becomes little messy and Eric had NAKed such patches. But it at least
allows a user to decide in what order he wants to run the various tools upon
panic().

But given an option, I would think that debugger should put a break point
in panic() and rest of the handlers should run in second kernel.

Thanks
Vivek
