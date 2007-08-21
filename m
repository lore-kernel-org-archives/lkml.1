Return-Path: <linux-kernel-owner+w=401wt.eu-S1762826AbXHUG7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbXHUG7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbXHUGzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:55:53 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44390 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761124AbXHUGzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:55:51 -0400
Date: Mon, 20 Aug 2007 23:56:11 -0700
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
       alan@lxorguk.ukuu.org.uk, Josh Boyer <jwboyer@gmail.com>,
       Joakim.Tjernlund@transmode.se,
       giulio fedel <giulio.fedel@andorsystems.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 20/20] JFFS2 locking regression fix.
Message-ID: <20070821065611.GU5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jffs2-locking-regression-fix.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

Commit a491486a2087ac3dfc00efb4f838c8d684afaf54 introduced a locking
problem in JFFS2 -- we up() the alloc_sem when we weren't previously
holding it. This leads to all kinds of fun behaviour later.

There was a _reason_ for the
	if (1 /* alternative path needs testing */ ||
which the above-mentioned commit removed :)

Discovered and debugged by Giulio Fedel <giulio.fedel@andorsystems.com>

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jffs2/write.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/jffs2/write.c
+++ b/fs/jffs2/write.c
@@ -553,6 +553,9 @@ int jffs2_do_unlink(struct jffs2_sb_info
 		struct jffs2_full_dirent **prev = &dir_f->dents;
 		uint32_t nhash = full_name_hash(name, namelen);
 
+		/* We don't actually want to reserve any space, but we do
+		   want to be holding the alloc_sem when we write to flash */
+		down(&c->alloc_sem);
 		down(&dir_f->sem);
 
 		while ((*prev) && (*prev)->nhash <= nhash) {

-- 
