Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbXIUCEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbXIUCEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 22:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXIUCE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 22:04:27 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:54313 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXIUCE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 22:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Tyc25VC87fSs1ko51KXVHCQ1oOBGIQNbwTqTY7UZtpOYRMgKR34EHjVr/yJHu8e9TBMdC4BGDB8pMCzWiDw/3rJnK+ntlGXgtC+h8VFmAP5WU+D9k3PNDhboMMpR0YOv1PpkiKkSi9BSY6iOsP8iRJSORx61CuBQwf1kFeSQ7P4=
Date: Thu, 20 Sep 2007 22:04:18 -0400
To: Kamalesh Babulal <kamalesh.babulal@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070921020417.GC31759@nineveh.local>
Mail-Followup-To: Kamalesh Babulal <kamalesh.babulal@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
	Mike Travis <travis@sgi.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919235828.GA31759@nineveh.local> <20070919170934.84f44e05.akpm@linux-foundation.org> <f86d6cc00709200721h6e8f7cf8xa2264e9d1f88883b@mail.gmail.com> <f86d6cc00709200912j37a3218boa882a044c0610779@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f86d6cc00709200912j37a3218boa882a044c0610779@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 09:42:44PM +0530, Kamalesh Babulal wrote:
> On 9/20/07, Kamalesh Babulal <kamalesh.babulal@gmail.com> wrote:
> > On 9/20/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > On Wed, 19 Sep 2007 19:58:28 -0400
> > > jfannin@gmail.com (Joseph Fannin) wrote:
> > >
> > > > On Tue, Sep 18, 2007 at 01:18:41AM -0700, Andrew Morton wrote:
> > >
> > > ---
> > > a/include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2
> > >
> > > +++ a/include/asm-powerpc/smp.h
> > > @@ -25,8 +25,8 @@
> > >
> > > #ifdef CONFIG_PPC64
> > > #include <asm/paca.h>
> > > -#include <asm/percpu.h>
> > > #endif
> > > +#include <asm/percpu.h>
> > >
> > > extern int boot_cpuid;


> > Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > ---
> > --- linux-2.6.23-rc6 /drivers/net/mace.c 2007-09-20 17:16:50.000000000+0530
> > +++ linux-2.6.23-rc6/drivers/net/~mace.c        2007-09-20 17:12:
> > 47.000000000 +0530
> > @@ -633,7 +633,7 @@ static void mace_set_multicast(struct ne
> >      spin_unlock_irqrestore(&mp->lock, flags);
> >  }
> >
> > -static void mace_handle_misc_intrs(struct mace_data *mp, int intr)
> > +static void mace_handle_misc_intrs(struct mace_data *mp, int intr, struct
> > net_device *dev)
> >  {
> >      volatile struct mace __iomem *mb = mp->mace;
> >      static int mace_babbles, mace_jabbers;
> > @@ -669,7 +669,7 @@ static irqreturn_t mace_interrupt(int ir
> >      spin_lock_irqsave(&mp->lock, flags);
> >      intr = in_8(&mb->ir);              /* read interrupt register */
> >      in_8(&mb->xmtrc);                  /* get retries */
> > -    mace_handle_misc_intrs(mp, intr);
> > +    mace_handle_misc_intrs(mp, intr, dev);
> >
> >      i = mp->tx_empty;
> >      while (in_8(&mb->pr) & XMTSV) {
> > @@ -682,7 +682,7 @@ static irqreturn_t mace_interrupt(int ir
> >          */
> >         intr = in_8(&mb->ir);
> >         if (intr != 0)
> > -           mace_handle_misc_intrs(mp, intr);
> > +           mace_handle_misc_intrs(mp, intr, dev);
> >         if (mp->tx_bad_runt) {
> >             fs = in_8(&mb->xmtfs);
> >             mp->tx_bad_runt = 0;
> > @@ -817,7 +817,7 @@ static void mace_tx_timeout(unsigned lon
> >         goto out;
> >
> >      /* update various counters */
> > -    mace_handle_misc_intrs(mp, in_8(&mb->ir));
> > +    mace_handle_misc_intrs(mp, in_8(&mb->ir), dev);
> >
> >      cp = mp->tx_cmds + NCMDS_TX * mp->tx_empty;

    Both these patches have built and booted for me.

    I will send a patch for the following error separately, in what
will hopefully be canonical patch submission format, in case that's of
any use.

    Thanks.

> drivers/net/mv643xx_eth.c: In function 'mv643xx_eth_int_handler':
> drivers/net/mv643xx_eth.c:564: error: 'bp' undeclared (first use in this
> function)
> drivers/net/mv643xx_eth.c:564: error: (Each undeclared identifier is
> reported only once
> drivers/net/mv643xx_eth.c:564: error: for each function it appears in.)
> drivers/net/mv643xx_eth.c: At top level:
> drivers/net/mv643xx_eth.c:1010: error: conflicting types for 'mv643xx_poll'
> drivers/net/mv643xx_eth.c:68: error: previous declaration of 'mv643xx_poll'
> was here
> make[2]: *** [drivers/net/mv643xx_eth.o] Error 1
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2


--
Joseph Fannin
jfannin@gmail.com

