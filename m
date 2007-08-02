Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbXHBL26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbXHBL26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXHBL2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:28:49 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51262 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbXHBL2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:28:47 -0400
Date: Thu, 2 Aug 2007 16:58:52 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Takenori Nagano <t-nagano@ah.jp.nec.com>, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Keith Owens <kaos@sgi.com>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070802112852.GA7054@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070726154415.GB15969@in.ibm.com> <20070726154718.GA25561@suse.de> <20070726155444.GC15969@in.ibm.com> <46A92E30.8070703@ah.jp.nec.com> <20070730091624.GB6071@in.ibm.com> <m16442vwgs.fsf@ebiederm.dsl.xmission.com> <46AECEE0.3000307@ah.jp.nec.com> <m1fy35t665.fsf@ebiederm.dsl.xmission.com> <46B051B5.6020207@ah.jp.nec.com> <m18x8vpoa7.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18x8vpoa7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 04:00:48AM -0600, Eric W. Biederman wrote:
> Takenori Nagano <t-nagano@ah.jp.nec.com> writes:
> 
> >> No.  The problem with your patch is that it doesn't have a code
> >> impact.  We need to see who is using this and why.
> >
> > My motivation is very simple. I want to use both kdb and kdump, but I think it
> > is too weak to satisfy kexec guys. Then I brought up the example enterprise
> > software. But it isn't a lie. I know some drivers which use panic_notifier.
> > IMHO, they use only major distribution, and they has the workaround or they
> > don't notice this problem yet. I think they will be in trouble if all
> > distributions choose only kdump.
> 
> Possibly.
> 
> > BTW, I use kdb and lkcd now, but I want to use kdb and kdump. I sent a patch to
> > kdb community but it was rejected. kdb maintainer Keith Owens said,
> 
> >> Both KDB and crash_kexec should be using the panic_notifier_chain, with
> >> KDB having a higher priority than crash_exec.  The whole point of
> >> notifier chains is to handle cases like this, so we should not be
> >> adding more code to the panic routine.
> >>
> >> The real problem here is the way that the crash_exec code is hard coded
> >> into various places instead of using notifier chains.  The same issue
> >> exists in arch/ia64/kernel/mca.c because of bad coding practices from
> >> kexec.
> 
> I respectfully disagree with his opinion, as using notifier chains
> assumes more of the kernel works.  Although following it's argument
> to it's logical conclusion we should call crash_kexec as the very
> first thing inside of panic.  Given how much state something like
> bust_spinlocks messes up that might not be a bad idea.
> 
> It does make adding an alternative debug mechanism in there difficult.
> Does anyone know if this also affects kgdb?
> 
> > Then I gave up to merge my patch to kdb, and I tried to send another patch to
> > kexec community. I can understand his opinion, but it is very difficult to
> > modify that kdump is called from panic_notifier. Because it has a reason why
> > kdump don't use panic_notifier. So, I made this patch.
> >
> > Please do something about this problem.
> 
> Hmm.  Tricky.  These appear to be two code bases with a completely different
> philosophy on what errors are being avoided.
> 
> The kexec on panic assumption is that the kernel is broken and we better not
> touch it something horrible has gone wrong.  And this is the reason why
> kexec on panic is replacing lkcd.  Because the strong assumption results
> in more errors getting captured with less likely hood of messing up your
> system.
> 
> The kdb assumption appears to be that the kernel is mostly ok, and that there
> are just some specific thing that is wrong.
> 

Thinking more about it. So basically there are two kind of users. One who
believe that despite the kernel has crashed  something meaningful can
be done. In fact kernel also thinks so. That's why we have created
panic_notifier_list and even exported it to modules and now we have some
users. These users most of the time do non-disruptive activities and
can co-exist.

OTOH, we have kexec on panic, which thinks that once kernel is crashed
nothing meaningful can be done and it is disruptive and can't co-exist
with other users.

Some thoughts on possible solutions for this problem.

- Stop exporting panic_notifier_list list to modules. Audit the in kernel
  users of panic_notifier_list. Let crash_kexec() run once all other users
  of panic_notifier_list have been executed. This has fall side of breaking
  down external modules using panic_notifier_list and at the same time
  there is no gurantee that audited code will not run into the issues.

- Continue with existing policy. If kdump is configured, panic_notifier_list
  notifications will not be invoked. Any post panic action should be executed
  in second kernel. There might be 1-2 odd cases like in kernel debugger
  which still needs to be invoked in first kernel. These users should
  explicitly put hooks in panic() routine and refrain from using
  panic_notifier list.

  One thing to keep in mind, doing things in second kernel might not be easy
  as we have lost all the config data of the first kernel. For example,
  if one wants to send a kernel crash event over network to a system
  management software, he might have to pack in lot of software in 
  second kernel's initrd.

- Let the user decide if he wants to run panic_notifier_list after the
  crash or not with the help of a /proc option as suggested by the
  Takenori's patch. Fall side is, on what basis an enterprise user will
  take a decision whether he wants to run the notifiers or not. My gut
  feeling is that distro will end up setting this parameter as 1 by default,
  which would mean first run panic notifiers and then run crash_kexec().

- Make crash_kexec() a user of panic_notifier_list and let it run after all
  the callback handlers have run. This will invariably reduce the reliability
  of kdump.  

Personally I believe that second solution should bring us best of both
the worlds. Making sure post panic actions can be done more reliably at
the same time making sure reliability of kdump is not compromised.

Keith, do you see a value in second solution and would there be any
reason why kdb hook can not be explicitly placed in panic(). There will
not be many users like kdb. Rest of the users should end up performing
post panic actions in second kernel. 

Solutoin 3, can prove to be a stop gap solution but I think this will
make situation confusing for customers at the same time everybody will
try to take short route of performing post panic operations in first kernel.

Thanks
Vivek
