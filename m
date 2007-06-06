Return-Path: <linux-kernel-owner+w=401wt.eu-S934356AbXFFBR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbXFFBR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933190AbXFFBRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:17:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22767 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbXFFBRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:17:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=DkBhHjSMbsva/pEg3sk+DNn9VvaG43DoW/NfylI1y6vLFkbAersEfowy7vnDpQ5HZ
	NfexfyPWYhFaSRFSCUGdQ==
Date: Tue, 5 Jun 2007 18:17:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <20070605165538.0a3ce6fe.pj@sgi.com>
Message-ID: <alpine.DEB.0.99.0706051813070.23799@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com> <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
 <20070605165538.0a3ce6fe.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Paul Jackson wrote:

> Well, I can't speak to the 'real' meaning of TIF_MEMDIE with authority,
> but I can speak to the meaning of cpuset flags.
> 
> The mem_exclusive flag doesn't mean this.
> 
> It means that you cannot overlap the memory of a sibling cpuset.
> 

Which, with this patch, we will respect for tasks marked TIF_MEMDIE as 
well.

> You will, necessarily, still overlap the memory of your ancestor cpusets.
> 

And that's what nearest_exclusive_ancestor() determines later on if we're 
not requesting GFP_HARDWALL.

> Whether or not you make any use of the mem_exclusive flag, you still
> get the same (limited) guarantees of memory usage -- namely that your
> memory won't be used by tasks in non-overlapping cpusets, with some
> exceptions, such as:
>  1) memory handed out to interrupt code,
>  2) memory handed out for GFP_ATOMIC requests, and
>  3) tasks marked PF_EXITING -- will soon free up memory
> 

This is precisely the point: we already respect PF_EXITING tasks with 
their ability to allocate outside their own cpuset.  That gets set in 
do_exit() when a task is in receipt of the SIGKILL from the OOM killer 
during the exit path.  Between these time periods (the time when we issue 
the OOM SIGKILL and the time we're marked PF_EXITING in do_exit()), we 
should not allow allocations outside of our cpuset because we do not yet 
have the guarantee that they will exit synchronously or reliably.

> Tasks in cpusets ancestor to your tasks cpuset can always, easily,
> use memory on the same nodes your task is on.
> 

Sure, that behavior is unchanged.  We're relying on 
nearest_exclusive_ancestor() to determine if such nodes overlap.

		David
