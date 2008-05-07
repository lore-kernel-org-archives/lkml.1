Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYEGWMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYEGWMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbYEGWLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:11:24 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40452 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762432AbYEGWLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:11:15 -0400
Date: Thu, 8 May 2008 01:09:42 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
Message-ID: <20080507220942.GD14951@cs181133002.pp.htv.fi>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <20080507212343.GB14951@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 11:54:19PM +0200, Thomas Gleixner wrote:
> On Thu, 8 May 2008, Adrian Bunk wrote:
> > On Wed, May 07, 2008 at 10:52:36PM +0200, Thomas Gleixner wrote:
>...
> > > Also there is no downside on these older systems. They are fine with
> > > MTRRs and have been for years. We can revisit that once PAT support
> > > has stabilized.
> > 
> > My comment was about:
> > "please try attach patch to see if duron support PAT."
> 
> I know.
>  
> > That information is for sure available.
> 
> So you know where it is and you can confirm that it works fine ?
> 
> Pointers please. 

Rene testing the patch Yinghai Lu sent would can reveal reliably whether 
it works fine for all Duron steppings?

> > > This feature and detection code is hard to clean up and definitely out
> > > of the scope of this patch.
> > 
> > Did you even look at the commit we are discussing?
> > 
> > It ***adds*** exactly the same code at three different places.
> 
> Yes, I did. And it adds it for a fscking good reason. 
> 
> 1) two times in common.c due to the existing detection logic mess
> 2) once in the 64 bit version
> 
> Again, this code is inherited and fragile mess, which can not be
> changed at will.

Please explain why having this code twice in arch/x86/kernel/cpu/common.c
should be safer than doing the logical thing of putting it into an own 
function:

void clear_set_pat(struct cpuinfo_x86 *c)
{
	clear_cpu_cap(c, X86_FEATURE_PAT);

	switch (c->x86_vendor) {
	case X86_VENDOR_AMD:
		if (c->x86 >= 0xf && c->x86 <= 0x11)
			set_cpu_cap(c, X86_FEATURE_PAT);
		break;
	case X86_VENDOR_INTEL:
	if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
			set_cpu_cap(c, X86_FEATURE_PAT);
		break;
	}
}

> > >...
> > > > And this patch (by the author of the code himself) is the first time 
> > > > where it breaks.
> > > 
> > > Very interesting analysis. What broke ? This CPU was never in the set
> > > of supported ones at all.
> > 
> > The patch in the email I answered to was broken since the author did 
> 
> "the author" has a name.
> 
> > fall into his own trap by patching only one copy of his duplicated code.
> 
> That's not a real good reason to yell at him.
> 
> Yinghai  wanted to help out and check with the reporter whether this CPU
> works with PAT or not.
> 
> Yinghai made a mistake.
> 
> You come along and ride a crusade against him for that. Very helpful.

I'm actually on a crusade against:
- the many empty or unusable commit descriptions that recently came
  through the x86 tree
- the fact that Yinghai Lu ignored Pavel's valid commit to not do
  copy&paste programming

> Thanks,
> 
> 	tglx

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

