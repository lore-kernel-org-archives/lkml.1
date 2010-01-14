Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605Ab0ANJFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0ANJFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 04:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442Ab0ANJFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 04:05:45 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49068 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab0ANJFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:05:42 -0500
X-Greylist: delayed 10396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2010 04:05:42 EST
X-AuditID: b753bd60-a9042ba000006009-56-4b4ede637ad0
Message-ID: <4B4EDE5C.8040600@hitachi.com>
Date: Thu, 14 Jan 2010 18:05:32 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       dle-develop@lists.sourceforge.net,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH] ext3: prevent reread after write IO error
References: <4B4EB5B9.4020809@hitachi.com>
In-Reply-To: <4B4EB5B9.4020809@hitachi.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Hidehiro Kawai wrote:

> This patch fixes the similar bug fixed by commit 95450f5a.
> 
> If a directory is modified, its data block is journaled as metadata
> and finally written back to the right place.  Now, we assume a
> transient write erorr happens on that writeback.  Uptodate flag of
> the buffer is cleared by write error, so next access on the buffer
> causes a reread from disk.  This means it breaks the filesystems
> consistency.

After sending this patch, I noticed that I have to deal with
the bh_uptodate_or_lock() case as well.  Actually, I confirmed
a data block sharing happens between two inodes. Allocate a new
block, then modified bitmap goes to the fs, but it fails due to
a transient IO error.  Next access on the bitmap buffer cause a
reread from disk.  As a result, the allocated block becomes 
a FREE block!  So this block can be shared by different two inodes.

I'll send the revised version later.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

