Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbZFBH12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbZFBH12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbZFBH1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:27:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756987AbZFBH1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:27:19 -0400
Date: Tue, 2 Jun 2009 00:26:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/9] kernel: export sound/core/pcm_timer.c gcd
 implementation
Message-Id: <20090602002616.d5707d6b.akpm@linux-foundation.org>
In-Reply-To: <200906020919.25162.florian@openwrt.org>
References: <200906011357.09966.florian@openwrt.org>
	<20090601215034.7352ddca.akpm@linux-foundation.org>
	<200906020919.25162.florian@openwrt.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009 09:19:22 +0200 Florian Fainelli <florian@openwrt.org> wrote:

> Le Tuesday 02 June 2009 06:50:34 Andrew Morton, vous avez __crit__:
> > On Mon, 1 Jun 2009 13:57:09 +0200 Florian Fainelli <florian@openwrt.org> 
> wrote:
> > > This patch exports the gcd implementation from
> > > sound/core/pcm_timer.c into include/linux/kernel.h.
> > > AR7 uses it in its clock routines.
> > >
> > > ...
> > >
> > > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > > index 883cd44..878a27a 100644
> > > --- a/include/linux/kernel.h
> > > +++ b/include/linux/kernel.h
> > > @@ -147,6 +147,22 @@ extern int _cond_resched(void);
> > >  		(__x < 0) ? -__x : __x;		\
> > >  	})
> > >
> > > +/* Greatest common divisor */
> > > +static inline unsigned long gcd(unsigned long a, unsigned long b)
> > > +{
> > > +        unsigned long r;
> > > +        if (a < b) {
> > > +                r = a;
> > > +                a = b;
> > > +                b = r;
> > > +        }
> > > +        while ((r = a % b) != 0) {
> > > +                a = b;
> > > +                b = r;
> > > +        }
> > > +        return b;
> > > +}
> >
> > a) the name's a bit sucky.   Is there some convention for this name?
> 
> We might want something better like greatest_common_divisor which is a bit 
> more self-explanatory ?

Well, if gcd() is a commonly used name then let's use that.  I don't
personally recall seeing it used but that doesn't mean much.

> >
> > b) It looks too large to be inlined.  lib/gdc.c?
> 
> And its users select it in order not to increase the size of kernel.h, sounds 
> good.
> 
> >
> > b) there's an implementation of gcd() in
> >    net/netfilter/ipvs/ip_vs_wrr.c.  I expect that this patch broke the
> >    build.
> 
> I did forget about this. That gcd implementation only treats the a > b case.
> 
> What do you prefer, each user keeps its gcd implementation locally or we make 
> a lib/gcd.c for it ?

I think lib/gcd.c would be better.  Then migrate current code over to
use that.

The problem with offering a generic version is types: will it work
correctly and sensibly for all combinations of signed/unsigned
char/short/int/long/longlong?  All but the last, I expect.  In which
case that'll be good enough for now.
