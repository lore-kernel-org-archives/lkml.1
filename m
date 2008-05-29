Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbYE2JMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbYE2JMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 05:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYE2JMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 05:12:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:29234 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbYE2JMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 05:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EPV+PB4DBwEQ3adixi44I4sYEXbsC5V/r9MebJ728biS+UMcM/+/xrPQ0ah4Mi6M3P91dnP7fv2PEFSGXeEq3S98BwVJWUCiI84hdBL3rz2qj7siStiLfJH9755ywbcz6kkNYFaBoHoxpFfWRhCrlUMaQT8Ky2YrVhln+KqEGVo=
Message-ID: <5f7c1d2c0805290212i45aece46j7fae2dcf9c158b92@mail.gmail.com>
Date: Thu, 29 May 2008 17:12:13 +0800
From: "Xiaoming Li" <forrubm2@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [help]How to block new write in a "Thin Provisioning" logical volume manager as a virtual device driver when physical spaces run out?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, guys,

We are currently developing a "Thin Provisioning" (see
http://en.wikipedia.org/wiki/Thin_Provisioning) logical volume manager
called ASD at the Linux block device level, which is somewhat like the
LVM (see http://en.wikipedia.org/wiki/Logical_Volume_Manager_%28Linux%29).
But there is a big difference between ASD and LVM: LVM pre-allocates
all storage spaces at the very beginning (Fat Provisioning), while ASD
allocates storage spaces _ONLY WHEN NEEDED_.
As a result, with LVM, you can never export a "logical volume" with
claimed storage space larger than of the underlying physical storage
devices (e.g. SATA disks, Hardware RAID array etc.); but with ASD, you
can export "logical volumes" which have much larger logical storage
space.

However, we have some troubles when developing ASD. The
thin-provisioning feature of ASD may inevitably result in "overcommit
problem" in the worst case, that is, the underlying physical storage
resource run out while supported applications are still running. Since
the logical storage space seen by the upper-level applications is very
large, it never knows the actually physical storage spaces left.
What's worse, in case of VFS delay write mode, the write request is
immediately satisfied by VFS cache. Although the application thinks
the request has complete successfully, but actually, it may be
silently discarded by ASD driver later because there are no any
physical resource left.

In attempt to resolve this problem, we find the prepare_write method
in inode address space operations will be invoked by VFS for any new
written data, that is, notifying the file system module to allocate
required space for the new written data. If our ASD driver can also be
informed by this hook function, then we can solve this problem.
Fortunately, we can get and modify this hook function (prepare_write)
in case of raw block device I/O (VFS handle the ASD exported device as
a whole).

However, there are also 2 limitations in this solution.

1. We cannot block write requests to a mount-point where an ASD device
is mounted.
That is to say, if we perform a mkfs.ext2 operation to an ASD, and
then mount it to /mnt/asd1, then dd to the mount point /mnt/asd1, we
will not be able to block the new-writes which may run out of the
physical device spaces.

2. We cannot block the writes, if we put some other virtual devices
over ASD, unless we modify _ALL_ of the virtual devices in the I/O
stack.
Because of the mechanism of VFS, upper-level applications will write
to the page cache of the new-added virtual devices over ASD. If using
our current solution, we will have to replace the prepare_write()
function of the newly-added virtual device. What's worse, if we have
more virtual devices in the I/O stack, we will have to replace _ALL_
of their prepare_write() functions to achieve our goal, which will be
unacceptable.

Does anyone have some ideas for a better solution?
Thanks a lot!

--
Regards,

alx
