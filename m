Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbZGIKAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbZGIKAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbZGIKAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:00:04 -0400
Received: from gg.genua.de ([151.136.100.2]:2003 "EHLO gg.genua.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbZGIKAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:00:04 -0400
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2009 06:00:03 EDT
From: Sten Spans <Sten_Spans@genua.de>
Date: Thu, 9 Jul 2009 11:45:44 +0200
To: linux-kernel@vger.kernel.org
Subject: security_file_lock cmd argument
Message-ID: <20090709094544.GA23769@false>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was playing around with the security_file_lock hook which
is invoked from fs/locks.c. The desciption in include/linux/security.h
states the following:

 * @file_lock:
 *      Check permission before performing file locking operations.
 *      Note: this hook mediates both flock and fcntl style locks.
 *      @file contains the file structure.
 *      @cmd contains the posix-translated lock operation to perform
 *      (e.g. F_RDLCK, F_WRLCK).

However when invoked via sys_flock:

SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
{
..
        error = security_file_lock(filp, cmd);

Which results in passing flock style arguments (LOCK_*) rather
than fcntl (F_*LCK). This also is inconsistent with the two
other security_file_lock invocations in the same file.
This one-liner fixes the issue:

--- fs/locks.c.orig	2009-07-09 11:26:45.000000000 +0200
+++ fs/locks.c	2009-07-09 11:27:24.000000000 +0200
@@ -1590,7 +1590,7 @@
 	if (can_sleep)
 		lock->fl_flags |= FL_SLEEP;
 
-	error = security_file_lock(filp, cmd);
+	error = security_file_lock(filp, lock->fl_type);
 	if (error)
 		goto out_free;
 
-- 
GeNUA Gesellschaft für Netzwerk - und Unix-Administration mbH
Domagkstr. 7, D-85551 Kirchheim. http://www.genua.de
Tel: (089) 99 19 50-0, Fax: (089) 99 19 50 - 999
 
 Geschäftsführer: Dr. Magnus Harlander, Dr. Michaela Harlander,
 Bernhard Schneck. Amtsgericht München HRB 98238
