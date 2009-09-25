Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbZIYN4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbZIYN4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 09:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZIYN4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 09:56:31 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26836 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZIYN4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 09:56:31 -0400
X-SpamScore: -13
X-BigFish: VPS-13(z34a4jz1432R98dNzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQJ5DN-01-9K7-02
X-M-MSG: 
Date: Fri, 25 Sep 2009 15:56:26 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 17/63] edac_mce: Add an interface driver to report mce
 errors via edac
Message-ID: <20090925135626.GA8145@aftab>
References: <20090924192727.212ce46f@pedra.chehab.org>
 <20090925094855.GA29551@aftab>
 <20090925091130.14135879@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090925091130.14135879@pedra.chehab.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 25 Sep 2009 13:56:10.0683 (UTC) FILETIME=[F00130B0:01CA3DE7]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 25, 2009 at 09:11:30AM -0300, Mauro Carvalho Chehab wrote:
> > >  		entry = rcu_dereference(mcelog.next);
> > >  		for (;;) {
> > >  			/*
> > > +			 * If edac_mce is enabled, it will check the error type
> > > +			 * and will process it, if it is a known error.
> > > +			 * Otherwise, the error will be sent through mcelog
> > > +			 * interface
> > > +			 */
> > > +			if (edac_mce_parse(mce))
> > > +				return;
> > 
> > for the third time (!): this may run in NMI context and as such does not
> > obey to normal kernel locking rules and you cannot safely use almost any
> > kernel resources involving locking. This way, your hook calls into a
> > module, which is a very bad idea. Please remove that hook and put in the
> > polling routine or somewhere more appropriate.
> 
> I had answered you already, but let me give a more complete explanation.
> 
> For sure all the code called at this point should be carefully analyzed. So,
> let's see the complete implementation:
> 
> 1) edac_mce is not a module (see patch 18). So, just calling a routine on
> edac_mce should be safe, even at NMI;

no, I mean the ->check_error member - it could call into a module if
i7core_edac is compiled as such.

<snip the obvious non-registered module case>

> 3) i7core_edac will only start handling mce events after being loaded on memory
> and registered on edac_mce. If an error occurs before it, normal mce handling
> will happen;
> 
> 4) after registered, edac_mce will call this hook, at i7core_edac:
> 
> static int i7core_mce_check_error(void *priv, struct mce *mce)
> {
> 	struct mem_ctl_info *mci = priv;
> 	struct i7core_pvt *pvt = mci->pvt_info;
> 	unsigned long flags;
> 
> 	/*
> 	 * Just let mcelog handle it if the error is
> 	 * outside the memory controller
> 	 */
> 	if (((mce->status & 0xffff) >> 7) != 1)
> 		return 0;
> 
> 	/* Bank 8 registers are the only ones that we know how to handle */
> 	if (mce->bank != 8)
> 		return 0;
> 
> 	/* Only handle if it is the right mc controller */
> 	if (cpu_data(mce->cpu).phys_proc_id != pvt->i7core_dev->socket) {
> 		debugf0("mc%d: ignoring mce log for socket %d. "
> 			"Another mc should get it.\n",
> 			pvt->i7core_dev->socket,
> 			cpu_data(mce->cpu).phys_proc_id);
> 			return 0;
> 	}

One problem here is the debug call which is a printk() and you may
deadlock while doing a printk in an NMI context. That's why you add MCEs
to the lockless buffer in mce_log and decode them later - otherwise you
could just as well printk them here.

Generally, you need to keep the NMI handlers as short as possible and
postpone the parsing of the MCEs for later.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

