Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYDRNbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYDRNbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbYDRNa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:30:56 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:37725 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbYDRNaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:30:55 -0400
X-AuditID: 0ac90647-aad9fba0000012c0-e0-48089b88e23b
Message-ID: <48089B86.5020108@hitachi.com>
Date: Fri, 18 Apr 2008 22:00:54 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes

The current JBD is not sufficient for I/O error handling.  It can
cause filesystem corruption.   An example scenario:

1. fail to write a metadata buffer to block B in the journal
2. succeed to write the commit record
3. the system crashes, reboots and mount the filesystem
4. in the recovery phase, succeed to read data from block B
5. write back the read data to the filesystem, but it is a stale
   metadata
6. lose some files and directories!

This scenario is a rare case, but it (temporal I/O error)
can occur.  If we abort the journal between 1. and 2., this
tragedy can be avoided.

This patch set fixes several error handling problems to protect
from filesystem corruption caused by I/O errors.  It has been
done only for JBD and ext3 parts.

This patch is against 2.6.25

[PATCH 1/4] jbd: strictly check for write errors on data buffers
[PATCH 2/4] jbd: ordered data integrity fix
[PATCH 3/4] jbd: abort when failed to log metadata buffers
[PATCH 4/4] jbd: fix error handling for checkpoint io

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center



