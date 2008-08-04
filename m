Return-Path: <linux-kernel-owner+w=401wt.eu-S1765656AbYHDVhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765656AbYHDVhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765439AbYHDVf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:35:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:49935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762434AbYHDVf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:35:56 -0400
Date: Mon, 4 Aug 2008 14:29:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Neil Brown <neilb@suse.de>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 07/25] Close race in md_probe
Message-ID: <20080804212949.GG8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="close-race-in-md_probe.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Neil Brown <neilb@suse.de>

[ Upstream commit f48ed538386cb41559282d989354e8f5d442d71c ]

There is a possible race in md_probe.  If two threads call md_probe
for the same device, then one could exit (having checked that
->gendisk exists) before the other has called kobject_init_and_add,
thus returning an incomplete kobj which will cause problems when
we try to add children to it.

So extend the range of protection of disks_mutex slightly to
avoid this possibility.

Signed-off-by: Neil Brown <neilb@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3326,9 +3326,9 @@ static struct kobject *md_probe(dev_t de
 	disk->queue = mddev->queue;
 	add_disk(disk);
 	mddev->gendisk = disk;
-	mutex_unlock(&disks_mutex);
 	error = kobject_init_and_add(&mddev->kobj, &md_ktype, &disk->dev.kobj,
 				     "%s", "md");
+	mutex_unlock(&disks_mutex);
 	if (error)
 		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
 		       disk->disk_name);

-- 
