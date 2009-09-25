Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZIYOrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZIYOrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 10:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZIYOrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 10:47:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZIYOrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 10:47:06 -0400
Date: Fri, 25 Sep 2009 11:46:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/63] edac_mce: Add an interface driver to report mce
 errors via edac
Message-ID: <20090925114646.48e186c2@pedra.chehab.org>
In-Reply-To: <20090925135626.GA8145@aftab>
References: <20090924192727.212ce46f@pedra.chehab.org>
	<20090925094855.GA29551@aftab>
	<20090925091130.14135879@pedra.chehab.org>
	<20090925135626.GA8145@aftab>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 25 Sep 2009 15:56:26 +0200
Borislav Petkov <borislav.petkov@amd.com> escreveu:

> Hi,
> 
> On Fri, Sep 25, 2009 at 09:11:30AM -0300, Mauro Carvalho Chehab wrote:
> > > >  		entry = rcu_dereference(mcelog.next);
> > > >  		for (;;) {
> > > >  			/*
> > > > +			 * If edac_mce is enabled, it will check the error type
> > > > +			 * and will process it, if it is a known error.
> > > > +			 * Otherwise, the error will be sent through mcelog
> > > > +			 * interface
> > > > +			 */
> > > > +			if (edac_mce_parse(mce))
> > > > +				return;
> > > 
> > > for the third time (!): this may run in NMI context and as such does not
> > > obey to normal kernel locking rules and you cannot safely use almost any
> > > kernel resources involving locking. This way, your hook calls into a
> > > module, which is a very bad idea. Please remove that hook and put in the
> > > polling routine or somewhere more appropriate.
> > 
> > I had answered you already, but let me give a more complete explanation.
> > 
> > For sure all the code called at this point should be carefully analyzed. So,
> > let's see the complete implementation:
> > 
> > 1) edac_mce is not a module (see patch 18). So, just calling a routine on
> > edac_mce should be safe, even at NMI;
> 
> no, I mean the ->check_error member - it could call into a module if
> i7core_edac is compiled as such.

Yes, but calling a code inside a module already loaded in memory should work just fine
as calling a builtin code. As the module needs to be loaded first, in order to register
on edac_mce, there's no problem here.

> <snip the obvious non-registered module case>
> 
> > 3) i7core_edac will only start handling mce events after being loaded on memory
> > and registered on edac_mce. If an error occurs before it, normal mce handling
> > will happen;
> > 
> > 4) after registered, edac_mce will call this hook, at i7core_edac:
> > 
> > static int i7core_mce_check_error(void *priv, struct mce *mce)
> > {
> > 	struct mem_ctl_info *mci = priv;
> > 	struct i7core_pvt *pvt = mci->pvt_info;
> > 	unsigned long flags;
> > 
> > 	/*
> > 	 * Just let mcelog handle it if the error is
> > 	 * outside the memory controller
> > 	 */
> > 	if (((mce->status & 0xffff) >> 7) != 1)
> > 		return 0;
> > 
> > 	/* Bank 8 registers are the only ones that we know how to handle */
> > 	if (mce->bank != 8)
> > 		return 0;
> > 
> > 	/* Only handle if it is the right mc controller */
> > 	if (cpu_data(mce->cpu).phys_proc_id != pvt->i7core_dev->socket) {
> > 		debugf0("mc%d: ignoring mce log for socket %d. "
> > 			"Another mc should get it.\n",
> > 			pvt->i7core_dev->socket,
> > 			cpu_data(mce->cpu).phys_proc_id);
> > 			return 0;
> > 	}
> 
> One problem here is the debug call which is a printk() and you may
> deadlock while doing a printk in an NMI context. That's why you add MCEs
> to the lockless buffer in mce_log and decode them later - otherwise you
> could just as well printk them here.

That debug code can just be dropped. Anyway, this code disaperars if EDAC_DEBUG
is disabled.

> Generally, you need to keep the NMI handlers as short as possible and
> postpone the parsing of the MCEs for later.

True. The parser is outside the NMI called routine (except for UE, since you
may not have a chance of parsing the error outside it, as panic is called on
mce code).

-- 

Cheers,
Mauro
