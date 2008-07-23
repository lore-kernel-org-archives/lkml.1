Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYGWIt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYGWIt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 04:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYGWIts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 04:49:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:10209 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYGWItq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 04:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uAA+84POpcnufFi5BG1PPFTx20Ze4XS7iKY5TnRtJqiEuBVF5SyKYSpCryKcNUoU1F
         8EuHJJw90br2Df7cK8E+FLg2EdZXSu/LF4vitZlUlL0z5OhiTBX7B7rh9agWDU9f/dae
         u58sjhh3kastJIboo1/fOT/gaX517XN1jnjWs=
Date: Wed, 23 Jul 2008 08:54:52 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Larry.Finger@lwfinger.net, kaber@trash.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       peterz@infradead.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080723085452.GB4561@ff.dom.local>
References: <20080722.160409.216536011.davem@davemloft.net> <20080723062036.GA4561@ff.dom.local> <20080723.005921.113868915.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723.005921.113868915.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 12:59:21AM -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Wed, 23 Jul 2008 06:20:36 +0000
> 
> > PS: if there is nothing new in lockdep the classical method would
> > be to change this static array:
> > 
> > static struct lock_class_key
> > netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)];
> > 
> > to
> > 
> > static struct lock_class_key
> > netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)][MAX_NUM_TX_QUEUES];
> > 
> > and set lockdep classes per queue as well. (If we are sure we don't
> > need lockdep subclasses anywhere this could be optimized by using
> > one lock_class_key per 8 queues and spin_lock_nested()).
> 
> Unfortunately MAX_NUM_TX_QUEUES is USHORT_MAX, so this isn't really
> a feasible approach.

Is it used by real devices already? Maybe for the beginning we could
start with something less?

> spin_lock_nested() isn't all that viable either, as the subclass
> limit is something like 8.

This method would need to do some additional counting: depending of
a queue number each 8 subsequent queues share (are set to) the same
class and their number mod 8 gives the subqueue number for
spin_lock_nested().

I'll try to find if there is something new around this in lockdep.
(lockdep people added to CC.)

Jarek P.
