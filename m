Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbYAGJCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbYAGJCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 04:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYAGJCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 04:02:06 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:25552 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755858AbYAGJCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 04:02:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bXojc7GNFICaCdb/G2IUBK9TOHbi/XeTI50UKoYR/cAkS/kCnJia0A5NKZlDqedPJf5eTxxjzI4lk7ZOjjin1Y5YLFJC9iBXdYf5XfmJLwW3aJfH8obYgQqDYciAzECQEsR6gISpGuz3YKzMqVg0P8IQ73pod5SJkLZqvllfwus=  ;
X-YMail-OSG: 2qI9jz0VM1m7BXF3Kfx8_uNE5Mp4HFRsOihGz6OnrJMjqq.w0c8cP7hfevIU.6fb2icPScQkpg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 02/20] make the inode i_mmap_lock a reader/writer lock
Date: Mon, 7 Jan 2008 20:01:30 +1100
User-Agent: KMail/1.9.5
Cc: Mike Travis <travis@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ak@suse.de
References: <20071218211539.250334036@redhat.com> <200801031707.14607.nickpiggin@yahoo.com.au> <20080103085525.GB10813@elte.hu>
In-Reply-To: <20080103085525.GB10813@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801072001.30986.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008 19:55, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > Have you done anything more with allowing > 256 CPUS in this
> > > spinlock patch?  We've been testing with 1k cpus and to verify with
> > > -mm kernel, we need to "unpatch" these spinlock changes.
> >
> > Hi Mike,
> >
> > Actually I had it in my mind that 64 bit used single-byte locking like
> > i386, so I didn't think I'd caused a regression there.
> >
> > I'll take a look at fixing that up now.
>
> thanks - this is a serious showstopper for the ticket spinlock patch.
>
> ( which has otherwise been performing very well in x86.git so far - it
>   has passed a few thousand bootup tests on 64-bit and 32-bit as well,
>   so we are close to it being in a mergable state. Would be a pity to
>   lose it due to the 256 cpus limit. )

OK, this is what my test harness code looks like for > 256 CPUs
(basically the same as the in-kernel code, but some names etc. are slightly
different).

It passes my basic tests, and performance doesn't seem to have suffered.
I was going to suggest making the <= 256 vs > 256 cases config options, but
maybe we don't need to unless some CPUs are slow at shifts / rotates? I
don't know...

After I get comments, I will come up with an incremental patch against
the kernel... It will be interesting to know whether ticket locks help
big SGI systems.

static inline void xlock(lock_t *lock)
{
        lock_t inc = 0x00010000;
        lock_t tmp;

        __asm__ __volatile__ (
                "lock ; xaddl %0, %1\n"
                "movzwl %w0, %2\n\t"
                "shrl $16, %0\n\t"
                "1:\t"
                "cmpl %0, %2\n\t"
                "je 2f\n\t"
                "rep ; nop\n\t"
                "movzwl %1, %2\n\t"
                /* don't need lfence here, because loads are in-order */
                "jmp 1b\n"
                "2:"
                :"+Q" (inc), "+m" (*lock), "=r" (tmp)
                :
                :"memory", "cc");
}

static inline int xtrylock(lock_t *lock)
{
        lock_t tmp;
        lock_t new;

        asm volatile(
                "movl %2,%0\n\t"
                "movl %0,%1\n\t"
                "roll $16, %0\n\t"
                "cmpl %0,%1\n\t"
                "jne 1f\n\t"
                "addl $0x00010000, %1\n\t"
                "lock ; cmpxchgl %1,%2\n\t"
                "1:"
                "sete %b1\n\t"
                "movzbl %b1,%0\n\t"
                :"=&a" (tmp), "=r" (new), "+m" (*lock)
                :
                : "memory", "cc");

        return tmp;
}

static inline void xunlock(lock_t *lock)
{
        __asm__ __volatile__(
                "incw %0"
                :"+m" (*lock)
                :
                :"memory", "cc");
}

                        
