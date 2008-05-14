Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbYENEoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbYENEoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYENEn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:43:56 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35760 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYENEnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:43:55 -0400
X-AuditID: 0ac90647-ad124ba000004aeb-00-482a6e09319c
Message-ID: <482A6E00.6080303@hitachi.com>
Date: Wed, 14 May 2008 13:43:44 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
       adilger@clusterfs.com
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@redhat.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>
Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes (rebased)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes (rebased)

This is the rebased version against 2.6.26-rc2, so there is no
essential difference from the previous post.
The previous post can be found at: http://lkml.org/lkml/2008/4/18/154
(The previous post may have been filtered out as SPAM mails
 due to a trouble in the mail submission.)


This patch set fixes several error handling problems.  As the
result, we can save the filesystem from file data and structural
corruption especially caused by temporal I/O errors.  Do temporal
I/O errors occur so often?  At least it will be not uncommon
for iSCSI storages.
This fixes have been done only for ext3/JBD parts.  The ext4/JBD2
version has not been prepared yet, but merging this patch set
will be worthwhile because it takes away possible filesystem
corruption.

[PATCH 1/4] jbd: strictly check for write errors on data buffers
  Without this patch, some file data in ordered mode aren't
  checked for errors.  This means user processes can continue to
  update the filesystem without noticing the write failure.
  Furthermore, the page cache which we failed to write becomes
  reclaimable.  So if the page cache is reclaimed then we
  succeed to read its data from the disk, the data corruption
  will occur because the data is old.
  Jan's ordered mode rewrite patch also fixes this problem, but
  this patch will be needed at least for the current kernel.

[PATCH 2/4] jbd: ordered data integrity fix
  This patch fixes the ordered mode violation problem caused
  by write error.  Jan's ordered mode rewrite patch will also
  fix this problem.

[PATCH 3/4] jbd: abort when failed to log metadata buffers
  Without this patch, the filesystem can corrupt along with
  the following scenario:

  1. fail to write a metadata buffer to block B in the journal
  2. succeed to write the commit record
  3. the system crashes, reboots and mount the filesystem
  4. in the recovery phase, succeed to read data from block B
  5. write back the read data to the filesystem, but it is
     a stale metadata
  6. lose some files and directories!

  This problem wouldn't happen if we have JBD2's journal
  checksumming feature and it's always turned on.

[PATCH 4/4] ext3/jbd: fix error handling for checkpoint io
  Without this patch, the filesystem can lose some metadata
  updates even though the transactions have been committed.

Regards,

-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


