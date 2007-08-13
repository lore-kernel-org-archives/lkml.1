Return-Path: <linux-kernel-owner+w=401wt.eu-S1030412AbXHMMVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412AbXHMMVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966169AbXHMGoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:44:12 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:57390
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S967796AbXHMGoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:44:09 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Block device throttling [Re: Distributed storage.]
Date: Sun, 12 Aug 2007 23:44:00 -0700
User-Agent: KMail/1.9.5
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20070731171347.GA14267@2ka.mipt.ru> <20070808095448.GA3440@2ka.mipt.ru> <200708122236.24096.phillips@phunq.net>
In-Reply-To: <200708122236.24096.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708122344.00343.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 22:36, I wrote:
> Note!  There are two more issues I forgot to mention earlier.

Oops, and there is also:

3) The bio throttle, which is supposed to prevent deadlock, can itself 
deadlock.  Let me see if I can remember how it goes.

  * generic_make_request puts a bio in flight
  * the bio gets past the throttle and initiates network IO
  * net calls sk_alloc->alloc_pages->shrink_caches
  * shrink_caches submits a bio recursively to our block device
  * this bio blocks on the throttle
  * net may never get the memory it needs, and we are wedged

I need to review a backtrace to get this precisely right, however you 
can see the danger.  In ddsnap we kludge around this problem by not 
throttling any bio submitted in PF_MEMALLOC mode, which effectively 
increases our reserve requirement by the amount of IO that mm will 
submit to a given block device before deciding the device is congested 
and should be left alone.  This works, but is sloppy and disgusting.

The right thing to do is to make sure than the mm knows about our 
throttle accounting in backing_dev_info so it will not push IO to our 
device when it knows that the IO will just block on congestion.  
Instead, shrink_caches will find some other less congested block device 
or give up, causing alloc_pages to draw from the memalloc reserve to 
satisfy the sk_alloc request.

The mm already uses backing_dev_info this way, we just need to set the 
right bits in the backing_dev_info state flags.  I think Peter posted a 
patch set that included this feature at some point.

Regards,

Daniel
