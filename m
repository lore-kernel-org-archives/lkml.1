Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbZJKL0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbZJKL0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 07:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbZJKL0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 07:26:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:49657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135AbZJKL0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 07:26:24 -0400
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
 balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091011105012.GB10409@localhost>
References: <20091007073818.318088777@intel.com>
	 <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz>
	 <1255101512.8802.65.camel@laptop> <20091009154759.GJ7654@duck.suse.cz>
	 <20091011022813.GA21315@localhost> <1255247080.11081.3.camel@twins>
	 <20091011105012.GB10409@localhost>
Content-Type: text/plain
Date: Sun, 11 Oct 2009 13:25:17 +0200
Message-Id: <1255260317.8967.204.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-11 at 18:50 +0800, Wu Fengguang wrote:
> 
> Sorry for the confusion, but I mean, filesystems have to limit
> nr_writeback (directly or indirectly via the block io queue),
> otherwise it either hit nr_dirty to 0 (with the loop), or let
> nr_writeback grow out of control (without the loop).

Doesn't this require the writeback queue to have a limit < dirty_thresh?

Or more specifically, for the bdi case:

 bdi_dirty + bdi_writeback + bdi_unstable <= bdi_thresh

we require that the writeback queue be smaller than bdi_thresh, which
could be quite difficult, since bdi_thresh can easily be 0.

Without observing the bdi_thresh constraint we can have:

  \Sum_(over bdis) writeback_queue_size

dirty pages outstanding, which could be significantly higher than
dirty_thresh.

Or am I confused again?

