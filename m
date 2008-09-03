Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbYICRw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbYICRw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbYICRwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:52:47 -0400
Received: from ns1.suse.de ([195.135.220.2]:54197 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbYICRwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:52:46 -0400
Date: Wed, 3 Sep 2008 10:33:05 -0700
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
       alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 11/16] cifs: fix O_APPEND on directio mounts
Message-ID: <20080903173305.GL10429@suse.de>
References: <20080903172849.927077124@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-fix-o_append-on-directio-mounts.patch"
In-Reply-To: <20080903173218.GA10429@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeff Layton <jlayton@redhat.com>

commit 838726c4756813576078203eb7e1e219db0da870 upstream

The direct I/O write codepath for CIFS is done through
cifs_user_write(). That function does not currently call
generic_write_checks() so the file position isn't being properly set
when the file is opened with O_APPEND.  It's also not doing the other
"normal" checks that should be done for a write call.

The problem is currently that when you open a file with O_APPEND on a
mount with the directio mount option, the file position is set to the
beginning of the file. This makes any subsequent writes clobber the data
in the file starting at the beginning.

This seems to fix the problem in cursory testing. It is, however
important to note that NFS disallows the combination of
(O_DIRECT|O_APPEND). If my understanding is correct, the concern is
races with multiple clients appending to a file clobbering each others'
data. Since the write model for CIFS and NFS is pretty similar in this
regard, CIFS is probably subject to the same sort of races. What's
unclear to me is why this is a particular problem with O_DIRECT and not
with buffered writes...

Regardless, disallowing O_APPEND on an entire mount is probably not
reasonable, so we'll probably just have to deal with it and reevaluate
this flag combination when we get proper support for O_DIRECT. In the
meantime this patch at least fixes the existing problem.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/file.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -835,6 +835,10 @@ ssize_t cifs_user_write(struct file *fil
 		return -EBADF;
 	open_file = (struct cifsFileInfo *) file->private_data;
 
+	rc = generic_write_checks(file, poffset, &write_size, 0);
+	if (rc)
+		return rc;
+
 	xid = GetXid();
 
 	if (*poffset > file->f_path.dentry->d_inode->i_size)

-- 
