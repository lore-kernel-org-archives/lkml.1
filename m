Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbXFGNog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbXFGNog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXFGNo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:44:27 -0400
Received: from rtr.ca ([64.26.128.89]:1326 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbXFGNo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:44:27 -0400
Message-ID: <46680BB8.50404@rtr.ca>
Date: Thu, 07 Jun 2007 09:44:24 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Stephen Tweedie <sct@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: ext3fs: umount+sync not enough to guarantee metadata-on-disk
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew / Stephen / Ted,

I have a MythTV PVR box here, which has had intermittent shutdown issues
over the past while.

The main storage for recordings is a 2-drive RAID0 array,
formatted with ext3fs.  The system runs a 2.6.17 Ubuntu kernel
that I've tailored/rebuild for this specific machine.

My observation is, if I delete a couple of 25+ GByte files,
and then immediately shutdown the system, the disks are still being
written to at the point when the power goes off (halt -f -p).

The overall sequence is something like this:

1. Delete the files in Myth, which uses a "delete slowly" function
to avoid locking up the machine for the 30-60 seconds that this would
otherwise require.  Myth appears to open the file, unlink it, and then
sit in a loop doing small ftruncate's until nothing is left.

2. When I trigger the shutdown whilst this is happening, Myth gets
killed off, and so the unlinked file is automatically closed.
and the kernel (filesystem) code begins finishing the delete operation.

3. The shutdown scripts do their thing quickly, so the delete is
*still* underway when the umount commands are issued.
On this system, I use this sequence:

  ## /var/lib/mythtv is the recording's ext3fs, on /dev/md0 (RAID0):
   mount /var/lib/mythtv -oremount,ro
   sync
   umount /var/lib/mythtv
   sync
   mount / -oremount,ro
   sync
   sleep 1
   hdparm -W0 /dev/sda /dev/sdb
   sync
   sleep 2
   halt -f -p

4. The hard drive light is on solid throughout, including at the point
when the power goes out.

5. On the next reboot, there is a LONG pause (20-30 seconds) at the
point where /var/lib/mythtv is remounted --> indicating unfinished business
from the journal file that needs to be replayed (eg. the file deletion).

So.. how can I guarantee a quiescent filesystem before doing "halt -f -p" ??
This looks pretty dangerous as-is.

Thanks
