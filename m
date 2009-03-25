Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbZCYOSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbZCYOSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbZCYOSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:18:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:57720 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZCYOSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:18:04 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: [RFC PATCHSET pata-2.6] ide: clean up ide-tape
Date: Wed, 25 Mar 2009 23:17:43 +0900
Message-Id: <1237990673-8358-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 14:17:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bartlomiej, Jens.

This RFC patchset cleans up ide-tape.  Note that the patchset
currently is only compile tested, so it's likely to be broken, so the
RFC status.  Albert Lee is sending me some IDE tape drives, so I'll
test these patches as soon as I receive them and repost with whatever
necessary fixes.

The ide-tape drive is quite interesting in that it implements its own
multi-segment buffer management using struct idetape_bh.  Its rw path
doesn't use standard IDE or block data transfer mechanisms and
sometimes abuses them in interesting ways.

This patchset converts ide-tape to use bio like the rest of the world.
Currently, this is done using single contiguous buffer which uses an
order higher allocation than the original code if the buffer size is
not power of two.  The maximum being single order 4 allocation per
device, which is the same as the original code, I don't think this is
an issue but if it ever is adopting sg-based multi-segment buffer
handling isn't difficult and can be nicely built on top of the updated
bio-based code.

This patchset simplifies ide-tape quite a bit as will be show in the
diffstat at the end of the message and also simplifies ide-atapi and
ide-io a bit.  Most importantly, it enables further work on block
layer by unifying API usage.

This patchset contains the following ten patches.

 0001-ide-atapi-allow-pc_callback-to-change-rq-data_.patch
 0002-ide-tape-use-single-continuous-buffer.patch
 0003-ide-tape-convert-to-bio.patch
 0004-ide-tape-use-standard-data-transfer-mechanism.patch
 0005-ide-tape-kill-idetape_bh.patch
 0006-ide-tape-unify-r-w-init-paths.patch
 0007-ide-tape-use-byte-size-instead-of-sectors-on-rw-iss.patch
 0008-ide-tape-simplify-read-write-functions.patch
 0009-ide-atapi-kill-unused-fields-and-callbacks.patch
 0010-ide-drop-rq-data-handling-from-ide_map_sg.patch

0001-0005 converts ide-tape to bio and kills idetape_bh.  0006-0008
makes additional clean ups on ide-tape.  0009-0010 removes now
unnecessary stuff from ide-atapi and ide-io.

This patchset is on top of linux-next pata-2.6 tree as of 2009-03-23 +
ide-rq-buffer-data-special-and-misc-cleanups patchset[1] and available
in the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ide-phase2
 http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=ide-phase2

diffstat follows.

 drivers/ide/ide-atapi.c |   31 --
 drivers/ide/ide-io.c    |    6 
 drivers/ide/ide-tape.c  |  714 +++++++++---------------------------------------
 include/linux/ide.h     |   12 
 4 files changed, 160 insertions(+), 603 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.ide/39275
