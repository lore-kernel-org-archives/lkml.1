Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYCaW0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYCaW0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYCaW0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:26:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:59127 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYCaW0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YDtS9KMJmE40XJL0c5o3bE7FFjgcTVOgnMCrf2g9ZAaPwTJi294foLd/xZOyR+gPHxUP7t3wMOa82WJGwCPS5dm2fF06pRqXHTnq+2rxWGUWF8zis8MxiK0d9A97lHsfd+Fr1LIG3O2sP89LAWcwuBXn8PFdbXDIFsCXHaz7Dlc=
Subject: [PATCH] asm-generic: suppress sparse warning in ioctl.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080331215835.GM9785@ZenIV.linux.org.uk>
References: <1206998108.6543.74.camel@brick>
	 <1206999598.6543.76.camel@brick> <20080331215835.GM9785@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 31 Mar 2008 15:26:39 -0700
Message-Id: <1207002399.6543.83.camel@brick>
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
I've confirmed this patch 'fixes' the large blocks of sparse warnings in
static array initializers.

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



