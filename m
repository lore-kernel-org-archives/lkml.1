Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYHASTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYHASTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYHASTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:19:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbYHASTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:19:31 -0400
Date: Fri, 1 Aug 2008 11:18:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Neil Brown <neilb@suse.de>, Arthur Jones <ajones@riverbed.com>,
       Dan Williams <dan.j.williams@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PULL REQUEST] md bug fixes and minor improvements
In-Reply-To: <20080801172231.GF20055@kernel.dk>
Message-ID: <alpine.LFD.1.10.0808011115050.3277@nehalem.linux-foundation.org>
References: <18578.31924.259887.735206@notabene.brown> <alpine.LFD.1.10.0808011007240.3277@nehalem.linux-foundation.org> <20080801172231.GF20055@kernel.dk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Aug 2008, Jens Axboe wrote:
> +			spin_lock_irq(&bitmap->mddev->queue->queue_lock);
>  			blk_plug_device(bitmap->mddev->queue);
> +			spin_unlock_irq(&bitmap->mddev->queue->queue_lock);

Can we please not have a chain of three dereferences in a row like that? 
That's an almost certain sign that we should either have a helper function 
or just a variable, and do it as

	queue = bitmap->mddev->queue;

	spin_lock_irq(&queue->queue_lock);
	blk_plug_device(queue);
	spin_unlock_irq(&queue->queue_lock);

Hmm? Perhaps the helper function is cleaner, ie

	static inline blk_plug_device_unlocked(struct request_queue * queue)
	{..

instead. That, of course, would have to use spin_lock_irqsave().

			Linus
