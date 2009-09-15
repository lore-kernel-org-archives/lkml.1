Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZIOOKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZIOOKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbZIOOJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:09:53 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:19726 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbZIOOJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:09:51 -0400
Date: Tue, 15 Sep 2009 10:09:23 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       tytso@mit.edu, akpm@linux-foundation.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 6/7] writeback: separate starting of sync vs
 opportunistic writeback
Message-ID: <20090915140923.GB23965@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	akpm@linux-foundation.org, trond.myklebust@fys.uio.no
References: <20090914134207.GA14830@infradead.org>
 <20090914192803.GL14984@kernel.dk>
 <20090914194242.GM14984@kernel.dk>
 <20090915090847.GA12169@duck.suse.cz>
 <20090915091402.GG23126@kernel.dk>
 <20090915114426.GJ23126@kernel.dk>
 <20090915125855.GF12169@duck.suse.cz>
 <20090915130419.GL23126@kernel.dk>
 <20090915130829.GA7507@infradead.org>
 <20090915140145.GG12169@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915140145.GG12169@duck.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt014.oracle.com [141.146.116.23]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AAFA016.009F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 04:01:45PM +0200, Jan Kara wrote:
> On Tue 15-09-09 09:08:29, Christoph Hellwig wrote:
> > On Tue, Sep 15, 2009 at 03:04:19PM +0200, Jens Axboe wrote:
> > > 
> > > >   Let's have a look at the flags in wbc:
> > > >   nonblocking - Currently only set by direct callers of ->writepage() BUT
> > > >                 originally wb_kupdate() and background_writeout() also
> > > >                 set this flag. Since filesystems and write_cache_pages()
> > > > 		use the flag we should set it for equivalent writeouts as
> > > >                 well. This should be fixed...
> > > 
> > > Since this is all handled by the dedicated thread now, dropping the
> > > nonblocking bit was on purpose. What would the point be, except for
> > > stopping pdflush being blocked on request allocation?
> > 
> > Note that this flag just caused utter mess traditionally.  btrfs decided
> > to ignore it completely and ext4 partially.  Removing this check in
> > XFS increases large bufferd write loads massively.
> > 
> > Just half-removing it is a bad idea, though - if you don't set it
> > anymore please kill it entirely.
>   The nonblocking flag is still set for writeback done for memory reclaim.
> OTOH the only real consumer of this flag now seems to be
> __block_write_full_page() which does trylock_buffer() in case of
> nonblocking writeback. I'm undecided whether it makes sence or not.

Ugh, making sense is tricky to say.  If __block_write_full_page
does a lock_buffer() instead of a trylock_buffer(), and ext3 is mounted in
data=ordered mode then it is very possible that we'll end up with a
dirty page with locked buffers.

The buffers will have been locked by ext3 data=ordered writeback and
they won't unlock until the IO is done.

We probably don't want kswapd waiting on that writeback.

-chris



