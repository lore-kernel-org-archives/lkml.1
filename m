Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbXJXVZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbXJXVZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXJXVZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:25:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbXJXVZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:25:23 -0400
Message-ID: <471FB83D.4060307@ce.jp.nec.com>
Date: Wed, 24 Oct 2007 17:25:17 -0400
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] dm: noflush resizing (0/3)
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently, there is a restriction on resizing device-mapper device:
it cannot be resized if 'noflush' option is given for suspend.

Since both multipath-tools (dm-multipath) and LVM2 mirror use
'noflush' suspend, the restriction limits the capability of
those tools.

The following patches remove the restriction.
  [PATCH] (1/3) Add bdlookup()
  [PATCH] (2/3) Use bdlookup() on noflush suspend
  [PATCH] (3/3) Allow resizing table load on noflush suspend

The patches were tested on i686 and ia64 with LVM2,
for both 'noflush' case and normal case.

Background:

  - For some device-mapper targets (multipath and mirror),
    the mapping table sometimes has to be replaced to cope with device
    failure.
    OTOH, device-mapper flushes all pending I/Os upon table replacement
    and may result in I/O errors, if there are device failures.
    'noflush' suspend is used to let dm queue the pending I/Os
    instead of flushing them.
    Since it's not possible for user space program to tell whether
    the suspend could cause I/O error, they always use
    'noflush' to suspend mirror/multipath targets.

  - Currently resizing is disabled for 'noflush' suspend.
    Resizing occurs in the course of table replacement.
    To resize the device under use, device-mapper needs to get its
    bdev inode. However, using bdget() in this case could cause deadlock
    by waiting for I_LOCK where an I/O process holding I_LOCK is
    waiting for completion of table replacement.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
