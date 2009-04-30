Return-Path: <linux-kernel-owner+w=401wt.eu-S934111AbZD3RyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111AbZD3RyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933035AbZD3RbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:31:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:43706 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933053AbZD3RbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:31:20 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [RFC PATCH 0/2] A new way of attaching information to inodes
Date: Thu, 30 Apr 2009 19:31:16 +0200
Message-Id: <1241112678-6615-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  currently our VFS inode structure is quite big. It contains quite some
members that are useful only in some cases (e.g. device pointers and list head
used only when the inode represents a block/character device, quota pointers
used only when the filesystem actually supports quota, etc.). And it would
be helpful to add some more so that we can handle ACL's in generic code, or
we can do some kind of block reservation for mmaped writes, and there are
other cases.
  So I though it may be worth a try to come up with a way to attach info to
inode structure so that generic code can look it up (or find it's not there),
it's space effective and on the other hand the access does not cost us too
much.
  What I've come up with is that each inode could have a pointer to a (usually
static) table of offsets of structures associated with the inode. Filesystem
would then carry the structures it is interested in in it's private inode.
  As an example, I've converted quota pointers from inode to use this feature
and ext2 filesystem so that we have some rough idea how the resulting code
looks like. IMO from the filesystem's POV it's quite fine, the generic code
gets a bit less obvious but it's bearable as well. Regarding the speed, we
impose additinal lookup in the table and an addition of the offset from the
table so it should be IMHO acceptable cost for things that are not really fast
path.
  What do you think? Your opinions and suggestions are welcome...

								Honza
