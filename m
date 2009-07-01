Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbZGAArI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbZGAArI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761145AbZGAAda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:33:30 -0400
Received: from kroah.org ([198.145.64.141]:59938 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761225AbZGAAda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:33:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:54 2009
Message-Id: <20090701001554.551074711@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [patch 35/35] dm: sysfs skip output when device is being destroyed
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=dm-sysfs-skip-output-when-device-is-being-destroyed.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Milan Broz <mbroz@redhat.com>

commit 4d89b7b4e4726893453d0fb4ddbb5b3e16353994 upstream.

Do not process sysfs attributes when device is being destroyed.

Otherwise code can cause
  BUG_ON(test_bit(DMF_FREEING, &md->flags));
in dm_put() call.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1728,6 +1728,10 @@ struct mapped_device *dm_get_from_kobjec
 	if (&md->kobj != kobj)
 		return NULL;
 
+	if (test_bit(DMF_FREEING, &md->flags) ||
+	    test_bit(DMF_DELETING, &md->flags))
+		return NULL;
+
 	dm_get(md);
 	return md;
 }


