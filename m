Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYJ2PnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYJ2PnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYJ2Pmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:42:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52031 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbYJ2Pmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:42:54 -0400
Subject: [PATCH] Capabilities: BUG when an invalid capability is requested
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: morgan@kernel.org, serue@us.ibm.com, arjan@infradead.org
Content-Type: text/plain
Date: Wed, 29 Oct 2008 11:42:12 -0400
Message-Id: <1225294932.23736.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an invalid (large) capability is requested the capabilities system
may panic as it is dereferencing an array of fixed (short) length.  Its
possible (and actually often happens) that the capability system
accidentally stumbled into a valid memory region but it also regularly
happens that it hits invalid memory and BUGs.  If such an operation does
get past cap_capable then the selinux system is sure to have problems as
it already does a (simple) validity check and BUG.  This is known to
happen by the broken and buggy firegl driver.

This patch cleanly checks all capable calls and BUG if a call is for an
invalid capability.  This will likely break the firegl driver for some
situations, but it is the right thing to do.  Garbage into a security
system gets you killed/bugged

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 kernel/capability.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index 33e51e7..50d9d99 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -498,6 +498,11 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
  */
 int capable(int cap)
 {
+	if (unlikely(!cap_valid(cap))) {
+		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
+		BUG();
+	}
+
 	if (has_capability(current, cap)) {
 		current->flags |= PF_SUPERPRIV;
 		return 1;


