Return-Path: <linux-kernel-owner+w=401wt.eu-S932370AbXCVNqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbXCVNqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbXCVNqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:46:14 -0400
Received: from brick.kernel.dk ([62.242.22.158]:24531 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370AbXCVNqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:46:13 -0400
Date: Thu, 22 Mar 2007 14:42:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
Message-ID: <20070322134230.GP19922@kernel.dk>
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local> <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322144210.73dfaf83.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22 2007, Eric Dumazet wrote:
> On Thu, 22 Mar 2007 12:37:54 +0100
> Tomas M <tomas@slax.org> wrote:
> 
> > The question is not "Why do we need more than 255 loops?".
> > The question should be "Why do we need the hardcoded 255-limit in kernel 
> > while there is no reason for it at all?"
> > 
> > My patch simply removes the hardcoded limitation.
> 
> Hello Tomas, welcome !
> 
> Well, its an attempt to remove a hardcoded limit, but as you said in the Changelog, it really depends on kmalloc() being able to allocate a large continous memory zone. Alas it might fail.
> The golden rule is to avoid all allocations larger than PAGE_SIZE :)
> 
> On x86_64, sizeof(struct loop_device) is 368, so the 'new limit' would be 356 instead of 256...
> 
> You might want a more radical patch : 
> 
> Instead of using :
> 
> static struct loop_device *loop_dev;
> loop_dev = kmalloc(max_loop * sizeof(struct loop_device));
> 
> Switch to :
> 
> static struct loop_device **loop_dev;
> loop_dev = kmalloc(max_loop * sizeof(void *));
> if (!loop_dev) rollback...
> for (i = 0 ; i < max_loop ; i++) {
> 	loop_dev[i] = kmalloc(sizeof(struct loop_device));
> 	if (!loop_dev[i]) rollback...
> }
> 
> This time, you would be limited to 16384 loop devices on x86_64, 32768 on i386 :)

But this still wastes memory, why not just allocate each loop device
dynamically when it is set up? The current approach is crap, it is just
wasting memory for loop devices, queues, etc.

-- 
Jens Axboe

