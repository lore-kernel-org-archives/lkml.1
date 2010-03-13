Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935984Ab0CMA6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:58:53 -0500
Received: from kroah.org ([198.145.64.141]:46768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935383Ab0CMAbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:06 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:08 2010
Message-Id: <20100313002708.041653711@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>
Subject: [032/145] idr: fix a critical misallocation bug, take#2
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Tejun Heo <tj@kernel.org>

commit d2e7276b6b5e4bc2148891a056d5862c5314342d upstream.

This is retry of reverted 859ddf09743a8cc680af33f7259ccd0fd36bfe9d
("idr: fix a critical misallocation bug") which contained two bugs.

* pa[idp->layers] should be cleared even if it's not used by
  sub_alloc() because it's used by mark idr_mark_full().

* The original condition check also assigned pa[l] to p which the new
  code didn't do thus leaving p pointing at the wrong layer.

Both problems have been fixed and the idr code has received good amount
testing using userland testing setup where simple bitmap allocator is
run parallel to verify the result of idr allocation.

The bug this patch fixes is caused by sub_alloc() optimization path
bypassing out-of-room condition check and restarting allocation loop
with starting value higher than maximum allowed value.  For detailed
description, please read commit message of 859ddf09.

Signed-off-by: Tejun Heo <tj@kernel.org>
Based-on-patch-from: Eric Paris <eparis@redhat.com>
Reported-by: Eric Paris <eparis@redhat.com>
Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Tested-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/idr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/idr.c
+++ b/lib/idr.c
@@ -156,10 +156,12 @@ static int sub_alloc(struct idr *idp, in
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
 			/* if already at the top layer, we need to grow */
-			if (!(p = pa[l])) {
+			if (id >= 1 << (idp->layers * IDR_BITS)) {
 				*starting_id = id;
 				return IDR_NEED_TO_GROW;
 			}
+			p = pa[l];
+			BUG_ON(!p);
 
 			/* If we need to go up one layer, continue the
 			 * loop; otherwise, restart from the top.


