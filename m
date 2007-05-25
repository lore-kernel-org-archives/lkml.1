Return-Path: <linux-kernel-owner+w=401wt.eu-S1762762AbXEYMyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762762AbXEYMyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbXEYMy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:54:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4722 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757353AbXEYMy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:54:28 -0400
Date: Fri, 25 May 2007 22:54:13 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rmmod e1000 hangs (Was Re: 2.6.22-rc2-mm1)
Message-ID: <20070525125413.GA29433@gondor.apana.org.au>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46556AA6.7040503@goop.org> <20070524104713.GA9174@gondor.apana.org.au> <20070524105403.GA9285@gondor.apana.org.au> <4655A4CD.8010901@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4655A4CD.8010901@intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 07:44:29AM -0700, Kok, Auke wrote:
>
> I get the feeling that a recent change exposed us to this, our lab has been 
> seeing similar OOPS's yesterday out of nothing.

Yep you're right.  It was the change where we removed the
netif_poll_enable call from e1000_open.  The problem is that
e1000_close calls e1000_down which in turn calls netif_poll_disable.
That means the next e1000_open won't reenable polling and the
dev_close (or in fact any call to netif_poll_disable) after that
will hang.

In fact my original premise is completely wrong since netif_poll_enable
can be safely called from dev_open *if* you can guarantee that no polls
have already been scheduled.

This should be the case as long as we keep IRQs disabled before
netif_poll_enable.  So the problem is that somehow we're getting
into e1000_open with IRQs enabled on the NIC which then causes a
poll to be scheduled before the call to netif_poll_enable.

So please revert my patch.

We need to find out why we're getting IRQs before calling
e1000_irq_enable in e1000_open.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
