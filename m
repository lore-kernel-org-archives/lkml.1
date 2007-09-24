Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXIXVSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXIXVSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXIXVSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:18:14 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43511 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbXIXVSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:18:13 -0400
Subject: Re: 2.6.23-rc6: hanging ext3 dbench tests
From: Badari Pulavarty <pbadari@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, sct@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, adilger@clusterfs.com,
       ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       mel@csn.ul.ie
In-Reply-To: <alpine.LFD.0.999.0709241243530.3579@woody.linux-foundation.org>
References: <20070911124202.GI9556@shadowen.org>
	 <alpine.LFD.0.999.0709110949250.16478@woody.linux-foundation.org>
	 <20070911173049.GA10499@shadowen.org> <20070914094905.GA32670@shadowen.org>
	 <20070919181546.GA4343@shadowen.org>
	 <1190656918.13955.7.camel@dyn9047017100.beaverton.ibm.com>
	 <alpine.LFD.0.999.0709241243530.3579@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 14:20:45 -0700
Message-Id: <1190668846.13955.15.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 13:04 -0700, Linus Torvalds wrote:
> 
> On Mon, 24 Sep 2007, Badari Pulavarty wrote:
> > 
> > Whats happening on my machine is ..
> > 
> > dbench forks of 4 children and sends them a signal to start the work.
> > 3 out of 4 children gets the signal and does the work. One of the child
> > never gets the signal so, it waits forever in pause(). So, parent waits
> > for a longtime to kill it.
> 
> Since this *seems* to have nothing to do with the filesystem, and since it 
> *seems* to have been introduced between -rc3 and -rc4, I did
> 
> 	gitk v2.6.23-rc3..v2.6.23-rc4 -- kernel/

I was wrong. I managed to reproduce on 2.6.23-rc3, but it took a long
time. But I never reproduced it on 2.6.22. Ran test for a day.

> 
> to see what has changed. One of the commits was signal-related, and that 
> one doesn't look like it could possibly matter.
> 
> The rest were scheduler-related, which doesn't surprise me. In fact, even 
> before I looked, my reaction to your bug report was "That sounds like an 
> application race condition".
> 
> Applications shouldn't use "pause()" for waiting for a signal. It's a 
> fundamentally racy interface - the signal could have happened just 
> *before* calling pause. So it's almost always a bug to use pause(), and 
> any users should be fixed to use "sigsuspend()" instead, which can 
> atomically (and correctly) pause for a signal while the process has masked 
> it outside of the system call.
> 
> Now, I took a look at the dbench sources, and I have to say that the race 
> looks *very* unlikely (there's quite a small window in which it does
> 
> 	children[i].status = getpid();
> 	** race window here **
> 	pause();
> 
> and it would require *just* the right timing so that the parent doesn't 
> end up doing the "sleep(1)" (which would make the window even less likely 
> to be hit), but there does seem to be a race condition there. And it 
> *could* be that you just happen to hit it on your hw setup.
> 
> So before you do anything else, does this patch (TOTALLY UNTESTED! DONE 
> ENTIRELY LOOKING AT THE SOURCE! IT MAY RAPE ALL YOUR PETS, AND CALL YOU 
> BAD NAMES!) make any difference?
> 
> (patch against unmodified dbench-2.0)

I am testing the updated version of dbench now. Normally, it takes
30min-1hour to reproduce the problem (when I do infinite "dbench 4").
I will post the results soon.

Thanks,
Badari

