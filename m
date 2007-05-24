Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbXEXUV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbXEXUV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbXEXUVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:21:49 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:45246 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbXEXUVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:21:47 -0400
Date: Thu, 24 May 2007 14:21:44 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: coly <colyli@gmail.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC 4/5] inode reservation v0.1 (benchmark result)
Message-ID: <20070524202144.GS5181@schatzie.adilger.int>
Mail-Followup-To: coly <colyli@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1179943697.4179.55.camel@coly-t43.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179943697.4179.55.camel@coly-t43.site>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 24, 2007  02:08 +0800, coly wrote:
> Due to the bad design of magic inode and the on-disk layout of magic
> inode. When 30 files created alternatively in each directory, no
> performance advantage exists. When 50 files created alternatively in
> each directory, the patched ext4 will use double time on removing all
> the files and directories.

I don't think the use of magic inodes is the right approach.  One possibility
to avoid changing the on-disk format at all is to only do the reservation in
memory, scaling the reservation with the size of the directory.

The only issue that arises is how to regenerate the same reservation
after a remount.  This might be possible to do by looking into the leaf
block at create time to see which inode numbers are already in use for
that leaf and checking whether there are free inodes in each group.

One way to get the "best" mapping is possibly checking groups in order of
decreasing number of inodes for that leaf in each group and once a suitable
group has been found doing a few name->hash->inode numbers to get the old
mapping back.  Once this leaf->group mapping has been established it
can be re-used for a given leaf block until that window is full.

Since you need to scan all of a leaf block's dir entries in a hash block
at insert time to look for duplicate names, and the inode numbers are
in the dir entries, this shouldn't introduce any additional disk IO.

Also, regardless of what the mapping turns out to be - the goal is to place
inodes with a similar hash into nearby inodes, and this heuristic works
relatively well for that.  Once the given leaf block's inode range is full
then new inodes can be allocated from a new window as it was done for the
newly-created directory.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

