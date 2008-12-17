Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759919AbYLQAGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbYLQAGm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbYLQAFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:05:54 -0500
Received: from kroah.org ([198.145.64.141]:41218 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757688AbYLQAFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:05:53 -0500
Date: Tue, 16 Dec 2008 16:04:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Manfred Spraul <manfred@colorfullife.com>
Subject: [patch 05/22] lib/idr.c: Fix bug introduced by RCU fix
Message-ID: <20081217000407.GF4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="lib-idr.c-fix-bug-introduced-by-rcu-fix.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Manfred Spraul <manfred@colorfullife.com>

commit 711a49a07f84f914aac26a52143f6e7526571143 upstream.

The last patch to lib/idr.c caused a bug if idr_get_new_above() was
called on an empty idr.

Usually, nodes stay on the same layer.  New layers are added to the top
of the tree.

The exception is idr_get_new_above() on an empty tree: In this case, the
new root node is first added on layer 0, then moved upwards.  p->layer
was not updated.

As usual: You shall never rely on the source code comments, they will
only mislead you.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/idr.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/idr.c
+++ b/lib/idr.c
@@ -220,8 +220,14 @@ build_up:
 	 */
 	while ((layers < (MAX_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
 		layers++;
-		if (!p->count)
+		if (!p->count) {
+			/* special case: if the tree is currently empty,
+			 * then we grow the tree by moving the top node
+			 * upwards.
+			 */
+			p->layer++;
 			continue;
+		}
 		if (!(new = get_from_free_list(idp))) {
 			/*
 			 * The allocation failed.  If we built part of

