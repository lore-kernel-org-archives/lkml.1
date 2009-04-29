Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbZD2W2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbZD2W2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbZD2WV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:27 -0400
Received: from kroah.org ([198.145.64.141]:40378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbZD2WVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:26 2009
Message-Id: <20090429220925.948430238@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:19 -0700
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
       alan@lxorguk.ukuu.org.uk
Subject: [patch 20/58] mm: do_xip_mapping_read: fix length calculation
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0031-mm-do_xip_mapping_read-fix-length-calculation.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

upstream commit: 58984ce21d315b70df1a43644df7416ea7c9bfd8

The calculation of the value nr in do_xip_mapping_read is incorrect.  If
the copy required more than one iteration in the do while loop the copies
variable will be non-zero.  The maximum length that may be passed to the
call to copy_to_user(buf+copied, xip_mem+offset, nr) is len-copied but the
check only compares against (nr > len).

This bug is the cause for the heap corruption Carsten has been chasing
for so long:

---
 mm/filemap_xip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -89,8 +89,8 @@ do_xip_mapping_read(struct address_space
 			}
 		}
 		nr = nr - offset;
-		if (nr > len)
-			nr = len;
+		if (nr > len - copied)
+			nr = len - copied;
 
 		error = mapping->a_ops->get_xip_mem(mapping, index, 0,
 							&xip_mem, &xip_pfn);


