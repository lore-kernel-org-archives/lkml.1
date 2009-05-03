Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZECWvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZECWvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 18:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZECWvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 18:51:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54102 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZECWvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 18:51:40 -0400
Date: Sun, 3 May 2009 23:51:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: sget() misuse in nilfs
Message-ID: <20090503225136.GC8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	OK, I give up; what _is_ get_sb/remount code supposed to implement?
Not to mention the reliability of down_read_trylock() in there (what happens
if somebody tries to e.g. remount fs we are looking at the time?  That's
right, s_umount held exclusive, down_read_trulock() failing, fs instance
skipped during the search), what is all that stuff trying to achieve?

	What protects MS_RDONLY in sd->s_flags during these searches?
What makes parse_options() in remount straight into sb (with reversal
if we'd done something bad) safe?  Do we ever reassign snapshot_cno
other than on sb creation and remounting between r/o and r/w?  Is there
any reason why we free sbi early (== in put_super()) and not after
kill_block_super() in ->kill_sb() of your own?  That alone would make
sbi stay with superblock for as long as it could be found by any
means, killing the locking mess in your test callbacks.  Can SNAPSHOT
even be there unless you have MS_RDONLY?

	And what are the rules for exclusion in case of r/w mounts?
What, do we get -EBUSY on attempt to mount r/w something that is
already mounted r/w (instead of simply sharing superblock, as other
filesystems would do)?  Or am I misreading that
        } else if (!(s->s_flags & MS_RDONLY)) {
                err = -EBUSY;
        }
in there?

						Very confused Al...
