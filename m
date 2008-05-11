Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbYEKWBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbYEKWBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 18:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760594AbYEKWBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 18:01:16 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55757 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760494AbYEKWBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 18:01:14 -0400
Date: Sun, 11 May 2008 16:01:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make for_each_cpu_mask a bit smaller
Message-ID: <20080511220111.GC19219@parisc-linux.org>
References: <20080511135039.GA3286@mailshack.com> <20080511152440.GX19219@parisc-linux.org> <1210522779.16917.1252546109@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210522779.16917.1252546109@webmail.messagingengine.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 06:19:39PM +0200, Alexander van Heukelum wrote:
> 
> On Sun, 11 May 2008 09:24:40 -0600, "Matthew Wilcox" <matthew@wil.cx>
> said:
> > On Sun, May 11, 2008 at 03:50:39PM +0200, Alexander van Heukelum wrote:
> > >  #if NR_CPUS > 1
> > > -#define for_each_cpu_mask(cpu, mask)		\
> > > -	for ((cpu) = first_cpu(mask);		\
> > > -		(cpu) < NR_CPUS;		\
> > > -		(cpu) = next_cpu((cpu), (mask)))
> > > +#define for_each_cpu_mask(cpu, mask)				\
> > > +	for ((cpu) = 0;						\
> > > +		(cpu) = find_next_cpu_mask((cpu), &(mask)),	\
> > > +		(cpu) < NR_CPUS; (cpu)++)
> > 
> > For anyone else having similar cognitive dissonance while reading this
> > thinking "But won't the first call to find_next_cpu_mask return a number
> > > 0", the answer is "no, find_next_bit returns the next set bit that's
> > >= the number passed in, which is why we need both the cpu++ and
> > find_next_cpu_mask".  
> 
> That's how it works, indeed.
> 
> > > +int find_next_cpu_mask(int n, const cpumask_t *srcp)
> > > +{
> > > +	return find_next_bit(srcp->bits, NR_CPUS, n);
> > > +}
> > > +EXPORT_SYMBOL(find_next_cpu_mask);
> > 
> > Maybe a better name for this function would help.  I can't think of a
> > good one right now though.
> 
> I can't think of a better name, and there is find_next_bit of which
> find_next_cpu_mask is just a wrapper. I think the name is good enough.

How about doing it this way?

#define for_each_cpu_mask(cpu, mask)				\
	for ((cpu) = -1;					\
	     (cpu) < NR_CPUS;					\
	     (cpu) = find_next_cpu_mask((cpu), &(mask)))

int find_next_cpu_mask(int n, const cpumask_t *srcp)
{
	return find_next_bit(srcp->bits, NR_CPUS, ++n);
}

That actually behaves the way I'd expect a function called
'find_next_cpu_mask' to work.  It also abuses the 'for' condtion
less and might take a little less text space.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
