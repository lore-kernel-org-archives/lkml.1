Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbYHRSyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbYHRSyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760746AbYHRSxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:53:48 -0400
Received: from ns.suse.de ([195.135.220.2]:42310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760736AbYHRSxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:53:47 -0400
Date: Mon, 18 Aug 2008 11:43:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
       Gunter Kukkukk <linux@kukkukk.com>, Steve French <sfrench@us.ibm.com>
Subject: [patch 22/60] CIFS: mount of IPC$ breaks with iget patch
Message-ID: <20080818184316.GW29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-mount-of-ipc-breaks-with-iget-patch.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve French <sfrench@us.ibm.com>

commit ad661334b8ae421154b121ee6ad3b56807adbf11 upstream

In looking at network named pipe support on cifs, I noticed that
Dave Howell's iget patch:

    iget: stop CIFS from using iget() and read_inode()

broke mounts to IPC$ (the interprocess communication share), and don't
handle the error case (when getting info on the root inode fails).

Thanks to Gunter who noted a typo in a debug line in the original
version of this patch.

CC: David Howells <dhowells@redhat.com>
CC: Gunter Kukkukk <linux@kukkukk.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -649,6 +649,7 @@ struct inode *cifs_iget(struct super_blo
 		inode->i_fop = &simple_dir_operations;
 		inode->i_uid = cifs_sb->mnt_uid;
 		inode->i_gid = cifs_sb->mnt_gid;
+	} else if (rc) {
 		_FreeXid(xid);
 		iget_failed(inode);
 		return ERR_PTR(rc);

-- 
