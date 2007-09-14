Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbXINKLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbXINKLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXINKLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:11:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:5755 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbXINKLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Q4z8uAW7Y0cz0gwzhsvXn+n1W7/wRjvJNG+ziH0VU+90dw1fOyiA59uK8JC9AZ5VdGRXnXFU/Tu2fqbCQq6zvIOZIjpld1IzxTjTk/scA0TZvQbz2F6OGOsla1CWNjlqplnDJX63O8ApRMhkXJGSbQdcuZBj3E0hCRJGjJaFQnY=
Date: Fri, 14 Sep 2007 18:10:19 +0800
From: lepton <ytht.net@gmail.com>
To: reiserfs-dev@namesys.com
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: [PATCH] 2.6.22.6 fix kernel panic on corrupted reiserfs directory
Message-ID: <20070914101019.GA12437@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  When reading corrupted reiserfs directory data, d_reclen
  could be a negative number or a big positive number, this
  can lead to kernel panic or oop.
  The following patch adds a sanity check. (against 2.6.20.4)

Signed-off-by: Lepton Wu <ytht.net@gmail.com>

diff -X linux-2.6.22.6-lepton/Documentation/dontdiff -pru linux-2.6.22.6/fs/reiserfs/dir.c linux-2.6.22.6-lepton/fs/reiserfs/dir.c
--- linux-2.6.22.6/fs/reiserfs/dir.c	2007-09-14 17:41:15.000000000 +0800
+++ linux-2.6.22.6-lepton/fs/reiserfs/dir.c	2007-09-14 18:02:10.000000000 +0800
@@ -121,6 +121,16 @@ static int reiserfs_readdir(struct file 
 					continue;
 				d_reclen = entry_length(bh, ih, entry_num);
 				d_name = B_I_DEH_ENTRY_FILE_NAME(bh, ih, deh);
+
+				if (d_reclen <= 0 ||
+				    d_name + d_reclen > bh->b_data + bh->b_size) {
+					/* There is corrupted data in entry,
+					 * We'd better stop here */
+					pathrelse(&path_to_entry);
+					ret = -EIO;
+					goto out;
+				}
+		
 				if (!d_name[d_reclen - 1])
 					d_reclen = strlen(d_name);
 
