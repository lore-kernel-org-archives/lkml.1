Return-Path: <linux-kernel-owner+w=401wt.eu-S1761480AbYDCAgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480AbYDCAgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760316AbYDCAeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:34:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:39551 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760300AbYDCAeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KI4qS4mViBwND2lm25WB8qpfsb6PmBEoxqUNNIF+KepzHch8tACh1srXWF1VYi4mVR+E8NHqZds5KDkzvbBmuJVhCLhXMqFU/5J6Mw4WatK2+WrNjbdOsK+iyTEdaPTq0SoRAS1mBohs7/uXfkyM2jFiefrnifLd2MUqrSXVVII=
Subject: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 17:33:38 -0700
Message-Id: <1207182818.5740.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1 ? 0 : x

is not valid in contexts where C requires integer constant expressions.
Index in static array initializer is one of those.

Instead of using a non-existant extern function, use 1/0 as the guard
expression to avoid using a gcc-ism.  IOC_TYPECHECK gets pulled into
some static array initializations where this is not valid.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-generic/ioctl.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/ioctl.h b/include/asm-generic/ioctl.h
index cd02729..f5ae529 100644
--- a/include/asm-generic/ioctl.h
+++ b/include/asm-generic/ioctl.h
@@ -47,12 +47,10 @@
 	 ((nr)   << _IOC_NRSHIFT) | \
 	 ((size) << _IOC_SIZESHIFT))
 
-/* provoke compile error for invalid uses of size argument */
-extern unsigned int __invalid_size_argument_for_IOC;
 #define _IOC_TYPECHECK(t) \
 	((sizeof(t) == sizeof(t[1]) && \
 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
-	  sizeof(t) : __invalid_size_argument_for_IOC)
+	  sizeof(t) : 1/0)
 
 /* used to create numbers */
 #define _IO(type,nr)		_IOC(_IOC_NONE,(type),(nr),0)
-- 
1.5.5.rc1.135.g8527

