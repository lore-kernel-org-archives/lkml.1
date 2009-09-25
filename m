Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZIYMMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZIYMMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 08:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZIYMME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 08:12:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZIYMMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 08:12:03 -0400
Date: Fri, 25 Sep 2009 09:11:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 17/63] edac_mce: Add an interface driver to report mce
 errors via edac
Message-ID: <20090925091130.14135879@pedra.chehab.org>
In-Reply-To: <20090925094855.GA29551@aftab>
References: <20090924192727.212ce46f@pedra.chehab.org>
	<20090925094855.GA29551@aftab>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

Em Fri, 25 Sep 2009 11:48:55 +0200
Borislav Petkov <borislav.petkov@amd.com> escreveu:

> >  		entry = rcu_dereference(mcelog.next);
> >  		for (;;) {
> >  			/*
> > +			 * If edac_mce is enabled, it will check the error type
> > +			 * and will process it, if it is a known error.
> > +			 * Otherwise, the error will be sent through mcelog
> > +			 * interface
> > +			 */
> > +			if (edac_mce_parse(mce))
> > +				return;
> 
> for the third time (!): this may run in NMI context and as such does not
> obey to normal kernel locking rules and you cannot safely use almost any
> kernel resources involving locking. This way, your hook calls into a
> module, which is a very bad idea. Please remove that hook and put in the
> polling routine or somewhere more appropriate.

I had answered you already, but let me give a more complete explanation.

For sure all the code called at this point should be carefully analyzed. So,
let's see the complete implementation:

1) edac_mce is not a module (see patch 18). So, just calling a routine on
edac_mce should be safe, even at NMI;

2) While there's nobody registered on edac_mce, it will just return 0, letting
the code proceed. There's no lock there. The called code is as simple as:

int edac_mce_parse(struct mce *mce)
{
	struct edac_mce *edac_mce;

	list_for_each_entry(edac_mce, &edac_mce_list, list) {
		if (edac_mce->check_error(edac_mce->priv, mce))
			return 1;
	}

	/* Nobody queued the error */
	return 0;
}

3) i7core_edac will only start handling mce events after being loaded on memory
and registered on edac_mce. If an error occurs before it, normal mce handling
will happen;

4) after registered, edac_mce will call this hook, at i7core_edac:

static int i7core_mce_check_error(void *priv, struct mce *mce)
{
	struct mem_ctl_info *mci = priv;
	struct i7core_pvt *pvt = mci->pvt_info;
	unsigned long flags;

	/*
	 * Just let mcelog handle it if the error is
	 * outside the memory controller
	 */
	if (((mce->status & 0xffff) >> 7) != 1)
		return 0;

	/* Bank 8 registers are the only ones that we know how to handle */
	if (mce->bank != 8)
		return 0;

	/* Only handle if it is the right mc controller */
	if (cpu_data(mce->cpu).phys_proc_id != pvt->i7core_dev->socket) {
		debugf0("mc%d: ignoring mce log for socket %d. "
			"Another mc should get it.\n",
			pvt->i7core_dev->socket,
			cpu_data(mce->cpu).phys_proc_id);
			return 0;
	}

	spin_lock_irqsave(&pvt->mce_lock, flags);
        if (pvt->mce_count < MCE_LOG_LEN) {
		memcpy(&pvt->mce_entry[pvt->mce_count], mce, sizeof(*mce));
		pvt->mce_count++;
	}
	spin_unlock_irqrestore(&pvt->mce_lock, flags);

	/* Handle fatal errors immediately */
	if (mce->mcgstatus & 1)
		i7core_check_error(mci);

	/* Advice mcelog that the error were handled */
	return 1;
}

It will basically check if the error is related to the MC, returning if not. If
the error is for the mc, it will copy the error inside a buffer on i7core_mce. 

In this part, it is currently using a spinlock. It might have used an RCU code
instead, but I opted to use a simpler approach, since, on all tests, this worked fine.

Iff the error is a fatal error (Uncorrected Error), it will call the EDAC UE routine
to to display the error. For all Corrected Errors, like the mce driver, the code that
will parse the error will be called outside NMI, by edac polling code.

5) there are very few calls to kernel routines here: list_for_each_entry(),
spin_lock_irqsave(), in_unlock_irqrestore(), memcpy(). I don't think any of them will
have any problems on working even inside NMI context.

-- 

Cheers,
Mauro
