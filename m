Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZHTMzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZHTMzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbZHTMzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:55:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:41722 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbZHTMzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=JnpBC68REdW7ec5qm9E3PiQXHVKApKJXBaaBpeSFLzJ9brHUxXRtXc5fVA72U7v0IJ
         CJNQhfi0vOySpl6XwAptCXhBRV2eyrRtUR0tNA2SHYONlOzaGZTSaB7bH2Zr0jESVV6i
         tJrg7HzHbpOsLM1XRF5r/Fg09e1s2BbnUIX9o=
Message-ID: <4A8D47B8.6070001@gmail.com>
Date: Thu, 20 Aug 2009 21:55:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 0/6] Lazy workqueues
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

Jens Axboe wrote:
> After yesterdays rant on having too many kernel threads and checking
> how many I actually have running on this system (531!), I decided to 
> try and do something about it.

Heh... that's a lot.  How many cpus do you have there?  Care to share
the output of "ps -ef"?

> My goal was to retain the workqueue interface instead of coming up with
> a new scheme that required conversion (or converting to slow_work which,
> btw, is an awful name :-). I also wanted to retain the affinity
> guarantees of workqueues as much as possible.
> 
> So this is a first step in that direction, it's probably full of races
> and holes, but should get the idea across. It adds a
> create_lazy_workqueue() helper, similar to the other variants that we
> currently have. A lazy workqueue works like a normal workqueue, except
> that it only (by default) starts a core thread instead of threads for
> all online CPUs. When work is queued on a lazy workqueue for a CPU
> that doesn't have a thread running, it will be placed on the core CPUs
> list and that will then create and move the work to the right target.
> Should task creation fail, the queued work will be executed on the
> core CPU instead. Once a lazy workqueue thread has been idle for a
> certain amount of time, it will again exit.

Yeap, the approach seems simple and nice and resolves the problem of
too many idle workers.

> The patch boots here and I exercised the rpciod workqueue and
> verified that it gets created, runs on the right CPU, and exits a while
> later. So core functionality should be there, even if it has holes.
> 
> With this patchset, I am now down to 280 kernel threads on one of my test
> boxes. Still too many, but it's a start and a net reduction of 251
> threads here, or 47%!

I'm trying to find out whether the perfect concurrency idea I talked
about on the other thread can be implemented in reasonable manner.
Would you mind holding for a few days before investing too much effort
into expanding this one to handle multiple workers?

Thanks.

-- 
tejun
