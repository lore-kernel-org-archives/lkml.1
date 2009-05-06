Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbZEFWKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbZEFWKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761545AbZEFVy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:56 -0400
Received: from kroah.org ([198.145.64.141]:57262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761501AbZEFVyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:00 2009
Message-Id: <20090506214800.421097123@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:05 -0700
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
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 37/58] Kill unsharing fs_struct in __set_personality()
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=kill-unsharing-fs_struct-in-__set_personality.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 11d06b2a1e5658f448a308aa3beb97bacd64a940 upstream.

That's a rudiment of altroot support.  I.e. it should've been buried
a long time ago.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/kernel/exec_domain.c
+++ b/kernel/exec_domain.c
@@ -145,28 +145,6 @@ __set_personality(u_long personality)
 		return 0;
 	}
 
-	if (atomic_read(&current->fs->count) != 1) {
-		struct fs_struct *fsp, *ofsp;
-
-		fsp = copy_fs_struct(current->fs);
-		if (fsp == NULL) {
-			module_put(ep->module);
-			return -ENOMEM;
-		}
-
-		task_lock(current);
-		ofsp = current->fs;
-		current->fs = fsp;
-		task_unlock(current);
-
-		put_fs_struct(ofsp);
-	}
-
-	/*
-	 * At that point we are guaranteed to be the sole owner of
-	 * current->fs.
-	 */
-
 	current->personality = personality;
 	oep = current_thread_info()->exec_domain;
 	current_thread_info()->exec_domain = ep;


