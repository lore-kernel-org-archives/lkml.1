Return-Path: <linux-kernel-owner+w=401wt.eu-S1751217AbZDBPlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbZDBPlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZDBPlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:41:04 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:40756 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752162AbZDBPlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:41:01 -0400
Date: Thu, 2 Apr 2009 23:40:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, anthony@codemonkey.ws,
       andi@firstfloor.org, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, netdev@vger.kernel.org,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402154041.GA1774@gondor.apana.org.au>
References: <20090402085253.GA29932@gondor.apana.org.au> <49D487A6.407@redhat.com> <49D49C1F.6030306@novell.com> <200904022243.21088.rusty@rustcorp.com.au> <49D4B4A3.5070008@novell.com> <49D4B87D.2000202@redhat.com> <20090402145018.GA816@gondor.apana.org.au> <49D4D301.2090209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4D301.2090209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 06:00:17PM +0300, Avi Kivity wrote:
>
> Good point - if we rely on having excess cores in the host, large guest  
> scalability will drop.

Going back to TX mitigation, I wonder if we could avoid it altogether
by having a "wakeup" mechanism that does not involve a vmexit.  We
have two cases:

1) UP, or rather guest runs on the same core/hyperthread as the
backend.  This is the easy one, the guest simply sets a marker
in shared memory and keeps going until its time is up.  Then the
backend takes over, and uses a marker for notification too.

The markers need to be interpreted by the scheduler so that it
knows the guest/backend is runnable, respectively.

2) The guest and backend runs on two cores/hyperthreads.  We'll
assume that they share caches as otherwise mitigation is the last
thing to worry about.  We use the same marker mechanism as above.
The only caveat is that if one core/hyperthread is idle, its
idle thread needs to monitor the marker (this would be a separate
per-core marker) to wake up the scheduler.

CCing Ingo so that he can flame me if I'm totally off the mark.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
