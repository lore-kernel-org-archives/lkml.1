Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbZAZCZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbZAZCZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZAZCZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:25:13 -0500
Received: from smtp-out.google.com ([216.239.45.13]:1979 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZAZCZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:25:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=AApbANMvtO0EfSZfwEB4MHxKDu5vPQKqpv0N0M2DsQyqRTGc4s9VCaSIb8tAdkeQJ
	nyLjhTashCKlAyQ0Ygg4Q==
MIME-Version: 1.0
In-Reply-To: <20090124155212.GA5773@nowhere>
References: <20090122083457.GC7438@elte.hu> <20090122195513.GA22146@google.com>
	 <1fe6c7900901221921m586b129dwf8c3446f897b57f0@mail.gmail.com>
	 <20090123092306.GB29820@elte.hu>
	 <c62985530901230204i3880c3f8xbebdb6844f35addf@mail.gmail.com>
	 <20090124015513.GA31189@google.com> <20090124155212.GA5773@nowhere>
Date: Sun, 25 Jan 2009 18:25:04 -0800
Message-ID: <1fe6c7900901251825m9c19371v946b08d5d2928d86@mail.gmail.com>
Subject: Re: [PATCH v3] softlockup: remove hung_task_check_count
From: Mandeep Baines <msb@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-GMailtapped-By: 172.28.16.76
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frédéric,

Yeah, that might work. I think you can even embed waiters_count inside
the lock. I think this can be
done with minimal changes and with no overhead added to the lock
functions. Maybe use bits 7-0 for waiters_count and move the readers
count up 8 bits.

To make room for writers_count I'd change read_lock from:

static inline void __raw_read_lock(raw_rwlock_t *rw)
{
        asm volatile(LOCK_PREFIX " subl $1,(%0)\n\t"
                     "jns 1f\n"
                     "call __read_lock_failed\n\t"
                     "1:\n"
                     ::LOCK_PTR_REG (rw) : "memory");
}

To:

static inline void __raw_read_lock(raw_rwlock_t *rw)
{
        asm volatile(LOCK_PREFIX " subl $0x100,(%0)\n\t"
                     "jns 1f\n"
                     "call __read_lock_failed\n\t"
                     "1:\n"
                     ::LOCK_PTR_REG (rw) : "memory");
}

I think that's all you'd need to change for read_lock. For write_lock
you'd have to subtract (RW_LOCK_BIAS - 1) instead of just RW_LOCK_BIAS
during lock and add it back for unlock. You'd also have to change the
tests a little to ignore bits 7-0.

Regards,
Mandeep

On Sat, Jan 24, 2009 at 7:52 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, Jan 23, 2009 at 05:55:14PM -0800, Mandeep Singh Baines wrote:
>> Frédéric Weisbecker (fweisbec@gmail.com) wrote:
>> > 2009/1/23 Ingo Molnar <mingo@elte.hu>:
>> > >
>> > > not sure i like the whole idea of removing the max iterations check. In
>> > > theory if there's a _ton_ of tasks, we could spend a lot of time looping
>> > > there. So it always looked prudent to limit it somewhat.
>> > >
>> >
>> > Which means we can loose several of them. Would it hurt to iterate as
>> > much as possible along the task list,
>> > keeping some care about writers starvation and latency?
>> > BTW I thought about the slow work framework, but I can't retrieve
>> > it....  But this thread has already a slow priority.
>> >
>> > Would it be interesting to provide a way for rwlocks to know if there
>> > is writer waiting for the lock?
>>
>> Would be cool if that API existed. You could release the CPU and/or lock as
>> soon as either was contended for. You'd have the benefits of fine-grained
>> locking without the overhead of locking and unlocking multiple time.
>>
>> Currently, there is no bit that can tell you there is a writer waiting. You'd
>> probably need to change the write_lock() implementation at a minimum. Maybe
>> if the first writer left the RW_LOCK_BIAS bit clear and then waited for the
>> readers to leave instead of re-trying? That would actually make write_lock()
>> more efficient for the 1-writer case since you'd only need to spin doing
>> a read in the failure case instead of an atomic_dec and atomic_inc.
>>
>
>
> This is already what is done in the slow path (in x86):
>
> /* rdi: pointer to rwlock_t */
> ENTRY(__write_lock_failed)
>        CFI_STARTPROC
>        LOCK_PREFIX
>        addl $RW_LOCK_BIAS,(%rdi)
> 1:      rep
>        nop
>        cmpl $RW_LOCK_BIAS,(%rdi)
>        jne 1b
>        LOCK_PREFIX
>        subl $RW_LOCK_BIAS,(%rdi)
>        jnz  __write_lock_failed
>        ret
>        CFI_ENDPROC
> END(__write_lock_failed)
>
> It spins lurking at the lock value and only if there are no writers nor readers that
> own the lock, it restarts its atomic_sub (and then atomic_add in fail case).
>
> And if an implementation of writers_waiting_for_lock() is needed, I guess this
> is the perfect place. One atomic_add on a "waiters_count" on entry and an atomic_sub
> on it on exit.
>
> Since this is the slow_path, I guess that wouldn't really impact the performances....
>
>
