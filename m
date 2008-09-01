Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbYIACzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbYIACzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 22:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYIACzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 22:55:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYIACzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 22:55:09 -0400
From: Neil Brown <neilb@suse.de>
To: David Greaves <david@dgreaves.com>
Date: Mon, 1 Sep 2008 12:54:57 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18619.22913.1452.426243@notabene.brown>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11460] 2.6.27-rc3 to -rc4 regression: init 0 hangs in halt
In-Reply-To: message from David Greaves on Saturday August 30
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
	<N8SeMoDzuxC.A.-VD.xhbuIB@albercik>
	<48B9C7C6.2060209@dgreaves.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday August 30, david@dgreaves.com wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11460
> > Subject		: 2.6.27-rc3 to -rc4 regression: init 0 hangs in halt
> > Submitter	: David Greaves <david@dgreaves.com>
> > Date		: 2008-08-30 04:07 (1 days old)
> 
> Yes.
> 
> I'm trying to bisect it but came across a bug/problem in git doing bisects.
> (see message subject "setlocalversion wasn't producing git labels for bisect")

Hi David.

Could you please try this patch?

Thanks,
NeilBrown


>From 271f5a9b8f8ae0db95de72779d115c9d0b9d3cc5 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 1 Sep 2008 12:32:52 +1000
Subject: [PATCH] Remove invalidate_partition call from do_md_stop.

When stopping an md array, or just switching to read-only, we
currently call invalidate_partition while holding the mddev lock.
The main reason for this is probably to ensure all dirty buffers
are flushed (invalidate_partition calls fsync_bdev).

However if any dirty buffers are found, it will almost certainly cause
a deadlock as starting writeout will require an update to the
superblock, and performing that updates requires taking the mddev
lock - which is already held.

This deadlock can be demonstrated by running "reboot -f -n" with
a root filesystem on md/raid, and some dirty buffers in memory.

All other calls to stop an array should already happen after a flush.
The normal sequence is to stop using the array (e.g. umount) which
will cause __blkdev_put to call sync_blockdev.  Then open the
array and issue the STOP_ARRAY ioctl while the buffers are all still
clean.

So this invalidate_partition is normally a no-op, except for one case
where it will cause a deadlock.

So remove it.

This patch possibly addresses the regression recored in
   http://bugzilla.kernel.org/show_bug.cgi?id=11460
and
   http://bugzilla.kernel.org/show_bug.cgi?id=11452

though it isn't yet clear how it ever worked.


Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8cfadc5..4790c83 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3841,8 +3841,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 
 		del_timer_sync(&mddev->safemode_timer);
 
-		invalidate_partition(disk, 0);
-
 		switch(mode) {
 		case 1: /* readonly */
 			err  = -ENXIO;
-- 
1.5.6.5

