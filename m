Return-Path: <linux-kernel-owner+w=401wt.eu-S932671AbXGTPIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbXGTPIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934036AbXGTPHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:07:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764523AbXGTPHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:07:54 -0400
Message-ID: <46A0CFB3.1090004@redhat.com>
Date: Fri, 20 Jul 2007 17:07:31 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070529)
MIME-Version: 1.0
To: Alasdair G Kergon <agk@redhat.com>
CC: Chuck Ebbert <cebbert@redhat.com>, Patrick McHardy <kaber@trash.net>,
       Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [2.6.23 PATCH 07/18] dm io: fix panic on large request
References: <20070711205846.GY24114@agk.fab.redhat.com> <469CC11B.2020103@trash.net> <469E305D.8060003@redhat.com>
In-Reply-To: <469E305D.8060003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:

>> [  126.754204] BUG: unable to handle kernel NULL pointer dereference at
>> virtual address 00000000
>>     
...

> mempool_free() was called with a NULL pool. That can't be good.
Yes, it is really not good :)

Bug http://bugzilla.kernel.org/show_bug.cgi?id=7388
Attached patch fixes this problem, fix needed for stable tree too,
this is not regression, just very old bug...

Milan
--
mbroz@redhat.com

--
From: Milan Broz <mbroz@redhat.com>

Flush workqueue before releasing bioset and mopools
in dm-crypt.
There can be finished but not yet released request.

Call chain causing oops:
  run workqueue
    dec_pending
      bio_endio(...);
      	<remove device request - remove mempool>
      mempool_free(io, cc->io_pool);

This usually happens when cryptsetup create temporary
luks mapping in the beggining of crypt device activation.

When dm-core calls destructor crypt_dtr, no new request
are possible.

Signed-off-by: Milan Broz <mbroz@redhat.com>

---
 drivers/md/dm-crypt.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.22/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.22.orig/drivers/md/dm-crypt.c	2007-07-17 21:56:36.000000000 +0200
+++ linux-2.6.22/drivers/md/dm-crypt.c	2007-07-19 11:55:13.000000000 +0200
@@ -920,6 +920,8 @@ static void crypt_dtr(struct dm_target *
 {
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
+	flush_workqueue(_kcryptd_workqueue);
+
 	bioset_free(cc->bs);
 	mempool_destroy(cc->page_pool);
 	mempool_destroy(cc->io_pool);



