Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbYACNvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbYACNvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYACNvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:51:31 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58215 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYACNva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:51:30 -0500
Date: Thu, 3 Jan 2008 15:51:28 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
In-Reply-To: <477CE1E0.4010504@gmail.com>
Message-ID: <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI>
References: <477CE1E0.4010504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 3 Jan 2008, Jiri Slaby wrote:
> this happened, while playing with broken dvd.

[snip]

> Buffer I/O error on device sr0, logical block 5441
> end_request: I/O error, dev sr0, sector 136
> ISOFS: unable to read i-node block
> Unable to handle kernel NULL pointer dereference at 00000000000000ad RIP:
>  [<ffffffff802a679f>] d_splice_alias+0x1f/0x100

[snip]

> Call Trace:
>  [<ffffffff880d2395>] :isofs:isofs_lookup+0x395/0x4a0
>  [<ffffffff802a565b>] d_alloc+0x2b/0x1d0
>  [<ffffffff8029a97c>] do_lookup+0x1ac/0x200

Does the following patch fix it?

			Pekka

[PATCH] isofs: check for bad inode in isofs_lookup
From: Pekka Enberg <penberg@cs.helsinki.fi>

If isofs_read_inode() fails to read one of the inode blocks from disk, it
returns a bad inode.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/isofs/namei.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/fs/isofs/namei.c
===================================================================
--- linux-2.6.orig/fs/isofs/namei.c
+++ linux-2.6/fs/isofs/namei.c
@@ -183,6 +183,11 @@ struct dentry *isofs_lookup(struct inode
 			unlock_kernel();
 			return ERR_PTR(-EACCES);
 		}
+		if (is_bad_inode(inode)) {
+			unlock_kernel();
+			iput(inode);
+			return ERR_PTR(-ENOENT);
+		}
 	}
 	unlock_kernel();
 	return d_splice_alias(inode, dentry);
