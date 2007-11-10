Return-Path: <linux-kernel-owner+w=401wt.eu-S1763997AbXKJD5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763997AbXKJD5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 22:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbXKJD5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 22:57:24 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:39613 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755192AbXKJD5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 22:57:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=L79r85D16Q0MEw0RjFzopbA4wsidbktTPDzDxRzi2xovWLJWcFE198nmLW47Ky65YSJCV5r3vbWUwlnONGcoIJFu+9sJ6CduQHqOUnuZgdZzH80UxgtQE1XY7amMUPoLD6+7OgIBjzG7QElOYLoFzGy9z1XzcV4Y2HKsr1HTUco=  ;
X-YMail-OSG: AIkg6d4VM1nuAFVc07EzOQRet.2xPZqDthKB6zSVG7c3ZYrO3qtkGF0OInNHNae7GSuBRiG88A--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: benh@kernel.crashing.org
Subject: Re: [PATCH, RFC] improved hacks to allow -rt to run kernbench on POWER
Date: Sat, 10 Nov 2007 12:18:47 +1100
User-Agent: KMail/1.9.5
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tony@bakeyournoodle.com, paulus@samba.org, dino@in.ibm.com,
       tytso@us.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com, antonb@us.ibm.com,
       rostedt@goodmis.org
References: <20071109181028.GA26800@linux.vnet.ibm.com> <1194641524.21340.14.camel@pasglop>
In-Reply-To: <1194641524.21340.14.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101218.47903.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 November 2007 07:52, Benjamin Herrenschmidt wrote:
> > diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/kernel/process.c
> > linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/process.c ---
> > linux-2.6.23.1-rt4/arch/powerpc/kernel/process.c	2007-10-12
> > 09:43:44.000000000 -0700 +++
> > linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/process.c	2007-11-08
> > 20:33:59.000000000 -0800 @@ -245,6 +245,8 @@ struct task_struct
> > *__switch_to(struct t
> >  	struct thread_struct *new_thread, *old_thread;
> >  	unsigned long flags;
> >  	struct task_struct *last;
> > +	struct ppc64_tlb_batch *batch;
> > +	int hadbatch;
> >
> >  #ifdef CONFIG_SMP
> >  	/* avoid complexity of lazy save/restore of fpu
> > @@ -325,6 +327,16 @@ struct task_struct *__switch_to(struct t
> >  	}
> >  #endif
> >
> > +	batch = &get_cpu_var(ppc64_tlb_batch);
> > +	if (batch->active) {
> > +		hadbatch = 1;
> > +		if (batch->index) {
> > +			__flush_tlb_pending(batch);
> > +		}
> > +		batch->active = 0;
> > +	}
> > +	put_cpu_var(ppc64_tlb_batch);
> > +
> >  	local_irq_save(flags);
> >
> >  	account_system_vtime(current);
> > @@ -335,6 +347,12 @@ struct task_struct *__switch_to(struct t
> >
> >  	local_irq_restore(flags);
> >
> > +	if (hadbatch) {
> > +		batch = &get_cpu_var(ppc64_tlb_batch);
> > +		batch->active = 1;
> > +		put_cpu_var(ppc64_tlb_batch);
> > +	}
> > +
> >  	return last;
> >  }
>
> I doubt we can schedule within __switch_to() (can somebody confirm
> this ?), in which case, you can just use __get_cpu_var() and avoid
> the put, thus saving a handful of cycles in the code above.

Preempt is always turned off over switch_to() call.
