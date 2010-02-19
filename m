Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0BSROQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:14:16 -0500
Received: from kroah.org ([198.145.64.141]:57480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab0BSRA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:29 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:39 2010
Message-Id: <20100219163238.947481398@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [30/93] cifs: fix length calculation for converted unicode readdir names
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit f12f98dba6ea1517cd7fbb912208893b9c014c15 upstream.

cifs_from_ucs2 returns the length of the converted name, including the
length of the NULL terminator. We don't want to include the NULL
terminator in the dentry name length however since that'll throw off the
hash calculation for the dentry cache.

I believe that this is the root cause of several problems that have
cropped up recently that seem to be papered over with the "noserverino"
mount option. More confirmation of that would be good, but this is
clearly a bug and it fixes at least one reproducible problem that
was reported.

This patch fixes at least this reproducer in this kernel.org bug:

    http://bugzilla.kernel.org/show_bug.cgi?id=15088#c12

Reported-by: Bjorn Tore Sund <bjorn.sund@it.uib.no>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/readdir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -666,6 +666,7 @@ static int cifs_get_name_from_search_buf
 					   min(len, max_len), nlt,
 					   cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		pqst->len -= nls_nullsize(nlt);
 	} else {
 		pqst->name = filename;
 		pqst->len = len;


