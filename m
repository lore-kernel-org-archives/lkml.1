Return-Path: <linux-kernel-owner+w=401wt.eu-S1030611AbXCSVlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030611AbXCSVlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030619AbXCSVlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:41:49 -0400
Received: from mail.suse.de ([195.135.220.2]:55742 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965075AbXCSVlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:41:31 -0400
Date: Mon, 19 Mar 2007 14:39:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       neilb@cse.unsw.edu.au, adi@hexapodia.org, ego@in.ibm.com
Subject: [patch 16/31] fix read past end of array in md/linear.c
Message-ID: <20070319213935.GR9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-read-past-end-of-array-in-md-linear.c.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Andy Isaacson <adi@hexapodia.org>

When iterating through an array, one must be careful to test one's index
variable rather than another similarly-named variable.

The loop will read off the end of conf->disks[] in the following
(pathological) case:

% dd bs=1 seek=840716287 if=/dev/zero of=d1 count=1
% for i in 2 3 4; do dd if=/dev/zero of=d$i bs=1k count=$(($i+150)); done
% ./vmlinux ubd0=root ubd1=d1 ubd2=d2 ubd3=d3 ubd4=d4
# mdadm -C /dev/md0 --level=linear --raid-devices=4 /dev/ubd[1234]

adding some printks, I saw this:
[42949374.960000] hash_spacing = 821120
[42949374.960000] cnt          = 4
[42949374.960000] min_spacing  = 801
[42949374.960000] j=0 size=820928 sz=820928
[42949374.960000] i=0 sz=820928 hash_spacing=820928
[42949374.960000] j=1 size=64 sz=64
[42949374.960000] j=2 size=64 sz=128
[42949374.960000] j=3 size=64 sz=192
[42949374.960000] j=4 size=1515870810 sz=1515871002

Cc: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Neil Brown <neilb@cse.unsw.edu.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/linear.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -188,7 +188,7 @@ static linear_conf_t *linear_conf(mddev_
 	for (i=0; i < cnt-1 ; i++) {
 		sector_t sz = 0;
 		int j;
-		for (j=i; i<cnt-1 && sz < min_spacing ; j++)
+		for (j = i; j < cnt - 1 && sz < min_spacing; j++)
 			sz += conf->disks[j].size;
 		if (sz >= min_spacing && sz < conf->hash_spacing)
 			conf->hash_spacing = sz;

-- 
