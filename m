Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbXIQVtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbXIQVtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXIQVtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:49:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33017 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbXIQVtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:49:35 -0400
Date: Mon, 17 Sep 2007 16:44:36 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, mhalcrow@us.ibm.com
Subject: [PATCH 0/11] eCryptfs: Introduce persistent lower files for each eCryptfs inode
Message-ID: <20070917214436.GH13679@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, eCryptfs directly accesses the lower inode address space,
doing things like grab_cache_page() on lower_inode->i_mapping. It
really should not do that. The main point of this patch set is to make
all I/O with the lower files go through vfs_read() and vfs_write()
instead.

In order to accomplish this, eCryptfs needs a way to call vfs_read()
and vfs_write() on the lower file when ecryptfs_aops->readpage() and
ecryptfs_aops->writepage() are called. I propose keeping a persistent
lower file around for each eCryptfs inode. This is the only lower file
that eCryptfs will open for any given eCryptfs inode; multiple
eCryptfs files may map to this one persistent lower file. When the
eCrypfs inode is destroyed, this persistent lower file is closed.

Consolidating all reads and writes to the lower file to a single
execution path simplifies the code. This should also make it easier to
port eCryptfs to use the asynchronous crypto API functions. Note that
this patch set also removes all direct calls to lower prepare_write()
and commite_write(), fixing an oops when mounted on NFS.

Mike
