Return-Path: <linux-kernel-owner+w=401wt.eu-S1761553AbZEMTqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553AbZEMTqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760449AbZEMTqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:46:31 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:49791 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241AbZEMTq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:46:29 -0400
Subject: Re: 2.6.30-rc deadline scheduler performance regression for iozone
 over NFS
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jim Rees <rees@umich.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Olga Kornievskaia <aglo@citi.umich.edu>, Jeff Moyer <jmoyer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org
In-Reply-To: <20090513182524.GA20778@merit.edu>
References: <x49hc0f79k9.fsf@segfault.boston.devel.redhat.com>
	 <20090508120119.8c93cfd7.akpm@linux-foundation.org>
	 <20090511081415.GL4694@kernel.dk>
	 <x49skjb21b7.fsf@segfault.boston.devel.redhat.com>
	 <20090511165826.GG4694@kernel.dk>
	 <x494ovp4r51.fsf@segfault.boston.devel.redhat.com>
	 <20090512204433.7eb69075.akpm@linux-foundation.org>
	 <x49y6t1rqw0.fsf@segfault.boston.devel.redhat.com>
	 <b4ff356f0905130920v184ab529mb52a4346d4c77c14@mail.gmail.com>
	 <20090513093229.097b47d2.akpm@linux-foundation.org>
	 <20090513182524.GA20778@merit.edu>
Content-Type: text/plain
Date: Wed, 13 May 2009 15:45:38 -0400
Message-Id: <1242243938.5407.115.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 9 msgs/h 1 sum rcpts/h 12 sum msgs/h 2 total rcpts 303 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: CE212CFDDA589B7B71362F695681C88CF669B171
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 273 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 14:25 -0400, Jim Rees wrote:
> Andrew Morton wrote:
> 
>   Jeff's computer got slower.  Can we fix that?
> 
> TCP autotuning can reduce performance by up to about 10% in some cases.
> Jeff found one of these cases.  While the autotuning penalty never exceeds
> 10% as far as I know, I can provide examples of other cases where autotuning
> improves nfsd performance by more than a factor of 100.
> 
> The right thing is to fix autotuning.  If autotuning is considered too
> broken to use, it should be turned off everywhere, not just in nfsd, as it
> hurts/benefits all TCP clients, not just nfs.
> 
> This topic has been discussed before on netdev:
> http://www.spinics.net/lists/netdev/msg68650.html
> http://www.spinics.net/lists/netdev/msg68155.html

Yes, but one consequence of this patch is that the socket send buffer
size sk->sk_sndbuf is now initialised to a smaller value than before.

This again means that the test for xprt->xpt_ops->xpo_has_wspace() in
svc_xprt_enqueue() will fail more often, and so you will be able to
process fewer incoming requests in parallel while you are waiting for
the send window size to build up.

Perhaps the right thing to do here is to allow some limited violation of
the xpo_has_wspace() test while the send window is in the process of
building up?

Cheers
  Trond

