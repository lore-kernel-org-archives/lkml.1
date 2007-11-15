Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbXKOGyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbXKOGyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932153AbXKOGqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:46:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57856 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbXKOGqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:46:51 -0500
Date: Wed, 14 Nov 2007 22:44:14 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roland Dreier <rolandd@cisco.com>
Subject: [patch 07/40] IB/uverbs: Fix checking of userspace object ownership
Message-ID: <20071115064414.GH19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ib-uverbs-fix-checking-of-userspace-object-ownership.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roland Dreier <rolandd@cisco.com>

Upstream as cbfb50e6e2e9c580848c0f51d37c24cdfb1cb704

Commit 9ead190b ("IB/uverbs: Don't serialize with ib_uverbs_idr_mutex")
rewrote how userspace objects are looked up in the uverbs module's
idrs, and introduced a severe bug in the process: there is no checking
that an operation is being performed by the right process any more.
Fix this by adding the missing check of uobj->context in __idr_get_uobj().

Apparently everyone is being very careful to only touch their own
objects, because this bug was introduced in June 2006 in 2.6.18, and
has gone undetected until now.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/core/uverbs_cmd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -147,8 +147,12 @@ static struct ib_uobject *__idr_get_uobj
 
 	spin_lock(&ib_uverbs_idr_lock);
 	uobj = idr_find(idr, id);
-	if (uobj)
-		kref_get(&uobj->ref);
+	if (uobj) {
+		if (uobj->context == context)
+			kref_get(&uobj->ref);
+		else
+			uobj = NULL;
+	}
 	spin_unlock(&ib_uverbs_idr_lock);
 
 	return uobj;

-- 
