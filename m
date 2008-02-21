Return-Path: <linux-kernel-owner+w=401wt.eu-S933508AbYBUUjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbYBUUjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758505AbYBUUi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:38:57 -0500
Received: from brick.kernel.dk ([87.55.233.238]:22529 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598AbYBUUiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:38:55 -0500
Date: Thu, 21 Feb 2008 21:38:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: balbir@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
Message-ID: <20080221203849.GU23197@kernel.dk>
References: <47BD2A99.3010608@linux.vnet.ibm.com> <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com> <20080221090430.GA20055@elte.hu> <47BD44FF.7070104@linux.vnet.ibm.com> <1203586980.6243.124.camel@lappy> <47BD479F.6070901@linux.vnet.ibm.com> <1203588090.6243.128.camel@lappy> <47BD4D48.4080606@linux.vnet.ibm.com> <1203592374.6243.138.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203592374.6243.138.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21 2008, Peter Zijlstra wrote:
> 
> On Thu, 2008-02-21 at 15:37 +0530, Balbir Singh wrote:
> 
> > You use the empty pointer (missing right child), so why do we need a list. May
> > be I am missing something.
> 
> A fully threaded tree also has back-pointer to traverse backwards
> through the ordered elements.
> 
> That said, overloading the right child pointer might not be the best
> thing for the linux kernel, as it will impact all the rb-tree lookups
> which are open-coded and often performance critical (this is the reason
> the colour isn't bit encoded in either of the child pointers either).
> 
> But if you only want a uni directional thread, I guess we can stick it
> in the unsigned long we use for the node colour.
> 
> Still, perhaps it's worth it to grow rb_node to 4 words and do the fully
> threaded thing as there are also a lot of rb_prev() users in the kernel.
> Who knows..
> 
> Anyway, I agree that improving rb_next() is worth looking into for the
> scheduler.

For the IO scheduler as well, it's used quite extensively! So speeding
up rb_next() would definitely help, as it's typically invoked for every
bio queued (attempting to back merge with the next request). CFQ and AS
additionally does an rb_next() and rb_prev() when trying to decide which
request to do next.

-- 
Jens Axboe

