Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbXHCEGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbXHCEGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 00:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbXHCEGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 00:06:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43576 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751095AbXHCEGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 00:06:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@sgi.com>
To: vgoyal@in.ibm.com
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Takenori Nagano <t-nagano@ah.jp.nec.com>, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier 
In-reply-to: Your message of "Thu, 02 Aug 2007 16:58:52 +0530."
             <20070802112852.GA7054@in.ibm.com> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 03 Aug 2007 14:05:47 +1000
Message-ID: <31687.1186113947@kao2.melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal (on Thu, 2 Aug 2007 16:58:52 +0530) wrote:
>On Wed, Aug 01, 2007 at 04:00:48AM -0600, Eric W. Biederman wrote:
>> Takenori Nagano <t-nagano@ah.jp.nec.com> writes:
>> 
>> >> No.  The problem with your patch is that it doesn't have a code
>> >> impact.  We need to see who is using this and why.
>> >
>> > My motivation is very simple. I want to use both kdb and kdump, but I think it
>> > is too weak to satisfy kexec guys. Then I brought up the example enterprise
>> > software. But it isn't a lie. I know some drivers which use panic_notifier.
>> > IMHO, they use only major distribution, and they has the workaround or they
>> > don't notice this problem yet. I think they will be in trouble if all
>> > distributions choose only kdump.
>> 
>> Possibly.
>> 
>> > BTW, I use kdb and lkcd now, but I want to use kdb and kdump. I sent a patch to
>> > kdb community but it was rejected. kdb maintainer Keith Owens said,
>> 
>> >> Both KDB and crash_kexec should be using the panic_notifier_chain, with
>> >> KDB having a higher priority than crash_exec.  The whole point of
>> >> notifier chains is to handle cases like this, so we should not be
>> >> adding more code to the panic routine.
>> >>
>> >> The real problem here is the way that the crash_exec code is hard coded
>> >> into various places instead of using notifier chains.  The same issue
>> >> exists in arch/ia64/kernel/mca.c because of bad coding practices from
>> >> kexec.
>> 
>> I respectfully disagree with his opinion, as using notifier chains
>> assumes more of the kernel works.  Although following it's argument
>> to it's logical conclusion we should call crash_kexec as the very
>> first thing inside of panic.  Given how much state something like
>> bust_spinlocks messes up that might not be a bad idea.
>> 
>> It does make adding an alternative debug mechanism in there difficult.
>> Does anyone know if this also affects kgdb?
>> 
>> > Then I gave up to merge my patch to kdb, and I tried to send another patch to
>> > kexec community. I can understand his opinion, but it is very difficult to
>> > modify that kdump is called from panic_notifier. Because it has a reason why
>> > kdump don't use panic_notifier. So, I made this patch.
>> >
>> > Please do something about this problem.
>> 
>> Hmm.  Tricky.  These appear to be two code bases with a completely different
>> philosophy on what errors are being avoided.
>> 
>> The kexec on panic assumption is that the kernel is broken and we better not
>> touch it something horrible has gone wrong.  And this is the reason why
>> kexec on panic is replacing lkcd.  Because the strong assumption results
>> in more errors getting captured with less likely hood of messing up your
>> system.
>> 
>> The kdb assumption appears to be that the kernel is mostly ok, and that there
>> are just some specific thing that is wrong.
>> 
>
>Thinking more about it. So basically there are two kind of users. One who
>believe that despite the kernel has crashed  something meaningful can
>be done. In fact kernel also thinks so. That's why we have created
>panic_notifier_list and even exported it to modules and now we have some
>users. These users most of the time do non-disruptive activities and
>can co-exist.
>
>OTOH, we have kexec on panic, which thinks that once kernel is crashed
>nothing meaningful can be done and it is disruptive and can't co-exist
>with other users.
>
>Some thoughts on possible solutions for this problem.
>
>- Stop exporting panic_notifier_list list to modules. Audit the in kernel
>  users of panic_notifier_list. Let crash_kexec() run once all other users
>  of panic_notifier_list have been executed. This has fall side of breaking
>  down external modules using panic_notifier_list and at the same time
>  there is no gurantee that audited code will not run into the issues.
>
>- Continue with existing policy. If kdump is configured, panic_notifier_list
>  notifications will not be invoked. Any post panic action should be executed
>  in second kernel. There might be 1-2 odd cases like in kernel debugger
>  which still needs to be invoked in first kernel. These users should
>  explicitly put hooks in panic() routine and refrain from using
>  panic_notifier list.
>
>  One thing to keep in mind, doing things in second kernel might not be easy
>  as we have lost all the config data of the first kernel. For example,
>  if one wants to send a kernel crash event over network to a system
>  management software, he might have to pack in lot of software in 
>  second kernel's initrd.
>
>- Let the user decide if he wants to run panic_notifier_list after the
>  crash or not with the help of a /proc option as suggested by the
>  Takenori's patch. Fall side is, on what basis an enterprise user will
>  take a decision whether he wants to run the notifiers or not. My gut
>  feeling is that distro will end up setting this parameter as 1 by default,
>  which would mean first run panic notifiers and then run crash_kexec().
>
>- Make crash_kexec() a user of panic_notifier_list and let it run after all
>  the callback handlers have run. This will invariably reduce the reliability
>  of kdump.  
>
>Personally I believe that second solution should bring us best of both
>the worlds. Making sure post panic actions can be done more reliably at
>the same time making sure reliability of kdump is not compromised.
>
>Keith, do you see a value in second solution and would there be any
>reason why kdb hook can not be explicitly placed in panic(). There will
>not be many users like kdb. Rest of the users should end up performing
>post panic actions in second kernel. 
>
>Solutoin 3, can prove to be a stop gap solution but I think this will
>make situation confusing for customers at the same time everybody will
>try to take short route of performing post panic operations in first kernel.
>
>Thanks
>Vivek

