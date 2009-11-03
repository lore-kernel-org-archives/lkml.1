Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZKCSFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZKCSFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZKCSFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:05:44 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:48731 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbZKCSFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:05:43 -0500
Message-ID: <4AF0708B.4020406@gmail.com>
Date: Tue, 03 Nov 2009 19:03:55 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, Rusty Russell <rusty@rustcorp.com.au>,
       s.hetze@linux-ag.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv7 3/3] vhost_net: a kernel-level virtio server
References: <cover.1257267892.git.mst@redhat.com> <20091103172422.GD5591@redhat.com>
In-Reply-To: <20091103172422.GD5591@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 03 Nov 2009 19:04:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin a écrit :
> +static void handle_tx(struct vhost_net *net)
> +{
> +	struct vhost_virtqueue *vq = &net->dev.vqs[VHOST_NET_VQ_TX];
> +	unsigned head, out, in, s;
> +	struct msghdr msg = {
> +		.msg_name = NULL,
> +		.msg_namelen = 0,
> +		.msg_control = NULL,
> +		.msg_controllen = 0,
> +		.msg_iov = vq->iov,
> +		.msg_flags = MSG_DONTWAIT,
> +	};
> +	size_t len, total_len = 0;
> +	int err, wmem;
> +	size_t hdr_size;
> +	struct socket *sock = rcu_dereference(vq->private_data);
> +	if (!sock)
> +		return;
> +
> +	wmem = atomic_read(&sock->sk->sk_wmem_alloc);
> +	if (wmem >= sock->sk->sk_sndbuf)
> +		return;
> +
> +	use_mm(net->dev.mm);
> +	mutex_lock(&vq->mutex);
> +	vhost_no_notify(vq);
> +

using rcu_dereference() and mutex_lock() at the same time seems wrong, I suspect
that your use of RCU is not correct.

1) rcu_dereference() should be done inside a read_rcu_lock() section, and
   we are not allowed to sleep in such a section.
   (Quoting Documentation/RCU/whatisRCU.txt :
     It is illegal to block while in an RCU read-side critical section, )

2) mutex_lock() can sleep (ie block)

