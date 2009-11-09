Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZKIL7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZKIL7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZKIL7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:59:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbZKIL7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:59:18 -0500
Date: Mon, 9 Nov 2009 13:55:48 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, s.hetze@linux-ag.com,
       Daniel Walker <dwalker@fifo99.com>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv8 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20091109115548.GA2368@redhat.com>
References: <cover.1257349249.git.mst@redhat.com> <200911061529.17500.rusty@rustcorp.com.au> <20091108113516.GA19016@redhat.com> <200911091647.29655.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911091647.29655.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 04:47:29PM +1030, Rusty Russell wrote:
> Actually, this looks wrong to me:
> 
> +	case VHOST_SET_VRING_BASE:
> ...
> +		vq->avail_idx = vq->last_avail_idx = s.num;
> 
> The last_avail_idx is part of the state of the driver.  It needs to be saved
> and restored over susp/resume.  The only reason it's not in the ring itself
> is because I figured the other side doesn't need to see it (which is true, but
> missed debugging opportunities as well as man-in-the-middle issues like this
> one).  I had a patch which put this field at the end of the ring, I might
> resurrect it to avoid this problem.  This is backwards compatible with all
> implementations.  See patch at end.
> 
> I would drop avail_idx altogether: get_user is basically free, and simplifies
> a lot.  As most state is in the ring, all you need is an ioctl to save/restore
> the last_avail_idx.

I remembered another reason for caching head in avail_idx.  Basically,
avail index could change between when I poll for descriptors and when I
want to notify guest.

So we could have:
	- poll descriptors until empty
	- notify
		detects not empty so does not notify

And the way to solve it would be to return flag from
notify telling us to restart the polling loop.

But, this will be more code, on data path, than
what happens today where I simply keep state
from descriptor polling and use that to notify.

I also suspect that somehow this race in practice can not create
deadlocks ... but I prefer to avoid it, these things are very tricky: if
I see an empty ring, and stop processing descriptors, I want to trigger
notify on empty.

So if we want to avoid keeping "empty" state, IMO the best way would be
to pass a flag to vhost_signal that tells it that ring is empty.
Makes sense?

-- 
MST
