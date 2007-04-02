Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbXDBIxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbXDBIxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 04:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbXDBIxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 04:53:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbXDBIxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 04:53:13 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 2 Apr 2007 18:53:04 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17936.50288.892586.831178@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] md: Avoid a deadlock when removing a device from an md
 array via sysfs.
In-Reply-To: message from Andrew Morton on Monday April 2
References: <20070402174319.30997.patches@notabene>
	<1070402074417.31093@suse.de>
	<20070402010141.3ad5516d.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday April 2, akpm@linux-foundation.org wrote:
> 
> What guarantees that *rdev is still valid when delayed_delete() runs?

Because that is how kobjects and krefs work.  There is an embedded
refcount etc etc..

> 
> And what guarantees that the md module hasn't been rmmodded when
> delayed_delete() tries to run?

Good point.  Nothing.  Maybe this patch is needed.

Thanks,
NeilBrown

---------------------------
Avoid a deadlock when removing a device from an md array via sysfs. - fix

Make sure any delayed_delete calls finish before module unload.
For simplicity, flush the queue when we stop the array.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 +++
 1 file changed, 3 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-04-02 17:38:46.000000000 +1000
+++ ./drivers/md/md.c	2007-04-02 18:49:24.000000000 +1000
@@ -3410,6 +3410,9 @@ static int do_md_stop(mddev_t * mddev, i
 				sysfs_remove_link(&mddev->kobj, nm);
 			}
 
+		/* make sure all delayed_delete calls have finished */
+		flush_scheduled_work();
+
 		export_array(mddev);
 
 		mddev->array_size = 0;
