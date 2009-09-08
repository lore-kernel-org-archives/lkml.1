Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274AbZIHS2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbZIHS2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZIHS2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:28:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:46262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZIHS2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:28:38 -0400
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, "Theodore Ts'o" <tytso@mit.edu>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090908175756.GG2975@think>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
	 <1252401791-22463-9-git-send-email-jens.axboe@oracle.com>
	 <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins>
	 <20090908162936.GA2975@think> <1252428983.7746.140.camel@twins>
	 <20090908172842.GC2975@think> <1252431974.7746.151.camel@twins>
	 <20090908175756.GG2975@think>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 20:28:30 +0200
Message-Id: <1252434510.7035.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 13:57 -0400, Chris Mason wrote:
> Going back to the streaming writer case, pretend the FS just created a
> nice fat 256MB extent out of dealloc pages, but after we wrote the first
> 4k, we dropped below the dirty threshold and IO is no longer "required".
> 
> It would be silly to just write 4k.  We know we have a contiguous
> area 256MB long on disk and 256MB of dirty pages.  In this case, pdflush
> (or Jens' bdi threads) want to write some large portion of that 256MB.
> 
> You might argue a balance_dirty_pages callers wants to return quickly,
> but even then we'd want to write at least 128k.

Sure and that's no problem at all,.. I'm thinking something like a
fraction of the dirty limit, maybe something like
(dirty_ratio-background_ratio) / 4 as chunk size. That gives a sizable
amount and scales with the writeback cache stuff.

Esp if we move all write activity into the bdi threads and have the
application tasks wait. In that case we can release the app tasks to
generate more dirty pages while still writing out data in a linear
fashion.

