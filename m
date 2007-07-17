Return-Path: <linux-kernel-owner+w=401wt.eu-S934819AbXGQWLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934819AbXGQWLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbXGQWK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:10:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50143 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757991AbXGQWK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:10:56 -0400
Message-ID: <469D3E66.3010502@garzik.org>
Date: Tue, 17 Jul 2007 18:10:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by warnings
References: <20070717214239.GF28448@devserv.devel.redhat.com> <ada8x9epuip.fsf@cisco.com>
In-Reply-To: <ada8x9epuip.fsf@cisco.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  >     drivers/infiniband/hw/mthca/mthca_qp: kill uninit'd var warning
>  >     
>  >     drivers/infiniband/hw/mthca/mthca_qp.c: In function
>  >       ‘mthca_tavor_post_send’:
>  >     drivers/infiniband/hw/mthca/mthca_qp.c:1594: warning: ‘f0’ may be used
>  >       uninitialized in this function
>  >     drivers/infiniband/hw/mthca/mthca_qp.c: In function
>  >       ‘mthca_arbel_post_send’:
>  >     drivers/infiniband/hw/mthca/mthca_qp.c:1949: warning: ‘f0’ may be used
>  >       uninitialized in this function
>  >     
>  >     Initializing 'f0' is not strictly necessary in either case, AFAICS.
>  >     
>  >     I was considering use of uninitialized_var(), but looking at the
>  >     complex flow of control in each function, I feel it is wiser and
>  >     safer to simply zero the var and be certain of ourselves.
>  >     
>  >     Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> I don't really like this.  These functions are in the hottest, most
> latency-sensitive code path of this driver, which is used by people
> who care about nanoseconds.  I'm quite confident that the code is
> correct as written, and it really feels wrong to me to add bloat to
> the fastpath just to cover up a shortcoming of gcc.

I don't buy that performance argument, in this case.  You are already 
dirtying the same cacheline with other variable initializations.

Like I noted in the changeset description (hey, this is precisely why I 
included it, so that we could have this discussion), IMO the flow of 
control makes it not only impossible for the compiler to understand the 
full value range of 'f0', but also difficult for humans as well.

I could perhaps understand initializing the variable to some poison 
value rather than zero, but IMO the code is stronger with f0 set to a 
sane value.

It's poorly readable, poorly commented code as-is.

	Jeff



