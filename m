Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYKLAoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYKLAoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYKLA1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:27:11 -0500
Received: from kroah.org ([198.145.64.141]:42720 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753928AbYKLA1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:27:06 -0500
Date: Tue, 11 Nov 2008 16:24:35 -0800
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
       alan@lxorguk.ukuu.org.uk, Roman Zippel <zippel@linux-m68k.org>,
       Eric Sesterhenn <snakebyte@gmx.de>
Subject: [patch 48/49] hfs: fix namelength memory corruption (CVE-2008-5025)
Message-ID: <20081112002435.GW10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hfs-fix-namelength-memory-corruption.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sesterhenn <snakebyte@gmx.de>

commit d38b7aa7fc3371b52d036748028db50b585ade2e upstream

Fix a stack corruption caused by a corrupted hfs filesystem.  If the
catalog name length is corrupted the memcpy overwrites the catalog btree
structure.  Since the field is limited to HFS_NAMELEN bytes in the
structure and the file format, we throw an error if it is too long.

Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/hfs/catalog.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -190,6 +190,10 @@ int hfs_cat_find_brec(struct super_block
 
 	fd->search_key->cat.ParID = rec.thread.ParID;
 	len = fd->search_key->cat.CName.len = rec.thread.CName.len;
+	if (len > HFS_NAMELEN) {
+		printk(KERN_ERR "hfs: bad catalog namelength\n");
+		return -EIO;
+	}
 	memcpy(fd->search_key->cat.CName.name, rec.thread.CName.name, len);
 	return hfs_brec_find(fd);
 }

-- 
