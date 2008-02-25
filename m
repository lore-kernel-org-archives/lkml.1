Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYBYNcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYBYNcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYBYNc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:32:27 -0500
Received: from mxintern.schlund.de ([212.227.126.201]:60427 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYBYNc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:32:26 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2008 08:32:26 EST
Date: Mon, 25 Feb 2008 14:26:15 +0100
From: Anders Henke <anders.henke@1und1.de>
To: linux-kernel@vger.kernel.org
Subject: device mapper not reporting no-barrier-support?
Message-ID: <20080225132615.GA21990@1und1.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: 1&1 Internet AG
User-Agent: Mutt/1.5.13 (2006-08-11)
X-UI-Msg-Verification: a87cc6ff147aa36592120fa94056df16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently stuck between Kernel LVM and DRBD, as I'm using Kernel
2.6.24.2 with DRBD 8.2.5 on top of an LVM2 device (LV).

-LVM2/device mapper doesn't support write barriers
-DRBD uses blkdev_issue_flush() to flush its metadata to disk.
 On a no-barrier-device, DRBD should receive EOPNOTSUPP, but
 it really does receive an EIO. Promptly, DRBD gives the
 error message "drbd0: local disk flush failed with status -5".

The physical disk (in LVM speak) is a RAID1 on a 3ware 9650SE-2LP
controller; the driver 3w-9xxx supports barriers and after moving my D
RBD device from the LV to a single partition on the same RAID1, the 
error messages from DRBD vanished.

I've posted a lengty summary of my findings to

http://lists.linbit.com/pipermail/drbd-user/2008-February/008665.html

... where Lars Ellenberg from DRBD basically responded in

http://lists.linbit.com/pipermail/drbd-user/2008-February/008666.html

... that DRBD does catch the EOPNOTSUPP for blkdev_issue_flush and
BIO_RW_BARRIER, but the lvm implementation of blkdev_issue_flush in
2.6.24.2 aparently does return EIO for blkdev_issue_flush.

So simply the question: how should a top-layer driver check wether a lower
device does support barriers? md-raid does check this way differently than
e.g. XFS does, while DRBD also adds a third way to check this.
Or is this "merely" a bug in drivers/md/dm.c?


Anders
-- 
1&1 Internet AG              System Architect
Brauerstrasse 48             v://49.721.91374.50
D-76135 Karlsruhe            f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Markus Huhn, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren
