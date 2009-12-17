Return-Path: <linux-kernel-owner+w=401wt.eu-S936455AbZLQEXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936455AbZLQEXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935976AbZLQEX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:23:29 -0500
Received: from kroah.org ([198.145.64.141]:55815 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935942AbZLQEFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:04 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:56 2009
Message-Id: <20091217035656.480820893@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [104/151] dm snapshot: cope with chunk size larger than origin
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 8e87b9b81b3c370f7e53c1ab6e1c3519ef37a644 upstream.

Under some special conditions the snapshot hash_size is calculated as zero.
This patch instead sets a minimum value of 64, the same as for the
pending exception table.

rounddown_pow_of_two(0) is an undefined operation (it expands to shift
by -1).  init_exception_table with an argument of 0 would fail with -ENOMEM.

The way to trigger the problem is to create a snapshot with a chunk size
that is larger than the origin device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-snap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -553,6 +553,8 @@ static int init_hash_tables(struct dm_sn
 	hash_size = min(origin_dev_size, cow_dev_size) >> s->store->chunk_shift;
 	hash_size = min(hash_size, max_buckets);
 
+	if (hash_size < 64)
+		hash_size = 64;
 	hash_size = rounddown_pow_of_two(hash_size);
 	if (init_exception_table(&s->complete, hash_size,
 				 DM_CHUNK_CONSECUTIVE_BITS))


