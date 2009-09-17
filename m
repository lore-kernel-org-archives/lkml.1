Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZIQVxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZIQVxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZIQVxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:53:12 -0400
Received: from mail2.shareable.org ([80.68.89.115]:58524 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbZIQVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:53:10 -0400
Date: Thu, 17 Sep 2009 22:53:09 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: jack@suse.cz, tytso@mit.edu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC] Ext3 data=guarded
Message-ID: <20090917215309.GD10599@shareable.org>
References: <1252422595-4554-1-git-send-email-chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252422595-4554-1-git-send-email-chris.mason@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> The main difference from data=ordered is that data=guarded only updates
> the on disk i_size after all of the data blocks are on disk.  This allows
> us to avoid flushing all the data pages down to disk with every commit.

I'm a bit confused, because I thought that was already guaranteed by
ext3 data=ordered, due to the following mail:

  Date: Thu, 16 Mar 2006 13:09:04 -0500
  Subject: Re: ext3_ordered_writepage() questions
  From: Theodore Ts'o <tytso@mit.edu>

  > >Yup.  Ordered-mode JBD commit needs to write and wait upon all dirty
  > >file-data buffers prior to journalling the metadata.  If we didn't run
  > >journal_dirty_data_fn() against those buffers then they'd still be under
  > >I/O after commit had completed.
  > >
  > In  non-block allocation case, what metadata are we journaling in
  > writepage() ?
  > block allocation happend in prepare_write() and commit_write()
  > journaled the transaction. All the meta data updates should be done
  > there.  What JBD commit are you refering to here ?


  Basically, this boils down to what is our definition of ordered-mode?

  If the goal is to make sure we avoid the security exposure of
  allocating a block and then crashing before we write the data block,
  potentially exposing previously written data that might be belong to
  another user, then what Badari is suggesting would avoid this
  particular problem.

  However, if what we are doing is overwriting our own data with more an
  updated, more recent version of the data block, do we guarantee that
  any ordering semantics apply?  For example, what if we write a data
  block, and then follow it up with some kind of metadata update (say we
  touch atime, or add an extended attribute).  Do we guarantee that if
  the metadata update is committed, that the data block will have made
  it to disk as well?  Today that is the way things work, but is that
  guarantee part of the contract of ordered-mode?

						  - Ted

-- Jamie
