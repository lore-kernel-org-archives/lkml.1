Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZFHUqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZFHUqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbZFHUqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:46:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34189 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZFHUqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:46:05 -0400
Date: Mon, 8 Jun 2009 22:45:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Thomas Pilarski <thomas.pi@arcor.de>,
       Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org
Subject: Re: (forw) [bugzilla-daemon@bugzilla.kernel.org: [Bug 12309] Large
	I/O operations result in slow performance and high iowait times]
Message-ID: <20090608204544.GB26832@elte.hu>
References: <20090608182929.GA26458@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090608182929.GA26458@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed Linus and Jens too)

* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Thomas have done a very thorough bissection job and have made some very
> interesting findings. Just in case everyone is ignoring this now huge
> bugzilla thread, I'm forwarding his email to LKML so people can have a
> closer look at the offending commits.
> 
> I'm glad you are so persistent on figuring out the source of these
> long-lasting regressions Thomas, thanks a lot !
> 
> Mathieu
> 
> ----- Forwarded message from bugzilla-daemon@bugzilla.kernel.org -----
> 
> Date: Fri, 5 Jun 2009 21:55:16 GMT
> To: mathieu.desnoyers@polymtl.ca
> From: bugzilla-daemon@bugzilla.kernel.org
> Subject: [Bug 12309] Large I/O operations result in slow performance and high
> 	iowait times
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12309
> 
> 
> 
> 
> 
> --- Comment #360 from Thomas Pilarski <thomas.pi@arcor.de>  2009-06-05 21:55:05 ---
> Created an attachment (id=21774)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=21774)
> Test patch against heavy io bug
> 
> I have made an bisection and got these two patches. Reverting these patches
> improves the desktop responsiveness on my notebook enormous. I have tested it
> on a 2.6.28 non smp kernel (my heavy io testing installation) during four
> concurrent read and write operations, while working with two VMs. It's only a
> Core2 @2.4GHz system. I can even start new application during heavy io.
> 
> I have added the patch, which I have applied to my test installation. Use it
> with care, as I am not a kernel developer and does not know the dependencies in
> the cfq scheduler. 
> 
> I have reverted theses two patches:
> 
> 07db59bd6b0f279c31044cba6787344f63be87ea is first bad commit
> commit 07db59bd6b0f279c31044cba6787344f63be87ea
> Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
> Date:   Fri Apr 27 09:10:47 2007 -0700
> 
>     Change default dirty-writeback limits
> 
>     Do this really early in the 2.6.22-rc series, so that we'll get
>     feedback.  And don't change by half measures.  Just cut the default
>     dirty limit to a quarter of what it was, and see if anybody even
>     notices.
> 
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> :040000 040000 b63eb9faf5b9a42a1cdad901a5f18d6cceb7fdf6
> 2b8b4117ca34077cb0b817c77595aa6c9e34253a M      mm
> 
> a993800655ee516b6f6a6fc4c2ee13fedfb0590b is first bad commit
> commit a993800655ee516b6f6a6fc4c2ee13fedfb0590b
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Apr 20 08:55:52 2007 +0200
> 
>     cfq-iosched: fix sequential write regression
> 
>     We have a 10-15% performance regression for sequential writes on TCQ/NCQ
>     enabled drives in 2.6.21-rcX after the CFQ update went in.  It has been
>     reported by Valerie Clement <valerie.clement@bull.net> and the Intel
>     testing folks.  The regression is because of CFQ's now more aggressive
>     queue control, limiting the depth available to the device.
> 
>     This patches fixes that regression by allowing a greater depth when only
>     one queue is busy.  It has been tested to not impact sync-vs-async
>     workloads too much - we still do a lot better than 2.6.20.
> 
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> :040000 040000 07c48a6930ce62d36540b6650e3ea0563bd7ec59
> 95fc11105fe3339c90c4e7bebb66a820f7084601 M      block
> 
> 
> Here the fsync result on my machine:
> 
> **************************************************************************
> Without patch
> Linux balrog 2.6.28 #2 Mon Mar 23 11:19:13 CET 2009 x86_64 GNU/Linux
> 
> fsync time: 7.8282
> fsync time: 17.3598
> fsync time: 24.0352
> fsync time: 19.7307
> fsync time: 21.9559
> fsync time: 21.0571
> 5000+0 Datensätze ein
> 5000+0 Datensätze aus
> 5242880000 Bytes (5,2 GB) kopiert, 129,286 s, 40,6 MB/s
> fsync time: 21.8491
> fsync time: 0.0430
> fsync time: 0.0448
> fsync time: 0.0451
> fsync time: 0.0451
> fsync time: 0.0451
> fsync time: 0.0452
> 
> 
> 
> **************************************************************************
> With patch
> Linux balrog 2.6.28 #5 Fri Jun 5 22:23:54 CEST 2009 x86_64 GNU/Linux
> 
> fsync time: 2.8409
> fsync time: 2.3345
> fsync time: 2.8423
> fsync time: 0.0851
> fsync time: 1.2497
> fsync time: 0.9981
> fsync time: 0.9494
> fsync time: 2.7094
> fsync time: 2.9753
> fsync time: 2.8886
> fsync time: 2.9894
> fsync time: 1.2673
> fsync time: 2.6728
> fsync time: 1.3408
> 5000+0 Datensätze ein
> 5000+0 Datensätze aus
> 5242880000 Bytes (5,2 GB) kopiert, 117,388 s, 44,7 MB/s
> fsync time: 85.1461
> fsync time: 23.5310
> fsync time: 0.0317
> fsync time: 0.0337
> fsync time: 0.0338
> fsync time: 0.0338
> 
> -- 
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug.
> 
> ----- End forwarded message -----
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
