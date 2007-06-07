Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbXFGHVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbXFGHVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXFGHU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:20:57 -0400
Received: from brick.kernel.dk ([80.160.20.94]:1278 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbXFGHU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:20:56 -0400
Date: Thu, 7 Jun 2007 09:19:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 001 of 2] Fix read/truncate race.
Message-ID: <20070607071929.GL4735@kernel.dk>
References: <20070607114043.26967.patches@notabene> <1070607014653.27304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070607014653.27304@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07 2007, NeilBrown wrote:
> 
> do_generic_mapping_read currently samples the i_size at the start
> and doesn't do so again unless it needs to call ->readpage to load
> a page.  After ->readpage it has to re-sample i_size as a truncate
> may have caused that page to be filled with zeros, and the read()
> call should not see these.
> 
> However there are other activities that might cause ->readpage to be
> called on a page between the time that do_generic_mapping_read
> samples i_size and when it finds that it has an uptodate page.  These
> include at least read-ahead and possibly another thread performing a
> read.
> 
> So do_generic_mapping_read must sample i_size *after* it has an
> uptodate page.  Thus the current sampling at the start and after a read
> can be replaced with a sampling before the copy-out.
> 
> The same change applied to __generic_file_splice_read.
> 
> Note that this fixes any race with truncate_complete_page, but does
> not fix a possible race with truncate_partial_page.  If a partial
> truncate happens after do_generic_mapping_read samples i_size and
> before the copy_out, the nuls that truncate_partial_page place in the
> page could be copied out incorrectly.
> 
> I think the best fix for that is to *not* zero out parts of the page
> in truncate_partial_page, but rather to zero out the tail of a page
> when increasing i_size.

Thanks Neil, if you don't mind I'll steal the splice bits and add them
to the splice branch, as this particular patch conflicts with other
isize fixes that Hugh and I have been working on.

-- 
Jens Axboe

