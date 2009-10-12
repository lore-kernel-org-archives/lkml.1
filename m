Return-Path: <linux-kernel-owner+w=401wt.eu-S932206AbZJLOB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbZJLOB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932196AbZJLOBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:01:54 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:65343 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbZJLOBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:01:53 -0400
Date: Mon, 12 Oct 2009 10:00:49 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Cc: jack@suse.cz, jbacik@redhat.com
Subject: Fun with fdatasync()
Message-ID: <20091012140049.GO2632@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jack@suse.cz, jbacik@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AD3369B.000C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello everyone,

Josef has been doing some benchmarking around rpm performance on the
filesystem and noticed that ext3 was going really fast on the
fdatasyncs.

It seems pretty surprising to me that rpm -Uvh should do fdatasync
without forcing fsyncs.  The files get overwritten, and any time we mark
an inode dirty I_DIRTY_DATASYNC is getting set.

Handling of I_DIRTY_DATASYNC seems to work like this:

mark_inode_dirty() will set I_DIRTY_DATASYNC

ext3_sync_file will force a full commit on I_DIRTY_DATASYNC

This part makes good sense.  If the inode has changed, we're supposed to
do a full commit.

writeback_single_inode is where things seem to go wrong:

        /* Set I_SYNC, reset I_DIRTY */
        dirty = inode->i_state & I_DIRTY;
        inode->i_state |= I_SYNC;
        inode->i_state &= ~I_DIRTY;

Whoops, we just lost I_DIRTY_DATASYNC.  So, if pdflush comes in and does some
writeback before we fdatasync, we'll skip the full commit because
I_DIRTY_DATASYNC is gone.

The solution to me seems to be that we need to keep I_DIRTY_DATASYNC
until the FS does an fsync/O_SYNC operation, and make the FS
responsible for clearing it.

This does risk extra full fsyncs if the FS does a transaction commit on
its own, but the FS should be responsible for keeping track of which
transaction last changed a given file and doing a shortcut in the fsync
code if the file is already on safely on disk.

Am I missing something?  I don't see how fdatasync is safe in our
current usage.

-chris

