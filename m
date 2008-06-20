Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbYFTU6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbYFTU6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbYFTU6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:58:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:40945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbYFTU6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:58:45 -0400
Date: Fri, 20 Jun 2008 13:58:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH, RFC] fasync() BKL pushdown
Message-ID: <20080620135840.562dd4a5@infradead.org>
In-Reply-To: <20080620112914.783be428@bike.lwn.net>
References: <20080620112914.783be428@bike.lwn.net>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 11:29:14 -0600
Jonathan Corbet <corbet@lwn.net> wrote:
> 
> The majority of fasync() functions just call fasync_helper() with a
> pointer to an fasync_struct reachable from the file structure.  Given
> that (1) the struct file will not go away while fasync() is running,
> and (2) the VFS-level fasync() stuff is protected with the Big Fasync
> Lock, I contend that these simple implementations have no need for
> the BKL.  Once those are filtered out, there's really only a
> half-dozen places which need to be fixed.


> Jonathan Corbet (7):
>       mpt: fasync BKL pushdown
>       i2o: fasync BKL pushdown
>       tun: fasync BKL pushdown
>       tty_io: fasync BKL pushdown
>       Bluetooth VHCI: fasync BKL pushdown
>       ecryptfs: fasync BKL pushdown
>       Call fasync() functions without the BKL
> 
> And the actual patch is appended.  If nobody objects, I'll pull these
> into the bkl-removal tree shortly.
> 

looks good to me

only question is if this one is really needed:
+	lock_kernel();
 	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode,
"tty_fasync"))
-		return 0;
+		goto out;
 
 	retval = fasync_helper(fd, filp, on, &tty->fasync);
 	if (retval <= 0)

(given that it just calls the helper.. mostly and that Alan has been
busy removing the BKL from the tty layer)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
