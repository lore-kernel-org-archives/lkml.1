Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYGWJaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYGWJaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 05:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYGWJ3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 05:29:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:11671 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYGWJ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eMGhCfPjhaA7e573+wst1N16cmG0X0NkJ7U/q0jC6VUMD5yG2Jzs/3ExmButJpehYN
         eqmLnwkozMK2Kg6T0GZubIevTGOqA/ocFTDlzjIObBWuKuS+OZ0OlWkzKvWSr0sWqdcy
         /V6Wm7w+5lS5C2dl3GmqizAeLhJOUgxAuEjmw=
Date: Wed, 23 Jul 2008 09:35:00 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>, Larry.Finger@lwfinger.net,
       kaber@trash.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080723093459.GC4561@ff.dom.local>
References: <20080722.160409.216536011.davem@davemloft.net> <20080723062036.GA4561@ff.dom.local> <20080723.005921.113868915.davem@davemloft.net> <20080723085452.GB4561@ff.dom.local> <1216803786.7257.146.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216803786.7257.146.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 11:03:06AM +0200, Peter Zijlstra wrote:
> On Wed, 2008-07-23 at 08:54 +0000, Jarek Poplawski wrote:
> > On Wed, Jul 23, 2008 at 12:59:21AM -0700, David Miller wrote:
> > > From: Jarek Poplawski <jarkao2@gmail.com>
> > > Date: Wed, 23 Jul 2008 06:20:36 +0000
> > > 
> > > > PS: if there is nothing new in lockdep the classical method would
> > > > be to change this static array:
> > > > 
> > > > static struct lock_class_key
> > > > netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)];
> > > > 
> > > > to
> > > > 
> > > > static struct lock_class_key
> > > > netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)][MAX_NUM_TX_QUEUES];
> > > > 
> > > > and set lockdep classes per queue as well. (If we are sure we don't
> > > > need lockdep subclasses anywhere this could be optimized by using
> > > > one lock_class_key per 8 queues and spin_lock_nested()).
> > > 
> > > Unfortunately MAX_NUM_TX_QUEUES is USHORT_MAX, so this isn't really
> > > a feasible approach.
> > 
> > Is it used by real devices already? Maybe for the beginning we could
> > start with something less?
> > 
> > > spin_lock_nested() isn't all that viable either, as the subclass
> > > limit is something like 8.
> > 
> > This method would need to do some additional counting: depending of
> > a queue number each 8 subsequent queues share (are set to) the same
> > class and their number mod 8 gives the subqueue number for
> > spin_lock_nested().
> > 
> > I'll try to find if there is something new around this in lockdep.
> > (lockdep people added to CC.)
> 
> There isn't.
> 
> Is there a static data structure that the driver needs to instantiate to
> 'create' a queue? Something like:
> 
> /* this imaginary e1000 hardware has 16 hardware queues */
> static struct net_tx_queue e1000e_tx_queues[16]; 

I guess, not.

Then, IMHO, we could be practical and simply skip lockdep validation
for "some" range of locks: e.g. to set the table for the first 256
queues only, and to do e.g. __raw_spin_lock() for bigger numbers. (If
there are any bad locking patterns this should be enough for checking.)

Jarek P.
