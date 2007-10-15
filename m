Return-Path: <linux-kernel-owner+w=401wt.eu-S1765542AbXJOQew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765542AbXJOQew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762012AbXJOQek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:34:40 -0400
Received: from pat.uio.no ([129.240.10.15]:37925 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759051AbXJOQei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:34:38 -0400
Subject: Re: nfs mmap adventure (was: 2.6.23-mm1)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: David Howells <dhowells@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <21859.1192457172@redhat.com>
References: <1192451324.27435.71.camel@twins>
	 <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <21859.1192457172@redhat.com>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 11:51:29 -0400
Message-Id: <1192463489.7529.11.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.074)
X-UiO-Scanned: E41841015F98B415B5FC666C5418C978B755D6B0
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1212 total 4502851 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-15 at 15:06 +0100, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > I get funny SIGBUS' like so:
> > 
> > fault
> >   if (->page_mkwrite() < 0)
> >     nfs_vm_page_mkwrite()
> >       nfs_write_begin()
> >         nfs_flush_incompatible()
> >           nfs_wb_page()
> >             nfs_wb_page_priority()
> >               nfs_sync_mapping_wait()
> >                 nfs_wait_on_request_locked()
> >                   nfs_wait_on_request()
> >                     nfs_wait_bit_interruptible()
> >                       return -ERESTARTSYS
> >     SIGBUS
> > 
> > trying to figure out what to do about this...
> > 
> 
> Hmmm...  It sounds like the fault handler should deliver the appropriate
> signal, should ->page_mkwrite() return ERESTARTSYS, and then retry the access
> instruction that caused the fault when the signal handler has finished
> running.

If you signal the process before msync() has completed, or before you
have completed unmapping the region then your writes can potentially be
lost. Why should we be providing any guarantees beyond that?

Trond

