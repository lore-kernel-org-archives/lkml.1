Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYJ2K1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYJ2K1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYJ2K07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:26:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:20712 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbYJ2K06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jcKkoau5NE0a1rmvetogJlu+OhFy3lT2gRFJQIMyIbV5RaibEpZO9qRTUJyyYWzwHM
         j5a0eJFN3v/RA10lNn2OQk9S4KGMSdxwzllCpmRL4MS2TKFukx+9ylVIVqPcKvIHezBx
         26SF/z8jj0k34DmOowrw22NnDNVh2rCnRQ1mQ=
Message-ID: <8bd0f97a0810290326t6c980815q9e8089d20a35adb4@mail.gmail.com>
Date: Wed, 29 Oct 2008 06:26:57 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jan Kratochvil" <jan.kratochvil@redhat.com>
Subject: Re: inconsistent behavior with ptrace(TRACEME) and fork/exec
Cc: "Mike Frysinger" <vapier@gentoo.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081028145832.GA9211@host0.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027145648.GA15791@host0.dyn.jankratochvil.net>
	 <8bd0f97a0810271038g4f0b7326r68c7e88841d0e6f9@mail.gmail.com>
	 <20081028145832.GA9211@host0.dyn.jankratochvil.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 10:58, Jan Kratochvil wrote:
> On Mon, 27 Oct 2008 18:38:16 +0100, Mike Frysinger wrote:
>> On Mon, Oct 27, 2008 at 10:56, Jan Kratochvil wrote:
>> > On Wed, 19 Jul 2006 21:18:29 +0200, Mike Frysinger wrote:
>> >> my understanding is that if a parent forks and the child does
>> >> a ptrace(TRACEME) right before doing an exec(), the kernel should always
>> >> halt it and wait indefinitely for the parent to start ptracing it.
>> >
>> > Yes, just the parent must process the event (signal).  In your testcase the
>> > parent finished before the signal could be delivered.  If the tracer exits the
>> > tracee's tracing is finished and it continues freely.
>>
>> no signal should have been generated.  the child should have gone
>> straight to the exec and waited for the parent to process it.
>
> Every ptrace event generates SIGCHLD.  vfork() frees the parent at the moment
> the child calls exec() or _exit().  Here the child calls exec() which both
> frees the parent to continue the execution AND delivers SIGCHLD with the
> status WIFSTOPPED WSTOPSIG(SIGTRAP) to it.  I do not see a problem here.

sorry, the only info ive gathered about the ptrace interface is the
man page, strace, and some of the ptrace code in the kernel ... not
that strace/kernel is really documented at all.  nowhere did i see
mention of the child generating a signal due to ptrace.  but in this
case, it sounds like the initial SIGCHLD with stop info is implied
rather than explicitly mentioned.  every time the child is halted at a
trace point (like syscall entry/exit or signal), the parent is
notified by a SIGCHLD with the stop bit set.  and then it's up to the
parent to interrogate the child's signal info via like
PTRACE_GETSIGINFO.

>> >> unfortunately, this behavior seems to be unreliable.
>> >
>> > Fixed the races in your code and I do not see there any problem, do you?
>> > The ptrace problems/testsuite is being maintained at:
>> >  http://sourceware.org/systemtap/wiki/utrace/tests
>>
>> there is no race condition ... it's using vfork here remember ?
>
> Yes but you said that you see the same problem even with fork():

true, so in that case you are right that there is a race condition.
but lets ignore that to keep things simple.  in the vfork() case, it
is impossible for the parent to execute before the child executes
PTRACE_TRACEME.  if we also ignore the signal() aspect by setting
SIGCHLD to SIG_IGN, then how can the child not get stopped properly ?

> You must not rely on the vfork() specifics as vfork() can be just fork():

i'm testing the Linux interface.  how anyone else handles vfork()
doesnt matter here.  the assumption is that the expected behavior is
respected: the parent is halted until the child calls _exit() or an
exec() function.  this appears to be the case on every Linux port i
know of, and can be checked on my system by inserting a sleep() right
after the vfork() for the child.  the parent never runs until the
child hits exec().

> I hope there is no problem with the kernel at this moment, the attached
> testcase works even with vfork() reliably.

your code goes through a lot of trouble to avoid issues.  i'm pushing
the acceptable limits on purpose.  then again, the acceptable limits
arent terribly well documented.  you're saying that the child exec()
will first release the parent, and then start creating the child
image/etc... before the child is placed into a stopped state ?  and
until that stopped state is reached, any attempt to ptrace() the child
is not allowed ?  in other words, ptrace() only works on a stopped
child, not an actively running one.

that is why the parent can sometimes get:
FAIL:62: ptrace(PTRACE_PEEKUSER, 18762) = -1: No such process
FAIL:38: kernel should have halted me...
even though (1) the child has clearly enabled tracing on itself and
(2) the pid clearly exists ?

which means if a child does something like mask all signals and then execute:
  while (1) ;
a process tracing it will not be able to ptrace() it at all anymore ?

thanks for that utrace URL ... some good info there.  i'm guessing
that there is no real ptrace() documentation (like a spec) and it's
largely an orphaned interface nowadays.
-mike
