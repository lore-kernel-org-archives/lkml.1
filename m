Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXITKM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXITKM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 06:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXITKMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 06:12:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58871 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750749AbXITKMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 06:12:16 -0400
Date: Thu, 20 Sep 2007 20:12:10 +1000
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.23
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070920101210.6631358C4C09@chook.melbourne.sgi.com>
From: tes@sgi.com (Tim Shimmin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A couple of small fixes.
One for harmless sparse warnings and one which can prevent
crashes on 32 bit boxes using filestreams.

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/xfs_filestream.c  |    7 ++++---
 fs/xfs/xfs_log_recover.c |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

through these commits:

commit 1bc5858d0d40e07697b5eda47ed8628b8a934235
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Sep 19 15:27:30 2007 +1000

    [XFS] fix valid but harmless sparse warning
    
    The new xlog_recover_do_reg_buffer checks call be16_to_cpu on di_gen which
    is a 32bit value so sparse rightly complains. Fortunately the warning is
    harmless because we don't care for the value, but only whether it's
    non-NULL. Due to that fact we can simply kill the endian swaps on this and
    the previous di_mode check entirely.
    
    SGI-PV: 969656
    SGI-Modid: xfs-linux-melb:xfs-kern:29709a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit bcc7b445eff295664a3a3ab14e742b3c9d88e6e3
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Aug 30 17:21:38 2007 +1000

    [XFS] fix filestreams on 32-bit boxes
    
    xfs_filestream_mount() sets up an mru cache with:
      err = xfs_mru_cache_create(&mp->m_filestream, lifetime, grp_count,
      (xfs_mru_cache_free_func_t)xfs_fstrm_free_func);
    but that cast is causing problems...
      typedef void (*xfs_mru_cache_free_func_t)(unsigned long, void*);
    but:
      void xfs_fstrm_free_func( xfs_ino_t ino, fstrm_item_t *item)
    so on a 32-bit box, it's casting (32, 32) args into (64, 32) and I assume
    it's getting garbage for *item, which subsequently causes an explosion.
    With this change the filestreams xfsqa tests don't oops on my 32-bit box.
    
    SGI-PV: 967795
    SGI-Modid: xfs-linux-melb:xfs-kern:29510a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

--Tim
