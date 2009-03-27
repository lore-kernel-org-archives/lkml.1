Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZC0LPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZC0LPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZC0LO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:14:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49153 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZC0LO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:14:57 -0400
Subject: Re: Question about PRIVATE_FUTEX
From: Peter Zijlstra <peterz@infradead.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, lkml <linux-kernel@vger.kernel.org>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <28c262360903270356x6a9fc929m96941de8f8201fb0@mail.gmail.com>
References: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>
	 <1238143759.7808.2885.camel@twins>
	 <28c262360903270356x6a9fc929m96941de8f8201fb0@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 27 Mar 2009 12:14:56 +0100
Message-Id: <1238152496.7808.3203.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 19:56 +0900, Minchan Kim wrote:

> >> Then, get_futex_value_locked calls __cpy_from_user_inatomic with
> >> pagefault_disable.
> >>
> >> Who make sure the user page is mapped at app's page table ?
> >
> > Nobody, all uses of get_futex_value_locked() have to deal with it
> > returning -EFAULT.
> 
> Does It mean that __copy_from_user_inatomic in get_futex_value_locked
> would be failed rather than sleep?

Correct.

> In fact, I don't make sure _copy_from_user_inatomic function's meaning.
> As far as I understand, It never sleep. It just can be failed in case
> of user page isn't mapped. Is right ?

Correct.

> Otherwise, it can be scheduled with pagefault_disable which increments
> preempt_count. It is a atomic bug.
> If my assume is right, it can be failed rather than sleep.
> At this case, other architecture implements __copy_from_user_inatomic
> with __copy_from_user which can be scheduled. It also can be bug.
> 
> Hmm, Now I am confusing.

Confused I guess ;-)

The trick is in the in_atomic() check in the pagefault handler and the
fixup section of the copy routines.

#define __copy_user(to, from, size)                                     \
do {                                                                    \
        int __d0, __d1, __d2;                                           \
        __asm__ __volatile__(                                           \
                "       cmp  $7,%0\n"                                   \
                "       jbe  1f\n"                                      \
                "       movl %1,%0\n"                                   \
                "       negl %0\n"                                      \
                "       andl $7,%0\n"                                   \
                "       subl %0,%3\n"                                   \
                "4:     rep; movsb\n"                                   \
                "       movl %3,%0\n"                                   \
                "       shrl $2,%0\n"                                   \
                "       andl $3,%3\n"                                   \
                "       .align 2,0x90\n"                                \
                "0:     rep; movsl\n"                                   \
                "       movl %3,%0\n"                                   \
                "1:     rep; movsb\n"                                   \
                "2:\n"                                                  \
                ".section .fixup,\"ax\"\n"                              \
                "5:     addl %3,%0\n"                                   \
                "       jmp 2b\n"                                       \
                "3:     lea 0(%3,%0,4),%0\n"                            \
                "       jmp 2b\n"                                       \
                ".previous\n"                                           \
                ".section __ex_table,\"a\"\n"                           \
                "       .align 4\n"                                     \
                "       .long 4b,5b\n"                                  \
                "       .long 0b,3b\n"                                  \
                "       .long 1b,2b\n"                                  \
                ".previous"                                             \
                : "=&c"(size), "=&D" (__d0), "=&S" (__d1), "=r"(__d2)   \
                : "3"(size), "0"(size), "1"(to), "2"(from)              \
                : "memory");                                            \
} while (0)

see that __ex_table section, it tells the fault handler where to
continue in case of an atomic fault.

> > Most of this is legacy btw, from when futex ops were done under the
> > mmap_sem. Back then we couldn't fault because that would cause mmap_sem
> > recursion. Howver, now that we don't hold mmap_sem anymore we could use
> > a faulting user access like get_user().
> > Darren has been working on patches to clean that up, some of those are
> > already merged in the -tip tree.
> 
> Thanks for good information.
> It will be very desirable way to enhance kernel performance.

I doubt it'll make a measurable difference, if you need to fault
performance sucks anyway. If you don't, the current code is just as
fast.
