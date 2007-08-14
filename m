Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbXHNHwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbXHNHwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbXHNHqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:46:43 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55421 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbXHNHqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:46:22 -0400
Date: Tue, 14 Aug 2007 00:29:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gurudas.pai@oracle.com, zach.brown@oracle.com,
       joe.jin@oracle.com, pbadari@us.ibm.com
Subject: [patch 08/12] direct-io: fix error-path crashes
Message-ID: <20070814072929.GI15025@kroah.com>
References: <20070814072244.882283903@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="direct-io-fix-error-path-crashes.patch"
In-Reply-To: <20070814072813.GA15025@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Badari Pulavarty <pbadari@us.ibm.com>

Need to initialize map_bh.b_state to zero.  Otherwise, in case of a faulty
user-buffer its possible to go into dio_zero_block() and submit a page by
mistake - since it checks for buffer_new().

http://marc.info/?l=linux-kernel&m=118551339032528&w=2

akpm: Linus had a (better) patch to just do a kzalloc() in there, but it got
lost.  Probably this version is better for -stable anwyay.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Joe Jin <joe.jin@oracle.com>
Acked-by: Zach Brown <zach.brown@oracle.com>
Cc: gurudas pai <gurudas.pai@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/direct-io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -974,6 +974,7 @@ direct_io_worker(int rw, struct kiocb *i
 	dio->get_block = get_block;
 	dio->end_io = end_io;
 	dio->map_bh.b_private = NULL;
+	dio->map_bh.b_state = 0;
 	dio->final_block_in_bio = -1;
 	dio->next_block_for_io = -1;
 

-- 
