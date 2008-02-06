Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbYBGAOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbYBGAOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbYBFX6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:58:11 -0500
Received: from ns.suse.de ([195.135.220.2]:46217 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188AbYBFX6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:58:09 -0500
Date: Wed, 6 Feb 2008 15:53:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@redhat.com>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@ftp.linux.org.uk>,
       maximilian attems <max@stro.at>
Subject: [patch 42/73] vfs: coredumping fix (CVE-2007-6206)
Message-ID: <20080206235324.GQ13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vfs-coredumping-fix.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Ingo Molnar <mingo@elte.hu>

vfs: coredumping fix

patch c46f739dd39db3b07ab5deb4e3ec81e1c04a91af in mainline

fix: http://bugzilla.kernel.org/show_bug.cgi?id=3043

only allow coredumping to the same uid that the coredumping
task runs under.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Alan Cox <alan@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Acked-by: Al Viro <viro@ftp.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1786,6 +1786,12 @@ int do_coredump(long signr, int exit_cod
 	   but keep the previous behaviour for now. */
 	if (!ispipe && !S_ISREG(inode->i_mode))
 		goto close_fail;
+	/*
+	 * Dont allow local users get cute and trick others to coredump
+	 * into their pre-created files:
+	 */
+	if (inode->i_uid != current->fsuid)
+		goto close_fail;
 	if (!file->f_op)
 		goto close_fail;
 	if (!file->f_op->write)

-- 
