Return-Path: <linux-kernel-owner+w=401wt.eu-S1760616AbXIOFW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbXIOFW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 01:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbXIOFWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 01:22:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:18155 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbXIOFWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 01:22:19 -0400
Date: Fri, 14 Sep 2007 22:21:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
Message-Id: <20070914222127.6980b94a.randy.dunlap@oracle.com>
In-Reply-To: <20070914220517.2fe3a253.randy.dunlap@oracle.com>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
	<alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
	<20070914220517.2fe3a253.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 22:05:17 -0700 Randy Dunlap wrote:

> On Fri, 14 Sep 2007 21:28:12 -0700 (PDT) Linus Torvalds wrote:
> 
> > On Wed, 12 Sep 2007, Randy Dunlap wrote:
> > >
> > > I run almost-daily kernel testing.  I haven't seen 'crashme' cause a
> > > kernel fault until today, and now I've seen it twice on 2.6.23-rc6-git2,
> > > x86_64.  After the first fault, I ran 'crashme' about 10 more times
> > > to get the second fault (usually for 10 minutes, one time for 30
> > > minutes).
> > 
> > Interesting. If this is reproducible for you, can you try to narrow down 
> > (with bit-bisect) roughly when it started.
> 
> It doesn't happen quite on demand.  Only 2 times in several hours
> of testing of the last few days.
> 
> > > There is very little helpful info.  RIP is strange, e.g.: 000000000051b446
> > > The call stack is not printed.  No kernel symbols are printed,
> > > even though I have CONFIG_KALLSYMS{_ALL}=y.
> > 
> > It looks like it's a page fault as a result of a *user*space* access, and 
> > most likely your machine would continue happily, except you have 
> > "panic_on_oops" set, so when the oops happens, it shuts the system down.
> 
> I see.
> 
> > Now, the reason I say it looks like a user space access is that you have
> > 
> > 	RIP: 0033:[<0000000000510eea>]
> > 	RSP: 002b:00007fffc9a8ec10
> > 
> > which are all user space segments. So the register contents clearly say 
> > "page fault in user space".
> > 
> > However, what makes the kernel oops (rather than just send a SIGSEGV) is 
> > that the page fault "error code" is zero (that's the number that is 
> > printed out just after the "Oops" string). For a normal user space access, 
> > you should have bit #2 set in the error code.
> > 
> > So the kernel thinks it's a kernel page fault, because the page fault 
> > error code says so. But everything else seems to indicate that it's really 
> > user mode.. It would be very interesting to hear when this started 
> > happening.
> > 
> > Even if you cannot bisect it down all the way, since you say that you do 
> > almost daily kernel testing, is this really new to 2.6.23-rc6-git2, and 
> > 2.6.23-rc6-git1 was fine? 
> 
> I'll check back thru my test logs.

I looked thru several hundred test logs and didn't find any other
occurrences of it.  Doesn't prove much.
I'll continue to run the test most of this weekend.


> > Andi, anything comes to mind?
> > 
> > 			Linus
> > 
> > ---
> > > [ 7487.208128] Unable to handle kernel paging request at 00000000ff019b53 RIP:
> > > [ 7487.212752]  [<0000000000510eea>]
> > > [ 7487.218537] PGD 10c1a2067 PUD 0
> > > [ 7487.221811] Oops: 0000 [1] SMP
> > > [ 7487.224989] CPU 2
> > > [ 7487.227024] Modules linked in: loop
> > > [ 7487.230550] Pid: 19139, comm: crashme Not tainted 2.6.23-rc6-git2 #1
> > > [ 7487.236896] RIP: 0033:[<0000000000510eea>]  [<0000000000510eea>]
> > > [ 7487.242925] RSP: 002b:00007fffc9a8ec10  EFLAGS: 00010e83
> > > [ 7487.248234] RAX: 00000000ffff8c4a RBX: 00000000004014f1 RCX: 00002b20e11c8b37
> > > [ 7487.255361] RDX: 0000000000510ee0 RSI: 0000000000000000 RDI: 000000000000000a
> > > [ 7487.262489] RBP: 00007fffc9a8ec10 R08: 00007fffc9a8eb60 R09: 0000000000000000
> > > [ 7487.269616] R10: 0000000000000008 R11: 0000000000000612 R12: 0000000000000000
> > > [ 7487.276743] R13: 00007fffc9a8ee00 R14: 0000000000000000 R15: 0000000000000000
> > > [ 7487.283871] FS:  00002b20e13676d0(0000) GS:ffff81011fc75840(0000) knlGS:0000000000000000
> > > [ 7487.291952] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > [ 7487.297693] CR2: 00000000ff019b53 CR3: 000000005be6b000 CR4: 00000000000006e0
> > > [ 7487.304821] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > [ 7487.311949] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > [ 7487.319076] Process crashme (pid: 19139, threadinfo ffff810106830000, task ffff810102cf5040)
> > > [ 7487.327511]
> > > [ 7487.329009] RIP  [<0000000000510eea>]
> > > [ 7487.332690]  RSP <00007fffc9a8ec10>
> > > [ 7487.336180] CR2: 00000000ff019b53
> > > [ 7487.339810] Kernel panic - not syncing: Fatal exception
> > -
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
