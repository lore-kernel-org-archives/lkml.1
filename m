Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYFYORr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYFYORr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYFYORj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:17:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:15340 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYFYORh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ssDrEuKzw0+IFkgMllTawQYpAuAScwZJ+cWZRZ1Md+CgXytAuUVTmhL66w0nBGsGsa
         b+5ecTKdSiiU1XLha0LeC03uy8pNYk6y4k1Zy95bVhLuhWtSVbM1JSwcYEgkEOnZccPb
         HTbra1QXo9O31iaHsoLHHRcsK+1UfKzIHsUcQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [3/10 PATCH] inline wake_up_bit
Date: Wed, 25 Jun 2008 16:17:40 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       davem@davemloft.net
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com> <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com> <Pine.LNX.4.64.0806240156230.27784@engineering.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0806240156230.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251617.40871.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 07:57, Mikulas Patocka wrote:
> Inline wake_up_bit. The function just pases arguments around.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
>   int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
> -void wake_up_bit(void *, int);
>   int out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned);

> +static __always_inline void wake_up_bit(void *word, int bit)
> +{
> +	__wake_up_bit(bit_waitqueue(word, bit), word, bit);
> +}

So now every call to wake_up_bit(word, bit) now is converted to:

__wake_up_bit(bit_waitqueue(word, bit), word, bit);

which is in turn converted to (looking into your next patch):

{
       wait_queue_head_t *wq = bit_waitqueue(word, bit);
       struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
       if (waitqueue_active(wq))
               __wake_up(wq, TASK_NORMAL, 1, &key);
}

which is in turn converted to (looking into your other patch):

{
       wait_queue_head_t *wq = bit_waitqueue(word, bit);
       struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
       if (waitqueue_active(wq))
               {
                      unsigned long flags;
                      spin_lock_irqsave(&qw->lock, flags);
                      __wake_up_common(wq, TASK_NORMAL, 1, 0, &key);
                      spin_unlock_irqrestore(&wq->lock, flags);
               }
}

And you know what? This is likely not the end yet! It's possible
spin_lock_irqXXX, __wake_up_common, waitqueue_active or bit_waitqueue
are inlines - I didn't check.
--
vda
