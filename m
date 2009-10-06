Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZJFHRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZJFHRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbZJFHRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:17:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43588 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbZJFHRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:17:39 -0400
Date: Tue, 6 Oct 2009 09:17:00 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: Re: [Drbd-dev] linux-next: block/drbd tree build warning
Message-ID: <20091006071700.GA7665@johann>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
	Philipp Reisner <philipp.reisner@linbit.com>
References: <20091006140154.8d94d95c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006140154.8d94d95c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 02:01:54PM +1100, Stephen Rothwell wrote:
> Hi Jens, Philipp,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> drivers/block/drbd/drbd_nl.c: In function 'drbd_nl_init':
> drivers/block/drbd/drbd_nl.c:2309: warning: passing argument 3 of 'cn_add_callback' from incompatible pointer type
> include/linux/connector.h:167: note: expected 'void (*)(struct cn_msg *, struct netlink_skb_parms *)' but argument is of type 'void (*)(struct cn_msg *)'

Thanks, expected after our connector related patches got in.

-- 
Author: Philipp Reisner <philipp.reisner@linbit.com>
Date:   Tue Sep 29 13:35:30 2009 +0200

drbd: Work on permission enforcement

Now we have the capabilities of the sending process available,
use them to enforce CAP_SYS_ADMIN.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 1927ace..00ce3a4 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2002,7 +2002,7 @@ static struct cn_handler_struct cnd_table[] = {
 	[ P_new_c_uuid ]	= { &drbd_nl_new_c_uuid,	0 },
 };
 
-static void drbd_connector_callback(struct cn_msg *req)
+static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms *nsp)
 {
 	struct drbd_nl_cfg_req *nlp = (struct drbd_nl_cfg_req *)req->data;
 	struct cn_handler_struct *cm;
@@ -2019,6 +2019,11 @@ static void drbd_connector_callback(struct cn_msg *req)
 		return;
 	}
 
+	if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN)) {
+		retcode = ERR_PERM;
+		goto fail;
+	}
+
 	mdev = ensure_mdev(nlp);
 	if (!mdev) {
 		retcode = ERR_MINOR_INVALID;
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 69dc711..233db5c 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -138,6 +138,7 @@ enum drbd_ret_codes {
 	ERR_VERIFY_RUNNING	= 149, /* DRBD 8.2 only */
 	ERR_DATA_NOT_CURRENT	= 150,
 	ERR_CONNECTED		= 151, /* DRBD 8.3 only */
+	ERR_PERM		= 152,
 
 	/* insert new ones above this line */
 	AFTER_LAST_ERR_CODE


