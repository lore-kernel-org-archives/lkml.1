Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbYLCUMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbYLCUMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYLCTyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:33 -0500
Received: from kroah.org ([198.145.64.141]:60281 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753689AbYLCTy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:29 -0500
Date: Wed, 3 Dec 2008 11:52:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Steve French <smfrench@gmail.com>,
       Shirish S Pargaonkar <shirishp@us.ibm.com>,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [patch 056/104] cifs: Fix error in smb_send2
Message-ID: <20081203195248.GE8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-fix-error-in-smb_send2.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve French <sfrench@us.ibm.com>

Backport of upstream commit 61de800d33af585cb7e6f27b5cdd51029c6855cb
for -stable.

[CIFS] fix error in smb_send2

smb_send2 exit logic was strange, and with the previous change
could cause us to fail large
smb writes when all of the smb was not sent as one chunk.

Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifssmb.c   |    2 +-
 fs/cifs/file.c      |    2 +-
 fs/cifs/transport.c |    7 +++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1534,7 +1534,7 @@ CIFSSMBWrite(const int xid, struct cifsT
 	__u32 bytes_sent;
 	__u16 byte_count;
 
-	/* cFYI(1,("write at %lld %d bytes",offset,count));*/
+	/* cFYI(1, ("write at %lld %d bytes",offset,count));*/
 	if (tcon->ses == NULL)
 		return -ECONNABORTED;
 
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1813,7 +1813,7 @@ static int cifs_readpages(struct file *f
 	pTcon = cifs_sb->tcon;
 
 	pagevec_init(&lru_pvec, 0);
-		cFYI(DBG2, ("rpages: num pages %d", num_pages));
+	cFYI(DBG2, ("rpages: num pages %d", num_pages));
 	for (i = 0; i < num_pages; ) {
 		unsigned contig_pages;
 		struct page *tmp_page;
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -291,8 +291,11 @@ smb_send2(struct TCP_Server_Info *server
 		if (rc < 0)
 			break;
 
-		if (rc >= total_len) {
-			WARN_ON(rc > total_len);
+		if (rc == total_len) {
+			total_len = 0;
+			break;
+		} else if (rc > total_len) {
+			cERROR(1, ("sent %d requested %d", rc, total_len));
 			break;
 		}
 		if (rc == 0) {

