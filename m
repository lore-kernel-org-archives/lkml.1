Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbXCRUOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbXCRUOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXCRUOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:14:06 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:43811 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933168AbXCRUOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:14:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=AMPD3Sx77cyeyw1IZcY/r8sDmKA2/kP+H7gZMBNj0l/uPtiYBCh82felAQM4WLvNgK2SsSLE7kJz+GDqAn/ei3OFLLizAEv8uw3FZh6Mg3Ec+AzBYvPb0iZVLEj3WTN9UT9y69Oc4yZcocVRIl6WskUV6ZLJZTuZ+BGCv59UZNI=;
Date: Sun, 18 Mar 2007 22:12:38 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070318191238.GA20518@ms2.inr.ac.ru>
References: <20070318155532.GG7958@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318155532.GG7958@mellanox.co.il>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> This is not new code, and should have triggered long time ago,
> so I am not sure how come we are triggering this only now,
> but somehow this did not lead to crashes in 2.6.20

I see. I guess this was plain luck.


> Why is neighbour->dev changed here?

It holds reference to device and prevents its destruction.
If dst is held somewhere, we cannot destroy the device and deadlock
while unregister.

We could not invalidate dst->neighbour but it looked safe to invalidate
neigh->dev after quiescent state. Obviosuly, it is not and it never was safe.
Was supposed to be repaired asap, but this did not happen. :-(


> Can dst->neighbour be changed to point to NULL instead, and the neighbour
> released?

It should be cleared and we should be sure it will not be destroyed
before quiescent state.

Seems, this is the only correct solution, but to do this we have
to audit all the places where dst->neighbour is dereferenced for
RCU safety.

Actually, it is very good you caught this eventually, the bug was
so _disgusting_ that it was "forgotten" all the time, waiting for
someone who will point out that the king is naked. :-)

Alexey
