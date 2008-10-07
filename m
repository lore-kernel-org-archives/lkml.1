Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYJGAtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYJGAtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbYJGAnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:47 -0400
Received: from mail.suse.de ([195.135.220.2]:46778 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbYJGAnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:46 -0400
Date: Mon, 6 Oct 2008 17:38:31 -0700
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
       alan@lxorguk.ukuu.org.uk, Joel Becker <Joel.Becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [patch 25/71] ocfs2: Increment the reference count of an
	already-active stack.
Message-ID: <20081007003831.GZ3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ocfs2-increment-the-reference-count-of-an-already-active-stack.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Joel Becker <Joel.Becker@oracle.com>

commit d6817cdbd143f87f9d7c59a4c3194091190eeb84 upstream

The ocfs2_stack_driver_request() function failed to increment the
refcount of an already-active stack.  It only did the increment on the
first reference.  Whoops.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Tested-by: Marcos Matsunaga <marcos.matsunaga@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/stackglue.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -97,13 +97,14 @@ static int ocfs2_stack_driver_request(co
 		goto out;
 	}
 
-	/* Ok, the stack is pinned */
-	p->sp_count++;
 	active_stack = p;
-
 	rc = 0;
 
 out:
+	/* If we found it, pin it */
+	if (!rc)
+		active_stack->sp_count++;
+
 	spin_unlock(&ocfs2_stack_lock);
 	return rc;
 }

-- 
