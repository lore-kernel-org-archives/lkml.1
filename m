Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZBCTvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZBCTvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZBCTvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:51:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:51191 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZBCTvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:51:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YDt5uOh35fypHzwzD5x/ryAVO3t6+7qUaYv+R3/PIw0pbyWa29E/ZmUeSV2r9d30rg
         ARxvtsGII4qJGsMhJuiF316k0GPIs8YkaSvZ3nMPzaWFa0gNcpgwLH9xvrBnSuZ9lMKU
         wLerLbR5yklcu7VbDlFFOjr+0eZPnseVu0ElY=
MIME-Version: 1.0
In-Reply-To: <20090203133313.GA5679@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com>
	 <20090201174159.4a52e15c.akpm@linux-foundation.org>
	 <20090202064509.GA20237@redhat.com>
	 <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
	 <20090202165606.GA13346@redhat.com> <498754EF.8090604@redhat.com>
	 <3f43f78b0902021239s21566f76hf7f59850b2dbf45a@mail.gmail.com>
	 <3f43f78b0902021839j1eb1eb04u49be47277c99900d@mail.gmail.com>
	 <20090203133313.GA5679@redhat.com>
Date: Tue, 3 Feb 2009 11:51:42 -0800
Message-ID: <3f43f78b0902031151ta841190i2c7898facc34cb95@mail.gmail.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
From: Kaz Kylheku <kkylheku@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 3, 2009 at 5:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/02, Kaz Kylheku wrote:
>>
>> On Mon, Feb 2, 2009 at 12:39 PM, Kaz Kylheku <kkylheku@gmail.com> wrote:
>> > On Mon, Feb 2, 2009 at 12:17 PM, Ulrich Drepper <drepper@redhat.com> wrote:
>> >> The userlevel context of the
>> >> thread is not usable anymore.  It will have run all kinds of
>> >> destructors.  The current behavior is AFAIK that the main thread won't
>> >> react to any signal anymore.  That is absolutely required.
>> >
>> > Hey Ulrich,
>> >
>> > Thanks for articulating that requirement. I think it can be met by
>> > extending the patch a little bit.
>>
>> I've now done that.
>>
>> The exiting thread leader, if there are still other
>> threads alive, gets its own private signal handler array in which
>> every action is set to SIG_IGN, using the ignore_signals
>> function.
>>
>> I experimented with blocking signals, but that approach
>> breaks the test case of being able to attach GDB to the
>> exiting thread.
>>
>> As part of the patch, I found it convenient to extend the
>> incomplete sys_unshare functionality w.r.t. signal handlers,
>> rather than reinvent the wheel.
>
> This is wrong, we can not and must not unshare ->sighand.

You are right; it breaks important invariant conditions which
connect the thread group together, like the one about the
lock, et cetera.  The patch goes too far: rather than simply
delaying the finalization (relatively safe), it's messing with
the shared state (risky).

Well, it doesn't bother me that that has to be thrown out.
In fact, I do not agree with the requirement that the thread
which calls pthread_exit must not respond to signals;
the original patch works for me.

I.e. in my embedded GNU/Linux distro, that requirement
doesn't exist. And since I can't find it in the Single
Unix Specification, so much for that!

Nothing in the spec says that once pthread_exit is called,
signals are stopped. This function invokes cleanup handling,
and thread-specific-storage destruction. During any of those
tasks, signals can still be happening.  Any of those
tasks can easily enter into an indefinite wait. What if
a cleanup handler performs a blocking RPC to a remote
server? Well, there you are, stuck in pthread_exit,
handling signals, and not cleaning up your robust list, etc.

I also don't require robust locks to be cleaned up
instantly if they are owned by a main thread that has
called pthread_exit.

My organization is a heavy user of robust mutexes;
they protect the integrity of a large, ``real time'' database
stored in shared memory. I don't think that this would
affect us in any way. The principal concern is that
a process dies, for whatever reason, while holding locks.
It's more to recover from catastrophic failures, not from
mutex locking mistakes. If a thread locks a mutex and
doesn't release it due to bad program logic, that is a
problem whether or not that thread dies.  It's not
particularly useful that we can resolve that situation
with EOWNERDEAD in the kernel when that thread
happens to die, because that's just one case where
we are lucky, so to speak.

> Yes, gdb refuses to attach to the dead thread (I didn't check
> this myself, but I think you are right). But there is nothing
> wrong here, because we can't ptrace this thread. But, gdb
> _can_ ptrace the process, and it can see it have other threads.

Face it, allowing the thread leader to exit is as wrong as doing
other stupid things to the leader, like unsharing the signal
handler.

Either way, you are breaking some little stick which is holding
up the illusion that there is a process which has threads.

> OK, if nothing else. Let's suppose your patch is correct.

Obviously, the second part isn't. I'm very happy to have
any excuse to throw this out, thanks!

The first part isn't Ulrich-compliant. That is signficant,
and duly noted; but it's not the law where I'm sitting.
