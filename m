Return-Path: <linux-kernel-owner+w=401wt.eu-S934581AbZIEAdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934581AbZIEAdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934566AbZIEAUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:20:41 -0400
Received: from kroah.org ([198.145.64.141]:42061 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934557AbZIEAUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:48 2009
Message-Id: <20090905001448.241227912@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pavel Roskin <proski@gnu.org>, Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 07/71] rt2x00: fix memory corruption in rf cache, add a sanity check
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=rt2x00-fix-memory-corruption-in-rf-cache-add-a-sanity-check.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Pavel Roskin <proski@gnu.org>

commit 6b26dead3ce97d016b57724b01974d5ca5c84bd5 upstream.

Change rt2x00_rf_read() and rt2x00_rf_write() to subtract 1 from the rf
register number.  This is needed because the rf registers are enumerated
starting with one.  The size of the rf register cache is just enough to
hold all registers, so writing to the highest register was corrupting
memory.  Add a check to make sure that the rf register number is valid.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2x00.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -814,13 +814,15 @@ struct rt2x00_dev {
 static inline void rt2x00_rf_read(struct rt2x00_dev *rt2x00dev,
 				  const unsigned int word, u32 *data)
 {
-	*data = rt2x00dev->rf[word];
+	BUG_ON(word < 1 || word > rt2x00dev->ops->rf_size / sizeof(u32));
+	*data = rt2x00dev->rf[word - 1];
 }
 
 static inline void rt2x00_rf_write(struct rt2x00_dev *rt2x00dev,
 				   const unsigned int word, u32 data)
 {
-	rt2x00dev->rf[word] = data;
+	BUG_ON(word < 1 || word > rt2x00dev->ops->rf_size / sizeof(u32));
+	rt2x00dev->rf[word - 1] = data;
 }
 
 /*


