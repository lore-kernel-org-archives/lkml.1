Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbZBTULT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbZBTULT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 15:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZBTULI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 15:11:08 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33958 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbZBTULF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 15:11:05 -0500
Date: Fri, 20 Feb 2009 12:11:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       bert.wesarg@googlemail.com
Subject: Re: [ltt-dev] [PATCH URCU formal] Add liveness checks to
	user-level RCU model.
Message-ID: <20090220201104.GS6960@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220181835.GA4092@Krystal> <20090220192824.GP6960@linux.vnet.ibm.com> <20090220194621.GA7349@Krystal> <20090220195345.GA7801@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220195345.GA7801@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 02:53:45PM -0500, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Fri, Feb 20, 2009 at 01:18:35PM -0500, Mathieu Desnoyers wrote:
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > Break all potentially infinite loops in both urcu_reader() and
> > > > > urcu_updater(), ensure that urcu_reader() will process any memory barriers
> > > > > that urcu_updater() might issue, and formulate a "never" claim that checks
> > > > > to make sure that if either urcu_reader() or urcu_updater() completes,
> > > > > then the other will eventually also complete.  Since urcu_reader()
> > > > > now has a finite number of steps, it must eventually complete.
> > > > > 
> > > > > Also replace the code at the end of urcu_reader() that previously absorbed
> > > > > late memory-barrier requests from urcu_updater with code in urcu_writer()
> > > > > that checks to see if urcu_reader() has completed.
> > > > > 
> > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > Thanks Paul, I'll merge it. However, I am currently reworking our spin
> > > > tree so we can execute the tests in batch (rather that all at once,
> > > > which consumes more memory than necessary) and also I am doing a nice
> > > > build script which lets us create our own LTL formulaes for
> > > > verification. The never claims will be automatically generated and
> > > > verified. I'll keep you posted.
> > > 
> > > Sounds interesting!  Not sure what you mean by "execute the tests
> > > in batch", but look forward to seeing it.
> > > 
> > > On the LTL, the formula "<>[] (reader_done != 0 && updater_done != 0)"
> > > didn't do what I want.  The model would kick out an error with the
> > > reader sitting just before the "reader_done = 1" and the updater spinning
> > > waiting for the reader to respond to its memory-barrier request.
> > > 
> > > So I fell back to the hand-coded formula in the never clause, which
> > > translates to English as "if either the reader or the updater complete,
> > > then both the reader and the updater eventually complete".  There might
> > > be a way to tranlate that into LTL, but I didn't immediately see one.
> > > 
> > > This morning I tried the weak fairness constraints (the "-f" argument
> > > to ./pan) and that did allow LTL to do what I want, as shown in the
> > > following patch (applied on top of my earlier patch).
> > > 
> > > I must confess that LTL is at best an acquired taste for me.
> > > "Let's see...  '<>[](!reader_done || !updater_done)'...
> > > That means eventually we always must have neither the reader or the
> > > updater being done.  Huh???  Oh, yeah, this is supposed to say what
> > > -cannot- happen..."  At this point, I have an easier time with the
> > > hand-coded "never" claims.  ;-)
> > > 
> > > But I am quite happy to leave further hacking on this model in
> > > your capable hands.  The other item on my todo list was making the
> > > urcu_mbmin.spin model accurately handle omission of additional memory
> > > barriers.  Are you willing to take that on as well?
> > > 
> > 
> > I'll first get the translation of asserts into LTL formulaes, and try to
> > see what should be fixed in the model. I have noticed that we would need
> > to do this :
> > 
> > urcu_gp_ctr = (urcu_gp_ctr + RCU_GP_CTR_BIT) % (RCU_GP_CTR_BIT + 1);
> urcu_gp_ctr = urcu_gp_ctr ^ RCU_GP_CTR_BIT;
> 
> is actually much nicer..

Good point -- I was forgetting that Promela supports "^".

							Thanx, Paul

> MAthieu
> > 
> > Otherwise the overflow does not do what we expect (spin -f on the trail
> > told me that it was overflowing to 1, which is not exactly what we want
> > I guess). More to come on that side. When this will be settled, I'll dig
> > further.
> > 
> > Mathieu
> > 
> > 
> > > 							Thanx, Paul
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > ---
> > > 
> > >  urcu.sh   |    4 ++--
> > >  urcu.spin |   12 ------------
> > >  2 files changed, 2 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/formal-model/urcu.sh b/formal-model/urcu.sh
> > > index 5e525ec..3a6850c 100644
> > > --- a/formal-model/urcu.sh
> > > +++ b/formal-model/urcu.sh
> > > @@ -20,6 +20,6 @@
> > >  #
> > >  # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > >  
> > > -spin -a urcu.spin 
> > > +spin -a -f '<>[](!reader_done || !updater_done)' urcu.spin
> > >  cc -o pan pan.c
> > > -./pan -a
> > > +./pan -a -f
> > > diff --git a/formal-model/urcu.spin b/formal-model/urcu.spin
> > > index cf1f670..851eb50 100644
> > > --- a/formal-model/urcu.spin
> > > +++ b/formal-model/urcu.spin
> > > @@ -280,15 +280,3 @@ init {
> > >  		run urcu_updater();
> > >  	}
> > >  }
> > > -
> > > -/* Require that both reader and updater eventually get done. */
> > > -
> > > -never {
> > > -	do
> > > -	:: skip;
> > > -	:: reader_done != 0 || updater_done != 0 -> break;
> > > -	od;
> > > -accept:	do
> > > -	:: reader_done == 0 || updater_done == 0;
> > > -	od;
> > > -}
> > > 
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> > _______________________________________________
> > ltt-dev mailing list
> > ltt-dev@lists.casi.polymtl.ca
> > http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
