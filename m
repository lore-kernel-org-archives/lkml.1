Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYDER1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYDER1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 13:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYDER1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 13:27:05 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:12257 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYDER1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 13:27:03 -0400
Message-ID: <47F7B661.6090606@codemonkey.ws>
Date: Sat, 05 Apr 2008 12:26:57 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 3/5] tun: vringfd receive support.
References: <200804052202.09157.rusty@rustcorp.com.au>	<200804052204.28518.rusty@rustcorp.com.au> <200804052205.43824.rusty__2650.41595926068$1207397436$gmane$org@rustcorp.com.au>
In-Reply-To: <200804052205.43824.rusty__2650.41595926068$1207397436$gmane$org@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> This patch modifies tun to allow a vringfd to specify the receive
> buffer.  Because we can't copy to userspace in bh context, we queue
> like normal then use the "pull" hook to actually do the copy.
> 
> More thought needs to be put into the possible races with ring
> registration and a simultaneous close, for example (see FIXME).
> 
> We use struct virtio_net_hdr prepended to packets in the ring to allow
> userspace to receive GSO packets in future (at the moment, the tun
> driver doesn't tell the stack it can handle them, so these cases are
> never taken).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

<snip>

> +
> +#ifdef CONFIG_VRINGFD

I think the rest of the code needs these for it to actually work without 
VRINGFD.

> +static void unset_recv(void *_tun)
> +{
> +	struct tun_struct *tun = _tun;
> +
> +	tun->inring = NULL;
> +}
> +
> +/* Returns number of used buffers, or negative errno. */
> +static int pull_recv_skbs(void *_tun)
> +{
> +	struct tun_struct *tun = _tun;
> +	int err = 0, num_copied = 0;
> +	struct sk_buff *skb;
> +
> +	while ((skb = skb_dequeue(&tun->readq)) != NULL) {
> +		struct iovec iov[1+MAX_SKB_FRAGS];
> +		struct virtio_net_hdr gso = { 0 }; /* no info leak */
> +		unsigned int iovnum = ARRAY_SIZE(iov);
> +		unsigned long len;
> +		int id;
> +
> +		id = vring_get_buffer(tun->inring, iov, &iovnum, &len,
> +				      NULL, NULL, NULL);
> +		if (id <= 0) {
> +			err = id;
> +			break;
> +		}

Ah, I see now why you're passing something from the stack.

Regards,

Anthony Liguori
