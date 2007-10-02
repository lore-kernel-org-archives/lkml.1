Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbXJBN5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbXJBN5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbXJBN5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:57:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:43511 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbXJBN5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:57:18 -0400
Message-ID: <fa686aa40710020657j1c97a23ejdd3322f5cba3bbb5@mail.gmail.com>
Date: Tue, 2 Oct 2007 07:57:17 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: benh@kernel.crashing.org
Subject: Re: [PATCH v2 5/6] Sysace: Move IRQ handler registration to occur after FSM is initialized
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       axboe@kernel.dk
In-Reply-To: <1191304521.6310.94.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
	 <20070930225726.2476.44211.stgit@trillian.cg.shawcable.net>
	 <1191304521.6310.94.camel@pasglop>
X-Google-Sender-Auth: 18a14586d01f50ec
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/07, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
> On Sun, 2007-09-30 at 16:57 -0600, Grant Likely wrote:
> >         val |= ACE_CTRL_DATABUFRDYIRQ | ACE_CTRL_ERRORIRQ;
> >         ace_out(ace, ACE_CTRL, val);
> >
> > +       /* Now we can hook up the irq handler */
> > +       if (ace->irq != NO_IRQ) {
> > +               rc = request_irq(ace->irq, ace_interrupt, 0,
> > "systemace", ace);
> > +               if (rc) {
> > +                       /* Failure - fall back to polled mode */
> > +                       dev_err(ace->dev, "request_irq failed\n");
> > +                       ace->irq = NO_IRQ;
> > +               }
> > +       }
> > +
>
> I don't know the HW but from the above, it looks like you enable
> interrupt emission on the HW before you register the handler, which is
> wrong. You should make sure on the contrary that IRQs on the HW are
> disabled until after you have registered a handler.
>
> Only really a problem if you have shared interrupts but still...

Yeah, you're right.  Fortunately all current in-tree platforms which
use this do not have shared interrupts, but I'd like to be correct on
this.

I'll tidy this up and send a fixup patch.

Thanks,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
