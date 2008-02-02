Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbYBBAbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbYBBAbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763136AbYBBAZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:25:18 -0500
Received: from ns.suse.de ([195.135.220.2]:54706 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763499AbYBBAZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:25:16 -0500
Date: Fri, 1 Feb 2008 16:20:59 -0800
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
Subject: [patch 21/27] vfs: coredumping fix (CVE-2007-6206)
Message-ID: <20080202002059.GV8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vfs-coredumping-fix.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

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
@@ -1561,6 +1561,12 @@ int do_coredump(long signr, int exit_cod
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
