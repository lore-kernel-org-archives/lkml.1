Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbYHOFch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbYHOFch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 01:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYHOFcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 01:32:25 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:48655 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYHOFcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 01:32:24 -0400
X-Greylist: delayed 1546 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Aug 2008 01:32:24 EDT
Date: Fri, 15 Aug 2008 01:06:13 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080815050613.GJ4422@cs.cmu.edu>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org> <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813000433.GZ28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 01:04:33AM +0100, Al Viro wrote:
> coda:	returns fsck knows what (number of entries, mostly)

Not sure either and I was the one that sent the patch that introduced
that. My closest guess would be that I looked too long at a getdents(2)
manpage, but then again it doesn't really match that either.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
---

If I understood your description, then the following would be the
correct fix. We return 0 as long as we managed to read some entries, and
any non-zero return value from filldir otherwise.

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index c591622..6026b91 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -513,14 +513,14 @@ static int coda_venus_readdir(struct file *coda_file, void *buf,
 
 	if (coda_file->f_pos == 0) {
 		ret = filldir(buf, ".", 1, 0, de->d_inode->i_ino, DT_DIR);
-		if (ret < 0)
+		if (ret != 0)
 			goto out;
 		result++;
 		coda_file->f_pos++;
 	}
 	if (coda_file->f_pos == 1) {
 		ret = filldir(buf, "..", 2, 1, de->d_parent->d_inode->i_ino, DT_DIR);
-		if (ret < 0)
+		if (ret != 0)
 			goto out;
 		result++;
 		coda_file->f_pos++;
@@ -572,7 +572,7 @@ static int coda_venus_readdir(struct file *coda_file, void *buf,
 			ret = filldir(buf, name.name, name.len,
 				      coda_file->f_pos, ino, type);
 			/* failure means no space for filling in this round */
-			if (ret < 0) break;
+			if (ret != 0) break;
 			result++;
 		}
 		/* we'll always have progress because d_reclen is unsigned and
@@ -581,7 +581,7 @@ static int coda_venus_readdir(struct file *coda_file, void *buf,
 	}
 out:
 	kfree(vdir);
-	return result ? result : ret;
+	return result ? 0 : ret;
 }
 
 /* called when a cache lookup succeeds */
