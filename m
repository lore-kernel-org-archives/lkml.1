Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbYLCUVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbYLCUVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYLCT5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:57:39 -0500
Received: from kroah.org ([198.145.64.141]:56516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756079AbYLCT5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:37 -0500
Date: Wed, 3 Dec 2008 11:56:00 -0800
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
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Shirish S Pargaonkar <shirishp@us.ibm.com>,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [patch 077/104] cifs: prevent cifs_writepages() from skipping
	unwritten pages
Message-ID: <20081203195600.GZ8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-prevent-cifs_writepages-from-skipping-unwritten-pages.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit b066a48c9532243894f93a06ca5a0ee2cc21a8dc upstream

prevent cifs_writepages() from skipping unwritten pages

Fixes a data corruption under heavy stress in which pages could be left
dirty after all open instances of a inode have been closed.

In order to write contiguous pages whenever possible, cifs_writepages()
asks pagevec_lookup_tag() for more pages than it may write at one time.
Normally, it then resets index just past the last page written before calling
pagevec_lookup_tag() again.

If cifs_writepages() can't write the first page returned, it wasn't resetting
index, and the next call to pagevec_lookup_tag() resulted in skipping all of
the pages it previously returned, even though cifs_writepages() did nothing
with them.  This can result in data loss when the file descriptor is about
to be closed.

This patch ensures that index gets set back to the next returned page so
that none get skipped.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Cc: Shirish S Pargaonkar <shirishp@us.ibm.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/cifs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1396,7 +1396,10 @@ retry:
 			if ((wbc->nr_to_write -= n_iov) <= 0)
 				done = 1;
 			index = next;
-		}
+		} else
+			/* Need to re-find the pages we skipped */
+			index = pvec.pages[0]->index + 1;
+
 		pagevec_release(&pvec);
 	}
 	if (!scanned && !done) {

