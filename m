Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZGNLod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZGNLod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 07:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZGNLo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 07:44:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZGNLoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 07:44:24 -0400
Date: Tue, 14 Jul 2009 13:44:19 +0200
From: Jan Kara <jack@suse.cz>
To: Chris Mason <chris.mason@oracle.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, jack@suse.cz
Subject: Re: [PATCH] Fix congestion_wait() sync/async vs read/write
	confusion
Message-ID: <20090714114419.GA17633@duck.suse.cz>
References: <20090708184703.GW23611@kernel.dk> <20090708191238.GE18008@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708191238.GE18008@think>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-07-09 15:12:38, Chris Mason wrote:
> On Wed, Jul 08, 2009 at 08:47:03PM +0200, Jens Axboe wrote:
> > Hi,
> > 
> > This one isn't great, we currently have broken congestion wait logic in
> > the kernel. 2.6.30 is impacted as well, so this patch should go to
> > stable too once it's in -git. I'll let this one simmer until tomorrow,
> > then ask Linus to pull it. The offending commit breaking this is
> > 1faa16d22877f4839bd433547d770c676d1d964c.
> > 
> > Meanwhile, it could potentially cause buffered writeout slowdowns in the
> > kernel. Perhaps the 2.6.30 regression in that area is caused by this?
> > Would be interesting if the submitter could test. I can't find the list,
> > CC'ing Rafael.
> 
> Even if this does slow down some workloads, the bug is not in using the
> correct flag ;) So, I'd ack this one.
> 
> Jan Kara was able to reproduce the tiobench 2.6.30 regression, so I've
> cc'd him and kept the patch below.
  Thanks for the patch Chris. I've remeasured tiobench with the 2.6.30 +
the fix but it didn't help (which is not too surprising as what I observe
is most likely CFQ related as there's no regression with NOOP scheduler).
  Just to recall:
    2.6.29 (CFQ)           Avg    StdDev
8   38.01 40.26 39.69 ->  39.32  0.955092
16  40.09 38.18 40.05 ->  39.44  0.891104

    2.6.30-rc8 (CFQ)
8   36.67 36.81 38.20 ->  37.23  0.69062
16  37.45 36.47 37.46 ->  37.13  0.464351

    2.6.30-rc8+fix (CFQ)
8   37.56 37.38 37.98 ->  37.64  0.251396
16  38.11 36.71 37.18 ->  37.33  0.581741

  So with the fix there's no statistically significant difference and we
are still below 2.6.29 results. I'm now going to retest with the WRITE_SYNC
changes reverted.

									Honza
--
Jan Kara <jack@suse.cz>
SUSE Labs, CR
