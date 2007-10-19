Return-Path: <linux-kernel-owner+w=401wt.eu-S934494AbXJSEuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494AbXJSEuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXJSEuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:50:00 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:26685 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752066AbXJSEt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:49:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NmR1eyObT1KlLhZypiaajqhMAJDNU9qm3Z/FcbRp+4AicJP1wIKGzwiL23WRBEArnTzKNMipu1HeyCMZDf/lSifH+rX1a1etkInNyv5KJ+hz1fTKW1PWvgR2fEb36fgs7VTz46Z/tGhe0wNLX8ArF/u8pHcPADSMDUmlPBenoqs=  ;
X-YMail-OSG: x3mSJtIVM1l5kLyouoNfcQSOBX.L50_v26k522KBnnBKL4pKfQI80pHOK.ecJ3kV6QSyYmN5iQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] synchronize_irq needs a barrier
Date: Fri, 19 Oct 2007 14:49:29 +1000
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, benh@kernel.crashing.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, mingo@elte.hu, tglx@linutronix.de
References: <E1IiiX6-0002V0-00@gondolin.me.apana.org.au>
In-Reply-To: <E1IiiX6-0002V0-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191449.30027.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 13:28, Herbert Xu wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >> First of all let's agree on some basic assumptions:
> >>
> >> * A pair of spin lock/unlock subsumes the effect of a full mb.
> >
> > Not unless you mean a pair of spin lock/unlock as in
> > 2 spin lock/unlock pairs (4 operations).
> >
> > *X = 10;
> > spin_lock(&lock);
> > /* *Y speculatively loaded here */
> > /* store to *X leaves CPU store queue here */
> > spin_unlock(&lock);
> > y = *Y;
>
> Good point.
>
> Although in this case we're still safe because in the worst
> cases:
>
> CPU0				CPU1
> irq_sync = 1
> synchronize_irq
> 	spin lock
> 	load IRQ_INPROGRESS
> irq_sync sync is visible
> 	spin unlock
> 				spin lock
> 					load irq_sync
> 	while (IRQ_INPROGRESS)
> 		wait
> 	return
> 				set IRQ_INPROGRESS
> 				spin unlock
> 				tg3_msi
> 					ack IRQ
> 					if (irq_sync)
> 						return
> 				spin lock
> 				clear IRQ_INPROGRESS
> 				spin unlock
>
> ------------------------------------------------------------
>
> CPU0				CPU1
> 				spin lock
> 					load irq_sync
> irq_sync = 1
> synchronize_irq
> 				set IRQ_INPROGRESS
> 				spin unlock
> 	spin lock
> 	load IRQ_INPROGRESS
> irq_sync sync is visible
> 	spin unlock
> 	while (IRQ_INPROGRESS)
> 		wait
> 				tg3_msi
> 					ack IRQ
> 					if (irq_sync)
> 						return
> 					do work
> 				spin lock
> 				clear IRQ_INPROGRESS
> 				spin unlock
> 	return
>
> So because we're using the same lock on both sides, it does
> do the right thing even without the memory barrier.


Yeah, if you've got the lock on both sides there, then I
agree it will be correct.
