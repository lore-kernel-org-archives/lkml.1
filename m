Return-Path: <linux-kernel-owner+w=401wt.eu-S932918AbYDYXjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbYDYXjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbYDYXi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:38:57 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39175 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567AbYDYXi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:38:56 -0400
Subject: Possible race between direct IO and JBD?
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: akpm@linux-foundation.org
Cc: pbadari@us.ibm.com, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080306174209.GA14193@duck.suse.cz>
References: <20080306174209.GA14193@duck.suse.cz>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 25 Apr 2008 16:38:23 -0700
Message-Id: <1209166706.6040.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While looking at a bug related to direct IO returns to EIO, after
looking at the code, I found there is a window that
try_to_free_buffers() from direct IO could race with JBD, which holds
the reference to the data buffers before journal_commit_transaction()
ensures the data buffers has reached to the disk.

A little more detail: to prepare for direct IO, generic_file_direct_IO()
calls invalidate_inode_pages2_range() to invalidate the pages in the
cache before performaning direct IO.  invalidate_inode_pages2_range()
tries to free the buffers via try_to free_buffers(), but sometimes it
can't, due to the buffers is possible still on some transaction's
t_sync_datalist or t_locked_list waiting for
journal_commit_transaction() to process it. 

Currently Direct IO simply returns EIO if try_to_free_buffers() finds
the buffer is busy, as it has no clue that JBD is referencing it.

Is this a known issue and expected behavior? Any thoughts?


Mingming

