Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXH2OLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXH2OLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 10:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXH2OLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 10:11:11 -0400
Received: from pat.uio.no ([129.240.10.15]:49876 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbXH2OLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 10:11:10 -0400
Subject: Re: [PATCH] Switch nfs/callback.c to using struct pid, not pid_t
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070829135205.GA13879@infradead.org>
References: <46D57658.2040704@openvz.org>
	 <20070829135205.GA13879@infradead.org>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 10:10:41 -0400
Message-Id: <1188396641.6580.62.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.094)
X-UiO-Scanned: 07A5685ADC7734B19A6626BEBD46598B75082439
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 353 total 3541386 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 14:52 +0100, Christoph Hellwig wrote:
> On Wed, Aug 29, 2007 at 05:36:24PM +0400, Pavel Emelyanov wrote:
> > Pid namespaces make it dangerous to use pid and tgid values
> > when run in some namespace. The struct pid itself is going
> > to be the only way for working with task pids, so make the
> > nfs callback thread use it.
> > 
> > Since nfs_callback_info.pid is set to current's one and reset
> > on the thread exit, it is safe not to get the struct pid. 
> > 
> > Since this pid is used later under lock_kernel() w/o sleeping 
> > operations, checking for i to be not NULL and killing the 
> > thread with kill_pid() is safe.
> 
> NACK.  This just makes the code even more obscure.  Please get rid
> of the pid references entirely and convert the code to the kthread
> API.

That would require converting the full sunrpc server code to use
kthreads, which again means changing nfsd, and lockd too.

I'm not saying that is a bad thing, but it is nontrivial to do. In
particular, kthread's abominable shutdown mechanism simply does not work
or scale when the thread is listening for new requests in svc_recv().

Cheers
  Trond

