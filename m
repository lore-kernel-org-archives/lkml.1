Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZDZHH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZDZHH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 03:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZDZHHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 03:07:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZDZHHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 03:07:14 -0400
Date: Sun, 26 Apr 2009 03:07:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 3/5] ext4: ext4_mark_recovery_complete() doesn't need
	to use lock_super
Message-ID: <20090426070713.GA17022@infradead.org>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu> <1240717765-16572-2-git-send-email-tytso@mit.edu> <1240717765-16572-3-git-send-email-tytso@mit.edu> <1240717765-16572-4-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240717765-16572-4-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 11:49:23PM -0400, Theodore Ts'o wrote:
> The function ext4_mark_recovery_complete() is called from two call
> paths: either (a) while mounting the filesystem, in which case there's
> no danger of any other CPU calling write_super() until the mount is
> completed, and (b) while remounting the filesystem read-write, in
> which case the fs core has already locked the superblock, and in any
> case write_super() wouldn't be called until the filesystem is
> successfully changed from being mounted read-only to read-write.

Currently ext4_remount releases/reqacquires lock_super around
ext4_mark_recovery_complete, and unfortunately currently ->write_super
can be called on a r/o filesystem (that's why we have the MS_RDONLY
checks in all instance, I plan to clean that mess up).

So for now I would keep that instance of lock_super, it'll also serve as
documentation for the locking requirements once we pushed down
lock_super to the filesystem in ->write_super and ->remount_fs so that
it can eventually be replaced with an ext4-local lock.

