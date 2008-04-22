Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbYDVNrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbYDVNrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYDVNrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:47:37 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:10430 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbYDVNrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:47:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=GY5EnQApscUA2F2tNyj7xA1Fu+aCmIatZhEPBZZmZ7F9SfmhS/JQ+IJyx0SYaXSNreU7YqpYY8CaRU5GK9qR6AobZVQstIBRvJFu41OZiwmvN3MKaTbzGeiiy9oqExQd3T6T4W6fo/ddAcr1jVaT7Al5AXp/gvj4dIjwQsdKeA0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: expose no-op xfs_put_perag()
Date: Tue, 22 Apr 2008 15:46:58 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804221532.22701.vda.linux@googlemail.com> <200804221540.12382.vda.linux@googlemail.com>
In-Reply-To: <200804221540.12382.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_SxeDIsUInYBOR5T"
Message-Id: <200804221546.58136.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_SxeDIsUInYBOR5T
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

Inline function xfs_put_perag() in fs/xfs/xfs_mount.h is a no-op.

This patch converts it to no-op macro.

As a result, gcc will emit warning about unused variables,
parameters and so on not in this function, but in its callers,
which is more useful.

This patch, together with previous ones, has already resulted
in more unused params discovered and warned about by gcc.

There is no object code size difference from this change.

Compile tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_SxeDIsUInYBOR5T
Content-Type: text/x-diff;
  charset="koi8-r";
  name="xfs_trivial0-expose-xfs_put_perag-noop.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs_trivial0-expose-xfs_put_perag-noop.patch"

diff -urpN linux-2.6-xfs5/fs/xfs/xfs_mount.h linux-2.6-xfs6/fs/xfs/xfs_mount.h
--- linux-2.6-xfs5/fs/xfs/xfs_mount.h	2008-04-22 04:06:44.000000000 +0200
+++ linux-2.6-xfs6/fs/xfs/xfs_mount.h	2008-04-22 12:13:17.000000000 +0200
@@ -471,11 +471,17 @@ xfs_get_perag(struct xfs_mount *mp, xfs_
 	return &mp->m_perag[XFS_INO_TO_AGNO(mp, ino)];
 }
 
+/* Macro (instead of inline) makes gcc understand that params are not used
+ * and emit "unused" warnings *in callers* if they otherwise are not using
+ * variables passed to xfs_put_perag. We want to know that. */
+#define xfs_put_perag(mp, pag) ((void)0)
+#if 0
 static inline void
 xfs_put_perag(struct xfs_mount *mp, xfs_perag_t *pag)
 {
 	/* nothing to see here, move along */
 }
+#endif
 
 /*
  * Per-cpu superblock locking functions

--Boundary-00=_SxeDIsUInYBOR5T--
