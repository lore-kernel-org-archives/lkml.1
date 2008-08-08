Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYHHOtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYHHOtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 10:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYHHOto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 10:49:44 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48524 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752105AbYHHOto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 10:49:44 -0400
Date: Fri, 8 Aug 2008 09:50:00 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Keith Owens <kaos@ocs.com.au>,
       Jay Lan <jlan@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Bernhard Walle <bwalle@suse.de>, Robin Holt <holt@sgi.com>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080808145000.GA19589@sgi.com>
References: <20080807200659.GJ24801@one.firstfloor.org> <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com> <20080808022916.GM24801@one.firstfloor.org> <20080808132953.GB3840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808132953.GB3840@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 09:29:53AM -0400, Vivek Goyal wrote:
> On Fri, Aug 08, 2008 at 04:29:16AM +0200, Andi Kleen wrote:
> > > panic() is the only place where kdump gets a chance to run first and
> > > panic notifiers are not executed.
> > 
> > To be fully clear panic() that is called outside oops/exception context
> > 
> > s/panic/die notifiers/
> > 
> > > 
> > > To me so far only in kernel debugger seems to be a reasonable candiate
> > 
> > Yes a kernel debugger should be able to hook into panic()
> > 
> > In fact it can do that already by just setting a break point,
> > but clearly having a real notifier is preferable.
> > 
> > The use case would be then that the kernel debugger would
> > have some command to trigger a dump.
> > 
> > > which needs to run before kdump after a panic event. If a debugger
> > > is really getting merged into the kernel, then I think debugger can
> > 
> > kgdb is already merged. Also the x86 notifiers are general
> > enough that there are a couple of debuggers floating around
> > that are just using existing interfaces (as in need very little in terms
> > of core patching) 
> > 
> > > put a hook in the panic() before kdump. Wouldn't this solve the problem?
> > 
> > Yes it would, but right now there is no such hook. Also if there 
> > was such a hook kdump could use it like everyone else.  
> > 
> > There's a priority scheme in notifiers so you can still run usually last.
> 
> Hi Andi,
> 
> IIUC, there are two lists for exception and panic notifications. All the
> exceptios, NMI related notifications go through "die_chain" and
> all the panic notifications are done through "panic_notifier_list".
> 
> Are you suggesting that kdump should be put onto panic_notifier_list, in
> such a way so that it runs last?
> 
> Just few points to ponder.
> 
> - panic_notifier_list is exported and any module can register and make use
>   of it. As you mentioned in your other mail, there are lot of drivers out
>   there with crappy code and if we do it, all the drivers get a chance
>   to do stuff after panic() and there is no gurantee that kdump code will
>   ever get a chance to run.
> 
> - Kdump is built on the philosophy that after a panic(), one should do as
>   as little as possible in the kernel and all the actions should be
>   deferred to new kernel. That's why we recommend that all the panic
>   notifier actions (except debugger), should be done in second kernel. It
>   does introduce a little delay in notification but it also makes it more
>   reliable.
> 
> - Neil Horman, has already provided infrastructure so that one can put
>   it user space code in second kernel's initrd and it will be executed. 
>   This can be easily done for modules also. 
> 
> But somehow nobody seems to be interested in doing things in second kernel
> and everybody wants to run its post panic code in the first kernel. So
> far, except debugger, we have not run into any strong case which needs to
> run post panic code in first kernel and things will not work out if post
> panic actions are taken in second kernel.

In the case of the cross-partition driver, running panic notification in the
second kernel is an interesting idea.

I discussed it with Robin Holt, who is more knowledgable than I on the
details of that driver, and he told me that there is a great deal of
state information needed for the notification.  It's easy to do in the
first kernel, but extremely difficult in a second kernel.

Couldn't we have some tunable flexability in that area, to determine
should run on a panic, and in what order?

 
