Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbZKLHtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbZKLHtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZKLHtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:49:41 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:56089 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbZKLHtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:49:40 -0500
Date: Thu, 12 Nov 2009 08:49:44 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: al@alarsen.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/4] fs/qnx4: decrement sizeof size in strncmp
Message-ID: <Pine.LNX.4.64.0911120849260.16627@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As observed by Joe Perches, sizeof of a constant string includes the
trailing 0.  If what is wanted is to check the initial characters of
another string, this trailing 0 should not be taken into account.  If an
exact match is wanted, strcmp should be used instead.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression foo;
constant char *abc;
@@

strncmp(foo, abc, 
- sizeof(abc)
+ sizeof(abc)-1
 )
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/qnx4/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 449f5a6..0614b00 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -221,7 +221,9 @@ static const char *qnx4_checkroot(struct super_block *sb)
 				rootdir = (struct qnx4_inode_entry *) (bh->b_data + i * QNX4_DIR_ENTRY_SIZE);
 				if (rootdir->di_fname != NULL) {
 					QNX4DEBUG((KERN_INFO "rootdir entry found : [%s]\n", rootdir->di_fname));
-					if (!strncmp(rootdir->di_fname, QNX4_BMNAME, sizeof QNX4_BMNAME)) {
+					if (!strncmp(rootdir->di_fname,
+						     QNX4_BMNAME,
+						     sizeof QNX4_BMNAME - 1)) {
 						found = 1;
 						qnx4_sb(sb)->BitMap = kmalloc( sizeof( struct qnx4_inode_entry ), GFP_KERNEL );
 						if (!qnx4_sb(sb)->BitMap) {
