Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbZAHM6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbZAHM6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759962AbZAHM41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:56:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40774 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759135AbZAHM4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:56:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/10] NOMMU: Support XIP on initramfs [ver #3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: bernds_cb1@t-online.de, dhowells@redhat.com, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2009 12:54:37 +0000
Message-ID: <20090108125437.28454.95476.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
References: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support XIP on files unpacked from the initramfs image on NOMMU systems.  This
simply requires the length of the file to be preset so that the ramfs fs can
attempt to garner sufficient contiguous storage to store the file (NOMMU mmap
can only map contiguous RAM).

All the other bits to do XIP on initramfs files are present:

 (1) ramfs's truncate attempts to allocate a contiguous run of pages when a
     file is truncated upwards from nothing.

 (2) ramfs sets BDI on its files to indicate direct mapping is possible, and
     that its files can be mapped for read, write and exec.

 (3) NOMMU mmap() will use the above bits to determine that it can do XIP.
     Possibly this needs better controls, because it will _always_ try and do
     XIP.

One disadvantage of this very simplistic approach is that sufficient space
will be allocated to store the whole file, and not just the bit that would be
XIP'd.  To deal with this, though, the initramfs unpacker would have to be
able to parse the file contents.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---

 init/initramfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/init/initramfs.c b/init/initramfs.c
index 4f5ba75..d9c941c 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -317,6 +317,7 @@ static int __init do_name(void)
 			if (wfd >= 0) {
 				sys_fchown(wfd, uid, gid);
 				sys_fchmod(wfd, mode);
+				sys_ftruncate(wfd, body_len);
 				vcollected = kstrdup(collected, GFP_KERNEL);
 				state = CopyFile;
 			}

