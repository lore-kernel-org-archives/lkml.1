Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYFLUSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYFLUSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYFLUSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:18:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55838 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbYFLUSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:18:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 12 Jun 2008 22:17:49 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: bkl-removal: drivers/firewire and drivers/ieee1394 patches can be
 reverted/ dropped
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.08d683698d08913b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan,

please revert commits

"firewire: cdev lock_kernel() pushdown"
aabbc0e478bf1e82e7f4a9ec61abb8a1a259175b
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=aabbc0e478bf1e82e7f4a9ec61abb8a1a259175b

"ieee1394: cdev lock_kernel() pushdown"
8fff9d8cda2b288231fd100333fed26b9bb2042f
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=8fff9d8cda2b288231fd100333fed26b9bb2042f

and drop them before mainline submission.

I looked at the respective drivers last month and came to the conclusion
that fw_device_op_open(), dv1394_open(), raw1394_open() are safe to be
called without the BKL held.  I specifically looked for possible races
with module initialization or with other processes accessing the
respective character device file interface and found none.

(Well, extremely early openers of dv1394 or raw1394 could find the
devices not yet operational, i.e. they may look to the opener as if no
hardware were present.  But this is no real-world problem.  All actual
application programs which use those device files will in practice
access them only after module initialization was finished and thus be
able to get through to hardware.)

I found a race condition of video1394_open() with module initialization
and fixed it in commit
"ieee1394: video1394: reorder module init, prepare BKL removal"
6ee70088d975130142debdf1f6fe07958d3d2f26
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=6ee70088d975130142debdf1f6fe07958d3d2f26

Thanks,
-- 
Stefan Richter
-=====-==--- -==- -==--
http://arcgraph.de/sr/

