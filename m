Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbZLNE0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbZLNE0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 23:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZLNE0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 23:26:12 -0500
Received: from ozlabs.org ([203.10.76.45]:39799 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbZLNE0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 23:26:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adam Litke <agl@us.ibm.com>
Subject: Re: [PATCH] virtio: Fix scheduling while atomic in virtio_balloon stats
Date: Mon, 14 Dec 2009 14:56:02 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: Anthony Liguori <aliguori@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
References: <1260484515.4860.2.camel@aglitke>
In-Reply-To: <1260484515.4860.2.camel@aglitke>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912141456.03033.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 09:05:15 am Adam Litke wrote:
> [PATCH] virtio: Fix scheduling while atomic in virtio_balloon stats
> 
> This is a fix for my earlier patch: "virtio: Add memory statistics reporting to
> the balloon driver (V4)".
> 
> I discovered that all_vm_events() can sleep and therefore stats collection
> cannot be done in interrupt context.  One solution is to handle the interrupt
> by noting that stats need to be collected and waking the existing vballoon
> kthread which will complete the work via stats_handle_request().  Rusty, is
> this a saner way of doing business?

I think so.

> There is one issue that I would like a broader opinion on.  In stats_request, I
> update vb->need_stats_update and then wake up the kthread.  The kthread uses
> vb->need_stats_update as a condition variable.  Do I need a memory barrier
> between the update and wake_up to ensure that my kthread sees the correct
> value?  My testing suggests that it is not needed but I would like some
> confirmation from the experts.

Yep:

 * It may be assumed that this function implies a write memory barrier before
 * changing the task state if and only if any tasks are woken up.

> +static void stats_handle_request(struct virtio_balloon *vb)
> +{
> +	struct virtqueue *vq;
> +	struct scatterlist sg;
>  
> +	vb->need_stats_update = 0;
>  	update_balloon_stats(vb);

And this works without a barrier because they can't make another request
before we finish with this one.

Applied,
Rusty.

