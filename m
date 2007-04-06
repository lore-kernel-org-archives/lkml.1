Return-Path: <linux-kernel-owner+w=401wt.eu-S1767552AbXDFKJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767552AbXDFKJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767554AbXDFKJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:09:37 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:21687 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767552AbXDFKJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:09:36 -0400
Message-ID: <46161D84.9030706@sw.ru>
Date: Fri, 06 Apr 2007 14:14:28 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC] Lockdep VS rw-semaphores strangeness
Content-Type: multipart/mixed;
 boundary="------------080504060202080201020609"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080504060202080201020609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Ingo, Arjan.

I'm playing with lockdep and have a question about rw-sems.

down_read_trylock() looks like
int down_read_trylock(struct rw_semaphore *sem)
{
        int ret = __down_read_trylock(sem);

        if (ret == 1)
                rwsem_acquire_read(&sem->dep_map, 0, 1, _RET_IP_);
        return ret;
}
i.e. it calls rwsem_acquire_read() with trylock == 1.

But down_write_trylock() -
int down_write_trylock(struct rw_semaphore *sem)
{
        int ret = __down_write_trylock(sem);

        if (ret == 1)
                rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
        return ret;
}
- calls lockdep with trylock set to 0. Why?

I've already caught a fake warning when trying to write-lock
an mm->mmap_sem with another mm's mmap_sem write-locked. With the
patch attached everything works, fine.

Did I miss something?

--------------080504060202080201020609
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
 


--------------080504060202080201020609--
