Return-Path: <linux-kernel-owner+w=401wt.eu-S966483AbXFHBTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966483AbXFHBTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965033AbXFHBTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:19:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964853AbXFHBTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:19:11 -0400
Date: Thu, 7 Jun 2007 18:18:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 001 of 2] Fix read/truncate race.
Message-Id: <20070607181820.6b22bb29.akpm@linux-foundation.org>
In-Reply-To: <1070607014653.27304@suse.de>
References: <20070607114043.26967.patches@notabene>
	<1070607014653.27304@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 11:46:53 +1000
NeilBrown <neilb@suse.de> wrote:

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

Is this really worth fixing?

The code still has races there - for example, another process can come
after we've got the page, truncate it off the file then write new data.  So
this thread ends up copying out-of-date page contents out to userspace.

The application is being silly, and the silly application gets wrong data:
either out-of-date or zeroed.

afacit the patch shrinks the timing windows significantly, but at a cost:
moving a bunch of 64-bit arithmetic and seqlock operations into the inner
loop.

We could plug all this in a more predictable fashion by locking the page,
but then we have another instance of the
read-a-page-into-a-mmapped-copy-of-itself deadlock (I think - maybe it
can't happen because of page uptodateness checks).

