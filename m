Return-Path: <linux-kernel-owner+w=401wt.eu-S1764744AbYHRTdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764744AbYHRTdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933339AbYHRTcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:32:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:41143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334AbYHRTcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:32:32 -0400
Date: Mon, 18 Aug 2008 12:19:58 -0700
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
Subject: [patch 19/49] CIFS: mount of IPC$ breaks with iget patch
Message-ID: <20080818191958.GT10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-mount-of-ipc-breaks-with-iget-patch.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

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
@@ -639,6 +639,7 @@ struct inode *cifs_iget(struct super_blo
 		inode->i_fop = &simple_dir_operations;
 		inode->i_uid = cifs_sb->mnt_uid;
 		inode->i_gid = cifs_sb->mnt_gid;
+	} else if (rc) {
 		_FreeXid(xid);
 		iget_failed(inode);
 		return ERR_PTR(rc);

-- 
