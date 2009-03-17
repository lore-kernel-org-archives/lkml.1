Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZCQPO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZCQPO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZCQPOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:14:49 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:64153 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752924AbZCQPOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:14:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As0FAAtYv0lMQW1W/2dsb2JhbACBTtNtg3wG
Date: Tue, 17 Mar 2009 11:14:37 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: ltt-dev@lists.casi.polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] cli/sti vs local_cmpxchg and local_add_return
Message-ID: <20090317151436.GA10092@Krystal>
References: <20090317013220.GA22474@Krystal> <200903171705.35599.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200903171705.35599.nickpiggin@yahoo.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:39:43 up 17 days, 11:05,  1 user,  load average: 0.31, 0.41,
	0.37
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin (nickpiggin@yahoo.com.au) wrote:
> On Tuesday 17 March 2009 12:32:20 Mathieu Desnoyers wrote:
> > Hi,
> >
> > I am trying to get access to some non-x86 hardware to run some atomic
> > primitive benchmarks for a paper on LTTng I am preparing. That should be
> > useful to argue about performance benefit of per-cpu atomic operations
> > vs interrupt disabling. I would like to run the following benchmark
> > module on CONFIG_SMP :
> >
> > - PowerPC
> > - MIPS
> > - ia64
> > - alpha
> >
> > usage :
> > make
> > insmod test-cmpxchg-nolock.ko
> > insmod: error inserting 'test-cmpxchg-nolock.ko': -1 Resource temporarily
> > unavailable dmesg (see dmesg output)
> >
> > If some of you would be kind enough to run my test module provided below
> > and provide the results of these tests on a recent kernel (2.6.26~2.6.29
> > should be good) along with their cpuinfo, I would greatly appreciate.
> >
> > Here are the CAS results for various Intel-based architectures :
> >
> > Architecture         | Speedup                      |      CAS     |       
> >  Interrupts         |
> >
> >                      | (cli + sti) / local cmpxchg  | local | sync | Enable
> >                      | (sti) | Disable (cli)
> >
> > ---------------------------------------------------------------------------
> >---------------------- Intel Pentium 4      | 5.24                         |
> >  25   | 81   | 70           | 61          | AMD Athlon(tm)64 X2  | 4.57    
> >                     |  7    | 17   | 17           | 15          | Intel
> > Core2          | 6.33                         |  6    | 30   | 20          
> > | 18          | Intel Xeon E5405     | 5.25                         |  8   
> > | 24   | 20           | 22          |
> >
> > The benefit expected on PowerPC, ia64 and alpha should principally come
> > from removed memory barriers in the local primitives.
> 
> Benefit versus what? I think all of those architectures can do SMP
> atomic compare exchange sequences without barriers, can't they?
> 

Hi Nick,

I want to compare if it is faster to use SMP cas without barriers to
perform synchronization of the tracing hot path wrt interrupts or if it
is faster to disable interrupts. These decisions will depend on the
benchmark I propose, because it is comparing the time it takes to
perform both.

Overall, the benchmarks will allow to choose between those two
simplified hotpath pseudo-codes (offset is global to the buffer,
commit_count is per-subbuffer).


* lockless :

do {
  old_offset = local_read(&offset);
  get_cycles();
  compute needed size.
  new_offset = old_offset + size;
} while (local_cmpxchg(&offset, old_offset, new_offset) != old_offset);

/*
 * note : writing to buffer is done out-of-order wrt buffer slot
 * physical order.
 */
write_to_buffer(offset);

/*
 * Make sure the data is written in the buffer before commit count is
 * incremented.
 */
smp_wmb();

/* note : incrementing the commit count is also done out-of-order */
count = local_add_return(size, &commit_count[subbuf_index]);
if (count is filling a subbuffer)
  allow to wake up readers


* irq off :

(note : offset and commit count would each be written to atomically
(type unsigned long))

local_irq_save(flags);

get_cycles();
compute needed size;
offset += size;

write_to_buffer(offset);

/*
 * Make sure the data is written in the buffer before commit count is
 * incremented.
 */
smp_wmb();

commit_count[subbuf_index] += size;
if (count is filling a subbuffer)
  allow to wake up readers

local_irq_restore(flags);


* read-side

And basically, the data reader uses its own consumed data offset
"consumed" and reads the commit count corresponding to the subbuffer it
is about to read. It has the following pseudo-code :

(note commit_count and offset read each atomically)

consumed_old = atomic_long_read(&consumed);
compute consumed_idx from consumed_old
commit_count = commit_count[consumed_idx];
(or commit_count = local_read(&commit_count[consumed_idx]) for lockless)

/*
 * read commit count before reading the buffer data and write offset.
 */
smp_rmb();

write_offset = offset;
(or write_offset = local_read(&offset))

if (consumed_old and commit_count shows subbuffer not full)
  return -EAGAIN;

Allow reading subbuffer.


Mathieu

> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
