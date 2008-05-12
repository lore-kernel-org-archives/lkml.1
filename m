Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbYELLFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbYELLFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYELLE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:04:57 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57553 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbYELLEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:04:55 -0400
Message-Id: <1210590294.13136.1252653345@webmail.messagingengine.com>
X-Sasl-Enc: UPOM/c8rYQ1ZcVSb1qMOHO+Lz2xtzlEgxKWPNfAjDDs1 1210590294
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Matthew Wilcox" <matthew@wil.cx>
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Jackson" <pj@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "linux-arch" <linux-arch@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080511135039.GA3286@mailshack.com>
   <20080511152440.GX19219@parisc-linux.org>
   <1210522779.16917.1252546109@webmail.messagingengine.com>
   <20080511220111.GC19219@parisc-linux.org>
Subject: Re: [PATCH] Make for_each_cpu_mask a bit smaller
In-Reply-To: <20080511220111.GC19219@parisc-linux.org>
Date: Mon, 12 May 2008 13:04:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008 16:01:12 -0600, "Matthew Wilcox" <matthew@wil.cx>
said:
> On Sun, May 11, 2008 at 06:19:39PM +0200, Alexander van Heukelum wrote:
> > 
> > On Sun, 11 May 2008 09:24:40 -0600, "Matthew Wilcox" <matthew@wil.cx>
> > said:
> > > On Sun, May 11, 2008 at 03:50:39PM +0200, Alexander van Heukelum wrote:
> > > >  #if NR_CPUS > 1
> > > > -#define for_each_cpu_mask(cpu, mask)		\
> > > > -	for ((cpu) = first_cpu(mask);		\
> > > > -		(cpu) < NR_CPUS;		\
> > > > -		(cpu) = next_cpu((cpu), (mask)))
> > > > +#define for_each_cpu_mask(cpu, mask)				\
> > > > +	for ((cpu) = 0;						\
> > > > +		(cpu) = find_next_cpu_mask((cpu), &(mask)),	\
> > > > +		(cpu) < NR_CPUS; (cpu)++)
> > > 
> > > For anyone else having similar cognitive dissonance while reading this
> > > thinking "But won't the first call to find_next_cpu_mask return a number
> > > > 0", the answer is "no, find_next_bit returns the next set bit that's
> > > >= the number passed in, which is why we need both the cpu++ and
> > > find_next_cpu_mask".  
> > 
> > That's how it works, indeed.
> > 
> > > > +int find_next_cpu_mask(int n, const cpumask_t *srcp)
> > > > +{
> > > > +	return find_next_bit(srcp->bits, NR_CPUS, n);
> > > > +}
> > > > +EXPORT_SYMBOL(find_next_cpu_mask);
> > > 
> > > Maybe a better name for this function would help.  I can't think of a
> > > good one right now though.
> > 
> > I can't think of a better name, and there is find_next_bit of which
> > find_next_cpu_mask is just a wrapper. I think the name is good enough.
> 
> How about doing it this way?
> 
> #define for_each_cpu_mask(cpu, mask)				\
> 	for ((cpu) = -1;					\
> 	     (cpu) < NR_CPUS;					\
> 	     (cpu) = find_next_cpu_mask((cpu), &(mask)))
> 
> int find_next_cpu_mask(int n, const cpumask_t *srcp)
> {
> 	return find_next_bit(srcp->bits, NR_CPUS, ++n);
> }
> 
> That actually behaves the way I'd expect a function called
> 'find_next_cpu_mask' to work.  It also abuses the 'for' condtion
> less and might take a little less text space.

But it does not work.

It introduces a stray cpu=-1 iteration if cpu happens to be
(replaced by) a signed variable.

It skips the entire loop if cpu happens to be unsigned.

I don't think that using 'for' in a less conventional way
is bad if it is hidden in a macro, as long as the name of
the macro makes the intention sufficiently clear.

I think of find_next_cpu_mask(cpu, mask) as: "find next
cpu-index in mask, starting at index cpu". And similar
with find_next_bit.

As for the text-space argument, I think you might be right.
Just not on i386/x86_64 where initialising a register to -1
can be done in three bytes, initialising to 0 in two bytes
and an increment in one byte :-).

Greetings,
    Alexander

> -- 
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

