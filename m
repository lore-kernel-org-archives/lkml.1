Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbZAMPes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbZAMPes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZAMPei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:34:38 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:35413 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZAMPeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:34:37 -0500
X-Greylist: delayed 1182 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 10:34:36 EST
Date: Tue, 13 Jan 2009 16:14:06 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>, jens.axboe@oracle.com,
       Hinko Kocevar <hinko.kocevar@cetrtapot.si>
Cc: linux-kernel@vger.kernel.org
Subject: lib/klist.c: bit 0 in pointer can't be used as flag
Message-ID: <20090113151406.GC19262@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit a1ed5b0cffe4b16a93a6a3390e8cee0fbef94f86
(klist: don't iterate over deleted entries) introduces use of the
low bit in a pointer to indicate if the knode is dead or not,
assuming that this bit is always free.

This is not true for all architectures, CRIS for example may align data
on byte borders.

The result is a bunch of warnings on bootup, devices not being
added correctly etc, reported by Hinko Kocevar <hinko.kocevar@cetrtapot.si>:

------------[ cut here ]------------
WARNING: at lib/klist.c:62 ()
Modules linked in:

Stack from c1fe1cf0:
       c01cc7f4 c1fe1d11 c000eb4e c000e4de 00000000 00000000 c1f4f78f c1f50c2d 
       c01d008c c1fdd1a0 c1fdd1a0 c1fe1d38 c0192954 c1fe0000 00000000 c1fe1dc0 
       00000002 7fffffff c1fe1da8 c0192d50 c1fe1dc0 00000002 7fffffff c1ff9fcc 
Call Trace: [<c000eb4e>] [<c000e4de>] [<c0192954>] [<c0192d50>] [<c001d49e>] [<c000b688>] [<c0192a3c>] 
       [<c000b63e>] [<c000b63e>] [<c001a542>] [<c00b55b0>] [<c00411c0>] [<c00b559c>] [<c01918e6>] [<c0191988>] 
       [<c01919d0>] [<c00cd9c8>] [<c00cdd6a>] [<c0034178>] [<c000409a>] [<c0015576>] [<c0029130>] [<c0029078>] 
       [<c0029170>] [<c0012336>] [<c00b4076>] [<c00b4770>] [<c006d6e4>] [<c006d974>] [<c006dca0>] [<c0028d6c>] 
       [<c0028e12>] [<c0006424>] <4>---[ end trace 4eaa2a86a8e2da22 ]---
------------[ cut here ]------------
Repeat ad nauseam.

The following naive patch fixes the problem by moving the flag to a
separate field in struct klist_node, but perhaps there is a better solution?

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/linux/klist.h |    1 +
 lib/klist.c           |    8 +++-----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/klist.h b/include/linux/klist.h
index d5a27af..e542629 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -40,6 +40,7 @@ struct klist_node {
 	void			*n_klist;	/* never access directly */
 	struct list_head	n_node;
 	struct kref		n_ref;
+	unsigned int		flags;
 };
 
 extern void klist_add_tail(struct klist_node *n, struct klist *k);
diff --git a/lib/klist.c b/lib/klist.c
index 573d606..72ec552 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -43,17 +43,15 @@
  * dead ones from iteration.
  */
 #define KNODE_DEAD		1LU
-#define KNODE_KLIST_MASK	~KNODE_DEAD
 
 static struct klist *knode_klist(struct klist_node *knode)
 {
-	return (struct klist *)
-		((unsigned long)knode->n_klist & KNODE_KLIST_MASK);
+	return (struct klist *)knode->n_klist;
 }
 
 static bool knode_dead(struct klist_node *knode)
 {
-	return (unsigned long)knode->n_klist & KNODE_DEAD;
+	return knode->flags & KNODE_DEAD;
 }
 
 static void knode_set_klist(struct klist_node *knode, struct klist *klist)
@@ -67,7 +65,7 @@ static void knode_kill(struct klist_node *knode)
 {
 	/* and no knode should die twice ever either, see we're very humane */
 	WARN_ON(knode_dead(knode));
-	*(unsigned long *)&knode->n_klist |= KNODE_DEAD;
+	knode->flags |= KNODE_DEAD;
 }
 
 /**



/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
