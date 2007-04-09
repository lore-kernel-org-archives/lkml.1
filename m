Return-Path: <linux-kernel-owner+w=401wt.eu-S1749667AbXDIJwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1749667AbXDIJwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 05:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXDIJwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 05:52:04 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:25399 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXDIJwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 05:52:03 -0400
Message-ID: <461A0DDC.5060709@sw.ru>
Date: Mon, 09 Apr 2007 13:56:44 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Lockdep treats down_write_trylock like regular down_write
Content-Type: multipart/mixed;
 boundary="------------080507010603020204060803"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080507010603020204060803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This causes constructions like

down_write(&mm1->mmap_sem);
if (down_write_trylock(&mm2->mmap_sem)) {
       ...
       up_write(&mm2->mmap_sem);
}
up_write(&mm1->mmap_sem);

generate a lockdep warning about circular locking dependence.

Call rwsem_acquire() with trylock set to 1.

--------------080507010603020204060803
Content-Type: text/plain;
 name="diff-lockdep-rwsem-trylock"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-lockdep-rwsem-trylock"

--- ./kernel/rwsem.c.pbonrem	2007-03-06 19:09:50.000000000 +0300
+++ ./kernel/rwsem.c	2007-04-06 14:02:18.000000000 +0400
@@ -60,7 +60,7 @@ int down_write_trylock(struct rw_semapho
 	int ret = __down_write_trylock(sem);
 
 	if (ret == 1)
-		rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
+		rwsem_acquire(&sem->dep_map, 0, 1, _RET_IP_);
 	return ret;
 }
 


--------------080507010603020204060803--
