Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZCRLnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZCRLnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbZCRLnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:43:47 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:33928 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756358AbZCRLnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:43:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ju3BnHZgdgvH35hHk7ioRcYL6G2QUJc/wzgt+pUdukbzy3cCsr0/ypSsAUamSoz8ql2FZmT0RgyxfIVjuuAqwBH4C10zO5hMqMUE7BS6GbJZJsmZ8FkTLQ/xyImCIi6jru+T1Ncru0Qn+HmghYY4hrrayMd8tLFaMn5mbK9uO/s=  ;
X-YMail-OSG: dkBj08cVM1mzeKvN6DY30QxAHcJnsxBgWce9mOdXVMaHuHKxSEoEWE7uIDxQBoNg0zTHYGZqsU_M6996CwUlduco.EAx.IiRCWMac5qjsCXQi7dSWtzCWY1OB4HI9WUkAcHuOoSj1C8EGO2uI2QYoGZzL0S6ApK2L_GUEkRLRWaZbSVwzlpaTV_KQieBmKwB9._MvWNWK6i0BUeT4uzh8RksEbMa_Vfp4U4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [ltt-dev] cli/sti vs local_cmpxchg and local_add_return
Date: Wed, 18 Mar 2009 22:43:33 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: ltt-dev@lists.casi.polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
References: <20090317013220.GA22474@Krystal> <200903171705.35599.nickpiggin@yahoo.com.au> <20090317151436.GA10092@Krystal>
In-Reply-To: <20090317151436.GA10092@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903182243.34090.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009 02:14:37 Mathieu Desnoyers wrote:
> * Nick Piggin (nickpiggin@yahoo.com.au) wrote:
> > On Tuesday 17 March 2009 12:32:20 Mathieu Desnoyers wrote:
> > > Hi,
> > >
> > > I am trying to get access to some non-x86 hardware to run some atomic
> > > primitive benchmarks for a paper on LTTng I am preparing. That should
> > > be useful to argue about performance benefit of per-cpu atomic
> > > operations vs interrupt disabling. I would like to run the following
> > > benchmark module on CONFIG_SMP :
> > >
> > > - PowerPC
> > > - MIPS
> > > - ia64
> > > - alpha
> > >
> > > usage :
> > > make
> > > insmod test-cmpxchg-nolock.ko
> > > insmod: error inserting 'test-cmpxchg-nolock.ko': -1 Resource
> > > temporarily unavailable dmesg (see dmesg output)
> > >
> > > If some of you would be kind enough to run my test module provided
> > > below and provide the results of these tests on a recent kernel
> > > (2.6.26~2.6.29 should be good) along with their cpuinfo, I would
> > > greatly appreciate.
> > >
> > > Here are the CAS results for various Intel-based architectures :
> > >
> > > Architecture         | Speedup                      |      CAS     |
> > >  Interrupts         |
> > >
> > >                      | (cli + sti) / local cmpxchg  | local | sync |
> > >                      | Enable (sti) | Disable (cli)
> > >
> > > -----------------------------------------------------------------------
> > >---- ---------------------- Intel Pentium 4      | 5.24                 
> > >        | 25   | 81   | 70           | 61          | AMD Athlon(tm)64 X2
> > >  | 4.57
> > >
> > >                     |  7    | 17   | 17           | 15          | Intel
> > >
> > > Core2          | 6.33                         |  6    | 30   | 20
> > >
> > > | 18          | Intel Xeon E5405     | 5.25                         | 
> > > | 8 24   | 20           | 22          |
> > >
> > > The benefit expected on PowerPC, ia64 and alpha should principally come
> > > from removed memory barriers in the local primitives.
> >
> > Benefit versus what? I think all of those architectures can do SMP
> > atomic compare exchange sequences without barriers, can't they?
>
> Hi Nick,
>
> I want to compare if it is faster to use SMP cas without barriers to
> perform synchronization of the tracing hot path wrt interrupts or if it
> is faster to disable interrupts. These decisions will depend on the
> benchmark I propose, because it is comparing the time it takes to
> perform both.
>
> Overall, the benchmarks will allow to choose between those two
> simplified hotpath pseudo-codes (offset is global to the buffer,
> commit_count is per-subbuffer).
>
>
> * lockless :
>
> do {
>   old_offset = local_read(&offset);
>   get_cycles();
>   compute needed size.
>   new_offset = old_offset + size;
> } while (local_cmpxchg(&offset, old_offset, new_offset) != old_offset);
>
> /*
>  * note : writing to buffer is done out-of-order wrt buffer slot
>  * physical order.
>  */
> write_to_buffer(offset);
>
> /*
>  * Make sure the data is written in the buffer before commit count is
>  * incremented.
>  */
> smp_wmb();
>
> /* note : incrementing the commit count is also done out-of-order */
> count = local_add_return(size, &commit_count[subbuf_index]);
> if (count is filling a subbuffer)
>   allow to wake up readers

Ah OK, so you just mean the benefit of using local atomics is avoiding
the barriers that you get with atomic_t.

I'd thought you were referring to some benefit over irq disable pattern.


> * irq off :
>
> (note : offset and commit count would each be written to atomically
> (type unsigned long))
>
> local_irq_save(flags);
>
> get_cycles();
> compute needed size;
> offset += size;
>
> write_to_buffer(offset);
>
> /*
>  * Make sure the data is written in the buffer before commit count is
>  * incremented.
>  */
> smp_wmb();
>
> commit_count[subbuf_index] += size;
> if (count is filling a subbuffer)
>   allow to wake up readers
>
> local_irq_restore(flags);

