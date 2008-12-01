Return-Path: <linux-kernel-owner+w=401wt.eu-S1751217AbYLAGFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbYLAGFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYLAGF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:05:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:15608 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYLAGFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:05:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=OkUIyw3x4LQpHSnJDcKVbrHm1p8E2a1YxAekZ1uPKcKwdf1ZkrIjPXs56Khwqk81GJ
         dZ6+WVrvK1CR5p86Ipo5OgMAKIftIAUw3fbYRRaosi66nbNvEOo+geIyCsS0b++2wHoj
         FLqESLvzmQaxsLQ3JByirIXiYOIr965mX5eIQ=
Message-ID: <7c86c4470811302205v86cf2e6j4e6d3131a8292cc4@mail.gmail.com>
Date: Mon, 1 Dec 2008 07:05:21 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [patch 20/24] perfmon: system calls interface
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org,
       sfr@canb.auug.org.au, "Roland McGrath" <roland@redhat.com>,
       "Oleg Nesterov" <oleg@redhat.com>
In-Reply-To: <18739.13487.859058.857227@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
	 <20081126140027.GC6562@elte.hu>
	 <7c86c4470811270622s540a17d8r73462dfa93d1bc6d@mail.gmail.com>
	 <18739.13487.859058.857227@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Mon, Dec 1, 2008 at 1:49 AM, Paul Mackerras <paulus@samba.org> wrote:
> stephane eranian writes:
>
>> Perfmon requires ptrace ONLY to stop the thread you want to operate
>> on. For instance, to read the counters in a thread via pfm_read(), you
>> need to have that thread stopped, so perfmon can extract the machine
>> state safely.
>
> What would happen if the thread wasn't stopped?  Is it just that the
> numbers would be inaccurate, or is there some kind of security
> exposure?
>
There are certain operations which cannot be performed, for instance
attaching/detaching.

As for read and write, sure you could never touch the PMU directly if you were
not self-monitoring. But then there is question as what does the
interface guarantee
in terms of execution of the actions. With read, you'd have to say the
interface does
not guarantee the value returned is up-to-date. For applications which
never context
switch, for instance, there the values read from the software state
maybe totally stale.

> If it's just that the numbers would be inaccurate, then I don't think
> the kernel needs to enforce it.  The monitoring program *should*
> ensure that the thread is stopped or blocked, one way or another, but
> it could do that simply by sending a SIGSTOP to the thread.  I don't
> see that it would necessarily have to use ptrace.
>
Because ptrace provides the additional guarantees, for instance,
nobody can do  a SIGCONT
while you are operating on the ptraced thread, nobody else can do the
PTRACE_DETATCH.
Now, I don't think bad things could actually happen if a SIGCONT were
to happen, because
the context is locked during all operations and the context switch in
routine tries to grab that
lock. There may be difficulties if you hold the lock and then you need
to release it for one operation
and then you grab it again. There may be a couple of places where we do that.

Also sending SIGSTOP is not enough to guarantee the thread is off of
the CPU. You need to wait
until it is actually off, i.e., all the state has been saved. I don't
think you can test that from userland.


Note that I am not arguing that we will have to use ptrace forever. In
fact, utrace provides the mechanisms
and the guarantees to avoid using ptrace alltogether. With utrace,
applications would directly call into the
kernel and then, if needed, the kernel would use utrace to stop the
other thread. I have played with that several
months ago and it worked fine. The problem is that utrace is still not in.
