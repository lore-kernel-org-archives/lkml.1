Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYCNAG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYCNAG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYCNAGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:06:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:49105 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYCNAGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=B8agPN4P/FWtiuivTsQEB4ljblGoB5pZJVxjuQdszCF56DkquURhO1zOD4pKIb+ugJEPjFjZ50MCKIVU508sk5LZYxDneNlYnVZSbSxcdUJkTuNlIGLpspYTVHCxRd2To8cYeNjx3a7CTP5+yamXJuvyPUH7JzOzlAAFwZ8lA6M=
Message-ID: <e9c3a7c20803131706m188f9494m1cdcda8354a65f4e@mail.gmail.com>
Date: Thu, 13 Mar 2008 17:06:19 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Olof Johansson" <olof@lixom.net>
Subject: Re: [PATCH] pasemi_dma: Driver for PA Semi PWRficient on-chip DMAengine
Cc: linuxppc-dev@ozlabs.org, pasemi-linux@ozlabs.org,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com
In-Reply-To: <20080313231442.GA4639@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080306233900.GA3969@lixom.net>
	 <1205255051.26723.19.camel@dwillia2-linux.ch.intel.com>
	 <20080313195431.GA1449@lixom.net>
	 <e9c3a7c20803131529j22db434aqdab0ef6f18891d67@mail.gmail.com>
	 <20080313231442.GA4639@lixom.net>
X-Google-Sender-Auth: 4f1e4d7347b5cbc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 4:14 PM, Olof Johansson <olof@lixom.net> wrote:
>  > Dummy descriptors that do nothing but cause an interrupt is the intent.
>
>  Well, it'd be slightly more efficient to do add the interrupt attribute
>  to the last issued descriptor when it's known in advance. If the
>  underlying driver doesn't support it, adding a separate descriptor would
>  be a good fallback.
>

When it is known in advance the interrupt attribute *is* set,
otherwise the descriptor may already be in flight.

>  Anyway, this isn't likely to be a performance bottleneck. If it turns
>  out to be, I'll refactor it and submit patches.
>

Would not hurt to have another pair of eyes on this part of the code.
A rewrite of the channel switch mechanism is currently pending in
async_tx.git#upstream.

[..]
>  > >  Can't do that if it's called both from the polling as well as the IRQ
>  > >  context, it'd need to hold off irqs. I.e. once I add the DMA_INTERRUPT
>  > >  support it will be needed.
>  > >
>  >
>  > ...do it in a tasklet.
>
>  Why? That just adds overhead and latency.
>

The original ioat_dma code used nothing heavier than spin_lock_bh.
Async_tx now assumes that local_bh_disable prevents races with any
channel's cleanup routine.  Clients can place the same kind of code in
an async_tx callback as they would in a timer callback.  The
assumption is that code using async_tx can afford its extra overhead,
which is true for raid.  This is also why you don't see async_memcpy
calls in net_dma.

--
Dan
