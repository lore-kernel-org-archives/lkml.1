Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbYCCOpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbYCCOpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbYCCOnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:43:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37140 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbYCCOnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:43:52 -0500
Date: Mon, 3 Mar 2008 13:15:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alexander Belyakov <abelyako@googlemail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Subject: Re: jffs2: -ENOSPC when truncating file?!
Message-ID: <20080303121510.GD28369@elf.ucw.cz>
References: <20080223235742.GE2202@elf.ucw.cz> <fe810cf0802242348w625a7e7bj1a5476d6c79662@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe810cf0802242348w625a7e7bj1a5476d6c79662@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  I'm trying to free space by truncating big file, and I get:
> >
> >  root@fic-gta01:~# ls -al gps.nmea
> >  -rw-r--r--    1 root     root      2332070 Feb 19 22:13 gps.nmea
> >  root@fic-gta01:~# > gps.nmea
> >  -sh: cannot create gps.nmea: No space left on device
> >  root@fic-gta01:~# rm gps.nmea
> >  root@fic-gta01:~# > gps.nmea
> >  root@fic-gta01:~#
> >
> >  :-(
> >
> >  Kernel is not-so-ancient, on openmoko:
> 
> Hi!
> 
> JFFS2 has known bug in GC leading to -ENOSPC upon file removal. Time
> ago I've sent a patch with detailed explanations of what is going on.
> Probably your case is the same.
> 
> Here is the patch
> http://lists.infradead.org/pipermail/linux-mtd/2007-December/020091.html
> (though infradead mailing list archive is missing most of messages
> from this thread)
> 
> And here are some details
> http://lists.infradead.org/pipermail/linux-mtd/2007-June/018756.html

Patch is here (I whitespace-damaged it, sorry], and I've seen no
discussion.. should it just be applied?
								Pavel

diff -uNr a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
--- a/fs/jffs2/wbuf.c	2007-05-25 01:22:47.000000000 +0400
+++ b/fs/jffs2/wbuf.c	2007-06-20 18:45:09.000000000 +0400
@@ -117,7 +117,7 @@

 		D1(printk(KERN_DEBUG "Removing eraseblock at 0x%08x
from erasable_pending_wbuf_list...\n", jeb->offset));
 		list_del(this);
-		if ((jiffies + (n++)) & 127) {
+		if (((jiffies + (n++)) & 127) &&
!list_empty(&c->erasable_list)) {
 			/* Most of the time, we just erase it immediately. Otherwise we
 			   spend ages scanning it on mount, etc. */
 			D1(printk(KERN_DEBUG "...and adding to
erase_pending_list\n"));



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
