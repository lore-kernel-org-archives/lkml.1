Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbZDPROY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbZDPROY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbZDPROP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:14:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48641 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbZDPROO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:14:14 -0400
Date: Thu, 16 Apr 2009 19:13:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@ftp.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090416171346.GA26897@elte.hu>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416143626.GA17683@infradead.org> <20090416164927.GB19281@elte.hu> <20090416170150.GA526@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416170150.GA526@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Apr 16, 2009 at 06:49:27PM +0200, Ingo Molnar wrote:
>
> > They dont really protect anything - the patch is wrong and 
> > equivalent to a plain removal of the BKL.
> > 
> > The only case we found to ever matter in practice is NFS: it 
> > really wants to get rid of the BKL in nfsd_get_sb(). So pushing 
> > down the BKL lock into per filesystems and then removing it from 
> > NFS should do the trick.
> > 
> > Would be nice to have some tentative Ack (or, a tentative 
> > non-immediate-NAK) from Al before we go touch a lot of 
> > filesystems though. Stupid dont-waste-human-effort 
> > considerations and stuff.
> > 
> > For us, the much simpler solution would be to drop the BKL in 
> > nfsd_get_sb() and go on with life without to touch a dozen or so 
> > filesystems. Alessio, mind trying that too, is it a solution for 
> > your testcase?
> 
> What about trying to attack it piece-mail?  ->unmount_begin is 
> really easy.  The only one that doesn't protect everything 
> properly is 9p, but it doesn't protect the state variable deep 
> down a few levels of function calls at all.
> 
> ->remount_fs should be easy enough to, we do have proper per-sb 
> protection here, but do_remount_sb will need a bit of an audit. 
> (and of course pushing lock_kernel down into the many instances 
> and leave the cleanup-work to the fs maintainers).
> 
> The actual mount path is more interesting as there are quite a few 
> cases there.  As a first step you can take lock_kernel from 
> outside do_mount into the various do_foo calls inside it, and then 
> work on those piece by piece.

We'd be glad to - but only with full principle and workflow backing 
of VFS-folks. This has been going on for more than a year - with 
ancient commits in tip:core/kill-the-BKL. I cannot mix stuff into it 
that gets eventual hostile treatment and NAKs a few months down the 
line, should this be submitted upstream.

	Ingo
