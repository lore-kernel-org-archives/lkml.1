Return-Path: <linux-kernel-owner+w=401wt.eu-S1764503AbXFGPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764503AbXFGPmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757898AbXFGPmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:42:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756155AbXFGPmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:42:02 -0400
Date: Thu, 7 Jun 2007 08:41:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Stephen Tweedie <sct@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
Message-Id: <20070607084142.42583639.akpm@linux-foundation.org>
In-Reply-To: <46680BB8.50404@rtr.ca>
References: <46680BB8.50404@rtr.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007 09:44:24 -0400 Mark Lord <lkml@rtr.ca> wrote:

> Andrew / Stephen / Ted,
> 
> I have a MythTV PVR box here, which has had intermittent shutdown issues
> over the past while.
> 
> The main storage for recordings is a 2-drive RAID0 array,
> formatted with ext3fs.  The system runs a 2.6.17 Ubuntu kernel
> that I've tailored/rebuild for this specific machine.
> 
> My observation is, if I delete a couple of 25+ GByte files,
> and then immediately shutdown the system, the disks are still being
> written to at the point when the power goes off (halt -f -p).
> 
> The overall sequence is something like this:
> 
> 1. Delete the files in Myth, which uses a "delete slowly" function
> to avoid locking up the machine for the 30-60 seconds that this would
> otherwise require.  Myth appears to open the file, unlink it, and then
> sit in a loop doing small ftruncate's until nothing is left.

sigh.  yup.

> 2. When I trigger the shutdown whilst this is happening, Myth gets
> killed off, and so the unlinked file is automatically closed.
> and the kernel (filesystem) code begins finishing the delete operation.
> 
> 3. The shutdown scripts do their thing quickly, so the delete is
> *still* underway when the umount commands are issued.
> On this system, I use this sequence:
> 
>   ## /var/lib/mythtv is the recording's ext3fs, on /dev/md0 (RAID0):

I assume the applikcaton has already been killed at this stage, and it is
blocked in the kernel running the truncate?

>    mount /var/lib/mythtv -oremount,ro
>    sync
>    umount /var/lib/mythtv

Did this succeed?  If the application is still truncating that file, the
umount should have failed.

>    sync
>    mount / -oremount,ro
>    sync
>    sleep 1
>    hdparm -W0 /dev/sda /dev/sdb
>    sync
>    sleep 2
>    halt -f -p
> 
> 4. The hard drive light is on solid throughout, including at the point
> when the power goes out.
> 
> 5. On the next reboot, there is a LONG pause (20-30 seconds) at the
> point where /var/lib/mythtv is remounted --> indicating unfinished business
> from the journal file that needs to be replayed (eg. the file deletion).

That opened-but-deleted file's inode is on the orphan list.

See, the unlink-then-slowly-truncate trick is done in this fashion so that
if the box crashes during the slow unlink, the orhpan list handling on the
reboot will finish off the truncate for us.

> So.. how can I guarantee a quiescent filesystem before doing "halt -f -p" ??
> This looks pretty dangerous as-is.

Wait for the killed-off applicaiton to actually exit, perhaps?  But
that unmount should have failed.


