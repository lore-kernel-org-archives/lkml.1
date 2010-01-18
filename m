Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569Ab0ARUON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab0ARUON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 15:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217Ab0ARUOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 15:14:12 -0500
Received: from mail.windriver.com ([147.11.1.11]:52918 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab0ARUOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 15:14:12 -0500
Message-ID: <4B54C0F1.2090305@windriver.com>
Date: Mon, 18 Jan 2010 14:13:37 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Jan Kiszka <jan.kiszka@web.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Fix 2.6.33 x86 regression to kgdb hw breakpoints - duetoperf
 API changes
References: <4B227F2C.7050403@windriver.com> <20091212132428.GB22389@elte.hu> <20091212135216.GA18597@elte.hu> <4B2404C6.2050003@windriver.com> <20091230163903.GA5024@nowhere> <4B3B8577.6050801@windriver.com> <20091230180122.GA6322@nowhere>
In-Reply-To: <20091230180122.GA6322@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jan 2010 20:13:37.0703 (UTC) FILETIME=[B82F7370:01CA987A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Wed, Dec 30, 2009 at 10:53:11AM -0600, Jason Wessel wrote:
>   
>> Frederic Weisbecker wrote:
>>     
>>> We could probably have a helper that allocates a disabled breakpoint
>>> without reserving it.
>>>       
>> I worked around that restriction for now, in the current version of the
>> kgdb patches.  When kgdb registers with the die notifier in its init
>> phase, it allocates the perf structures via the perf API and
>> subsequently disables the breakpoints with the low level API.
>>     
>
>
>
> It disables it but then the breakpoint still has a reserved slot,
> that looks too much for an opt-in config that may or
> may not be used. One slot among four would be irremediably
> unavailable from userspace once we set CONFIG_KGDB, if I understand well...
> Is it doing so in the beginning of a debugging session or
> at boot time?
>
>
>   
In my latest patch, a single HW breakpoint slot goes away only while
running through the arch specific kgdb init, it is immediately given
back after the kgdb arch init completes.  The arch init either occurs at
boot via kernel cmd line, or is requested via "echo >
/sys/module/kgdboc/...".

Ideally, I would like to get this fixed or at least back to the state of
working where kgdb can make use of HW breakpoints in 2.6.33.

To address your questions.

I used the principle that kgdb can have what ever is "left over" in
terms of available breakpoints that are not presently in use by the perf
code.  In order to configure kgdb there must be at least one HW
breakpoint available or configuration fails.

We assume there is a person running the kernel debugger and has some
knowledge about what all is going on and will make a decision about how
he or she wants to allocate HW breakpoint resources.


>  
>
>>> Is there any possibility that we know the user has started a
>>> kgdb session, and then reserve as much hardware breakpoints
>>> as we can in kgdb at this time?
>>>
>>>   
>>>       
>> That is the way I implemented it the first time.  Reserve all the slots,
>> and then nothing else could use them.  That didn't work out too well
>> because then the user space could not make use of hw breakpoints,
>> granted this never worked before with user space + kernel space sharing
>> between ptrace and kgdb.
>>     
>
>
>
> Say one opens a kgdb session. A very cool thing would be to reserve
> as much breakpoints as we can (without prempting existing ones)
> and release them once the session is closed. This is not a problem that
> userspace can't reserve new ones during this session, we are debugging
> the kernel at this time. I doubt we need userspace breakpoints at the same
> time. Do we?
>
>   

You can end up using user space HW breakpoints if you happen to be
running an application that uses ptrace to set them.  The current kgdb
has never worked with user and system breaks.

> That said I really lack some kgdb background. In which context the
> user is connecting to kgdb? The above would only work in a non-NMI
> context.
>
>   

As I understand it, this is mainly about how the context switching
occurs.  There is some scheduling that sets and unsets the HW
breakpoints which are managed through the perf API.  You can have a perf
system level HW break, a user space HW break (gdb debugging for
instance), or kgdb setting a HW break.  And as the system changes
contexts, the kgdb breaks would in theory get restored by virtue of use
of the low level API.

Do you have a test case for some typical use of perf + a HW breakpoint? 
Perhaps we can narrow down the problem set to the typical cases so as to
move on.

Here is a simple case for instance:
  * User sets perf HW breakpoint to get some data (perhaps you have an
example?)
  * User makes use of KGDB to set HW breakpoint at do_fork()

Simple case 2:
  * User uses a HW breakpoint in a looped app and does a "c 1000000" in gdb
  * User uses KGDB to set a HW breakpoint in do_fork()

I figure you iterate a few times through to see that it is working.   It
is possible to make an in kernel test case as well, but I figure it
would be best to describe some typical, plausible case first.

Thanks,
Jason.

--
The patch is not inlined here but we are talking about:
http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=commitdiff;h=15bc6ce269f1d1f46751236bf5f099e051aa65ee

