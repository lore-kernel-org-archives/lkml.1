Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYDZKmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYDZKmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 06:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYDZKl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 06:41:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbYDZKl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 06:41:58 -0400
Date: Sat, 26 Apr 2008 03:41:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Cc: pbadari@us.ibm.com, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Possible race between direct IO and JBD?
Message-Id: <20080426034139.0dafc76e.akpm@linux-foundation.org>
In-Reply-To: <1209166706.6040.20.camel@localhost.localdomain>
References: <20080306174209.GA14193@duck.suse.cz>
	<1209166706.6040.20.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008 16:38:23 -0700 Mingming Cao <cmm@us.ibm.com> wrote:

> Hi,
> 
> While looking at a bug related to direct IO returns to EIO, after
> looking at the code, I found there is a window that
> try_to_free_buffers() from direct IO could race with JBD, which holds
> the reference to the data buffers before journal_commit_transaction()
> ensures the data buffers has reached to the disk.
> 
> A little more detail: to prepare for direct IO, generic_file_direct_IO()
> calls invalidate_inode_pages2_range() to invalidate the pages in the
> cache before performaning direct IO.  invalidate_inode_pages2_range()
> tries to free the buffers via try_to free_buffers(), but sometimes it
> can't, due to the buffers is possible still on some transaction's
> t_sync_datalist or t_locked_list waiting for
> journal_commit_transaction() to process it. 
> 
> Currently Direct IO simply returns EIO if try_to_free_buffers() finds
> the buffer is busy, as it has no clue that JBD is referencing it.
> 
> Is this a known issue and expected behavior? Any thoughts?

Something like that might be possible, although people used to test
buffered-vs-direct fairly heavily.

generic_file_direct_IO() will run
filemap_write_and_wait()->filemap_fdatawrite() under i_mutex, and this
should run commits, write back dirty pages, etc.

There might remain races though, perhaps with page faults.
