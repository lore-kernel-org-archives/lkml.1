Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab0BBBjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:39:45 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:45779 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0BBBjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:39:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=MC35OFo/6xQU4DOKq68CGzN0LuKeP2K//SPOKD+0tA8NghBn/46NjfNByHjcm/VvhZ
         bb5WAjdSm60yFEe89vXnsD1dJ8KFX3J7DQfGtQ2lFpT6Zqr+R/8qtZiBeAO3H8+KafOA
         S2wCpCAzJpe3ti22Pu/ARD9BRervtSBv4nho4=
From: Edward Shishkin <edward.shishkin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 0/7] per-bdi flushing model improvements. reiser4
Date: Tue, 2 Feb 2010 02:39:27 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.i686; KDE/4.3.3; i686; ; )
MIME-Version: 1.0
Message-Id: <201002020239.27368.edward.shishkin@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, jens.axboe@oracle.com
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:
> reiser4 is currently disabled in -mm (via reiser4-disable.patch)
> because recent changes to fs/fs/writeback.c wrecked the build.  I fixed
> it about ten times as the underlying code was churning, then gave up.  It
> would be nice if you take a look at that sometime please.
>
>

I have taken a look at fs/fs-writeback.c and found that per-superblock
flushing interface is eliminated. However migrating to per-bdi flushing
model doesn't necessarily means that such interface doesn't exist or is
not needed anymore. Flushing in accordance with the scheme "data-inode-
data-inode-..." would be very suboptimal for reiser4. Also xfs people
were unhappy with such flushing model:
http://article.gmane.org/gmane.linux.file-systems/30153

Moreover, the current stuff looks rather ugly. Why do we pin/unpin
superblock for every inode? It would be more reasonable to pin it for the
whole group of inodes and call a flushing handler for them. The patch 4
introduces such handler writeback_sb_inodes (which resembles dropped
sync_sb_inodes, the difference is that the newer version doesn't flush
necessarily all inodes of the superblock). Please, consider pushing this
patch to mainline.

The patch 5 adds super operation .writeback_inodes (former .sync_inodes)
which allows a file system to make optimizations. It can happen that
reiser4 will flush a bit more inodes then generic implementation suggests.
"a bit more" doesn't mean "all dirty inodes of the superblock" (see a
comment about atoms in the header of patch 6).

Finally, some file systems have its own means for periodical writeout
of dirty data. Since b_io contains inodes of many superblocks we need
to evict our inodes back to dirty list when flushing is going on with
for_kupdate flag installed. The new library function
writeback_skip_sb_inodes() provides such possibility.

Patch 7 fixes a race in checkin-checkout jnodes for entd task (reiser4).
Please, apply.

Thanks,
Edward.
