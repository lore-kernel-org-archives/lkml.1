Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbYKQHcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbYKQHcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYKQHVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:35 -0500
Received: from kroah.org ([198.145.64.141]:38620 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752704AbYKQHV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:28 -0500
Date: Sun, 16 Nov 2008 23:16:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 33/46] dm raid1: flush workqueue before destruction
Message-ID: <20081117071619.GH29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-raid1-flush-workqueue-before-destruction.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 18776c7316545482a02bfaa2629a2aa1afc48357 upstream.

We queue work on keventd queue --- so this queue must be flushed in the
destructor. Otherwise, keventd could access mirror_set after it was freed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-raid1.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1598,6 +1598,7 @@ static void mirror_dtr(struct dm_target 
 
 	del_timer_sync(&ms->timer);
 	flush_workqueue(ms->kmirrord_wq);
+	flush_scheduled_work();
 	dm_kcopyd_client_destroy(ms->kcopyd_client);
 	destroy_workqueue(ms->kmirrord_wq);
 	free_context(ms, ti, ms->nr_mirrors);

-- 
