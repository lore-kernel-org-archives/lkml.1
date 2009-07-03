Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZGCGpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZGCGpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZGCGp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:45:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50806 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZGCGp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:45:26 -0400
Date: Fri, 3 Jul 2009 08:45:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: lennart@poettering.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703064518.GA30674@elte.hu>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Lennart how does this fit your needs - this replaces the existing wait
> active hack with a race free one and adds other events with a proper
> infrastructure for them.
> 
> From: Alan Cox <alan@linux.intel.com>
> 
> This is needed and requested in various forms for ConsoleKit, screenblank
> handling and the like so do the job with a single interface. Also build the
> interface so that unlike VT_WAITACTIVE and friends it won't miss events.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/char/vt.c       |    4 +
>  drivers/char/vt_ioctl.c |  181 ++++++++++++++++++++++++++++++++++-------------
>  include/linux/vt.h      |   14 ++++
>  include/linux/vt_kern.h |    3 +
>  kernel/power/console.c  |    4 +
>  5 files changed, 152 insertions(+), 54 deletions(-)

Just a side-note, please run new patches through 
scripts/checkpatch.pl:

    total: 4 errors, 2 warnings, 0 checks, 294 lines checked

all four errors it flagged should be fixed.

Even the two warnings about over-long lines show real problem areas 
that could be improved:

 - the copy_from_user() in vt_event_wait_ioctl() could be shortened 
   if we didnt pass in an unsigned long (which is pointless anyway).
   The cast to void __user * should be done in the ioctl 
   demultiplexer vt_ioctl(), and the ioctl ugliness should not 
   invade cleaner child functions such as vt_event_wait_ioctl().

 - same for vt_event_wait_ioctl() - it passes in a type damaged by 
   ioctl's limitations. Such type limitations and ioctl demuxing 
   artifacts should be kept local to vt_ioctl().

Thanks,

	Ingo
