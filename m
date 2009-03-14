Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbZCNNNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbZCNNNu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 09:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZCNNNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 09:13:41 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:37496 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZCNNNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 09:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ZOvCkvRXT4LPqCFBIsiAb+SHL4Mw2GZ+qQGWYQ71ElihoiSc2U7nuPY9P7XtHZk010
         QlLEGyPZg2cAnQFN86yiEFLB6RBkWvvMP83DGBk/DTqPJgl82EDe3M7a7tr+srRuZIXo
         PCHJi0V9fyosuyi0AzGTmjaxKce4MMfT9y/ng=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: linux-next: Tree for March 12 (tty)
Date: Sat, 14 Mar 2009 14:11:49 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090311; KDE/4.2.0; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20090312171154.11c6ec31.sfr@canb.auug.org.au>
In-Reply-To: <20090312171154.11c6ec31.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903141411.50185.bzolnier@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 12 March 2009, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090311:

It fails to boot here (both with QEMU and the real hardware):

...
Warning: unable to open an initial console.
Kernel panic - not syncing: Attempted to kill init!
...

I bisected the problem to:

>From 31f8326f981117fc548d292656fa8dbed28bc42b Mon Sep 17 00:00:00 2001
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 12 Mar 2009 10:00:15 +1100
Subject: [PATCH] tty-fix-mismatch-in-lookup-han

The lookup methods return NULL or a pointer. The caller expects an ERR_PTR.
It seems to make sense to just use NULL and return -ENODEV here as it keeps
the code simple and clean and the way it always used to work (effectively)
before the restructure

Problem noticed by Jiri Slaby.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/tty_io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index bc84e12..0cc0c60 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1817,9 +1817,9 @@ got_driver:
 		/* check whether we're reopening an existing tty */
 		tty = tty_driver_lookup_tty(driver, inode, index);
 
-		if (IS_ERR(tty)) {
+		if (tty == NULL) {
 			mutex_unlock(&tty_mutex);
-			return PTR_ERR(tty);
+			return -ENODEV;
 		}
 	}
 
-- 

It seems that fixing IS_ERR() check uncovered some underlying problem
since we are later checking for tty == NULL in __tty_open().

The following patch fixes the issue for me (Alan, feel free to merge
it back into your tty-fix-mismatch-in-lookup-han patch or replace by
a more complete __tty_open() reorganization):

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] tty: fix __tty_open()

On tty_driver_lookup_tty() failure __tty_open() should continue
instead of returning an error, fix it.

Also update tty_driver_lookup_tty() documentation while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/char/tty_io.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: b/drivers/char/tty_io.c
===================================================================
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1205,7 +1205,7 @@ static void tty_line_name(struct tty_dri
  *	@driver: the driver for the tty
  *	@idx:	 the minor number
  *
- *	Return the tty, if found or ERR_PTR() otherwise.
+ *	Return the tty, if found or NULL otherwise.
  *
  *	Locking: tty_mutex must be held. If tty is found, the mutex must
  *	be held until the 'fast-open' is also done. Will change once we
@@ -1813,16 +1813,10 @@ retry_open:
 		return -ENODEV;
 	}
 got_driver:
-	if (!tty) {
+	if (!tty)
 		/* check whether we're reopening an existing tty */
 		tty = tty_driver_lookup_tty(driver, inode, index);
 
-		if (tty == NULL) {
-			mutex_unlock(&tty_mutex);
-			return -ENODEV;
-		}
-	}
-
 	if (tty) {
 		retval = tty_reopen(tty);
 		if (retval)
