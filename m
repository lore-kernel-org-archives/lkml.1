Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbZLOQpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbZLOQpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759885AbZLOQpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:45:12 -0500
Received: from thunk.org ([69.25.196.29]:42862 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711AbZLOQpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:45:11 -0500
Date: Tue, 15 Dec 2009 11:45:03 -0500
From: tytso@mit.edu
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Possible data loss on ext[34], reiserfs with external
 journal
Message-ID: <20091215164503.GI4867@thunk.org>
Mail-Followup-To: tytso@mit.edu, Oleg Drokin <green@linuxhacker.ru>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20091211081608.GA597088@fiona.linuxhacker.ru>
 <20091215053207.GA26541@thunk.org>
 <2EEF5D3D-AFA5-4D74-92A7-B42A0FB9A4F5@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2EEF5D3D-AFA5-4D74-92A7-B42A0FB9A4F5@linuxhacker.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 01:19:57AM -0500, Oleg Drokin wrote:
> > +	/* 
> > +	 * If the journal is not located on the file system device,
> > +	 * then we must flush the file system device before we issue
> > +	 * the commit record
> > +	 */
> > +	if (commit_transaction->t_flushed_data_blocks &&
> > +	    (journal->j_fs_dev != journal->j_dev) &&
> > +	    (journal->j_flags & JBD2_BARRIER))
> > +		blkdev_issue_flush(journal->j_fs_dev, NULL);
> > +
> 
> I am afraid this is not enough. This code is called after journal
> was flushed for async commit case, so it leaves a race window where
> journal transaction is already on disk and complete, but the data is
> still in cache somewhere.

No, that's actually fine.  In the ASYNC_COMMIT case, the commit won't
be valid until the checksum is correct, and we won't have written any
descriptor blocks yet at this point.  So there is no race because
during that window, the commit is written but we won't write any
descriptor blocks until after the barrier returns.

> Also the callsite has this comment which is misleading, I think:
>         /*
>          * This is the right place to wait for data buffers both for ASYNC
>          * and !ASYNC commit. If commit is ASYNC, we need to wait only after
>          * the commit block went to disk (which happens above). If commit is
>          * SYNC, we need to wait for data buffers before we start writing
>          * commit block, which happens below in such setting.
>          */

Yeah, that comment is confusing and not entirely accurate.  I thought
about cleaning it up, and then decided to do that in a separate patch.

      	       	      	       	       	  - Ted