Do not concentrate on kdb alone.  The problem above applies to all the
RAS tools, not just kdb.

My stance is that _all_ the RAS tools (kdb, kgdb, nlkd, netdump, lkcd,
crash, kdump etc.) should be using a common interface that safely puts
the entire system in a stopped state and saves the state of each cpu.
Then each tool can do what it likes, instead of every RAS tool doing
its own thing and they all conflict with each other, which is why this
thread started.

It is not the kernel's job to decide which RAS tool runs first, second
etc., it is the user's decision to set that policy.  Different sites
will want different orders, some will say "go straight to kdump", other
sites will want to invoke a debugger first.  Sites must be able to
define that policy, but we hard code the policy into the kernel.

I proposed and wrote most of this common interface against 2.6.19-rc5.
See http://marc.info/?l=linux-arch&w=2&r=1&s=crash_stop&q=b, look for
crash_stop.  The crash_stop interface stops all the cpus, saves the
system state in a common format then runs an ordered list of RAS tools.

The order that the RAS tools are run depends on the priority value that
each tool passes to register_die_notifier.  Currently each RAS tool
hard codes its priority but it is trivial to change the tools to make
that priority a parameter, passing the policy decision back to the
user, not the kernel.

Despite having written the code and put it up for comments, the only
feedback I got was from Vivek saying "So I think crash dump will be a
little special case".  kdump is a special case whose priority is hard
wired into the kernel, so of course people are going to argue about the
coexistence of kdump with the other RAS tools.  Unless the kdump
developers agree to some flexibility, this thread will not be resolved
to anybody's satisfaction.  Use a common interface with no special
cases and let the user decide which tools to run and in which order.

The main objection raised against crash_stop is that it will not work
if the kernel stack has overflowed.  That problem is also solvable, I
raised an RFC inside SGI that would detect stack overflow and still let
the cpu continue.  Again, no interest.  I will copy that proposal to
the list as a separate thread.

I have pretty well given up on RAS code in the Linux kernel.  Everybody
has different ideas, there is no overall plan and little interest from
Linus in getting RAS tools into the kernel.  We are just thrashing.

