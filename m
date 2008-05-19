Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYESXpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYESXpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbYESXpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:45:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:65183 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbYESXpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:45:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 3/3, RFC] remove BKL from misc_open()
Date: Tue, 20 May 2008 01:34:11 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
References: <13762.1211142411@vena.lwn.net> <200805200107.51659.arnd@arndb.de>
In-Reply-To: <200805200107.51659.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-15?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-15?q?Y=2Ea=5E3zb?=)
 =?iso-8859-15?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-15?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805200134.12801.arnd@arndb.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18TZhIDjxI+MU21mML0SWxNSV4Ys+Twz2nUuuH
 xDfrpNWvAa0HFY7nIZZQkWIswxnuZRAYQWtrcmBsxxBKvTGjsS
 RbYW62xcvlRmMpFkfGtcA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all misc drivers that have an open() function now take the
BKL in there, there is no longer the need to take it in the common
misc_open() function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
Index: linux-2.6/drivers/char/misc.c
===================================================================
--- linux-2.6.orig/drivers/char/misc.c
+++ linux-2.6/drivers/char/misc.c
@@ -50,7 +50,6 @@
 #include <linux/device.h>
 #include <linux/tty.h>
 #include <linux/kmod.h>
-#include <linux/smp_lock.h>
 
 /*
  * Head entry for the doubly linked miscdevice list
@@ -121,7 +120,6 @@ static int misc_open(struct inode * inod
 	int err = -ENODEV;
 	const struct file_operations *old_fops, *new_fops = NULL;
 	
-	lock_kernel();
 	mutex_lock(&misc_mtx);
 	
 	list_for_each_entry(c, &misc_list, list) {
@@ -159,7 +157,6 @@ static int misc_open(struct inode * inod
 	fops_put(old_fops);
 fail:
 	mutex_unlock(&misc_mtx);
-	unlock_kernel();
 	return err;
 }
 

