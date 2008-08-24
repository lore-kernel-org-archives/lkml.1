Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYHXPZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYHXPZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYHXPZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:25:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:36330 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751560AbYHXPZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:25:09 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+YqAo6b4GYlJNzwlcx1G3lxX9w3c/JguBPUQIpxp
	KuyDO5oB6FTZXA
Date: Sun, 24 Aug 2008 17:24:54 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: zippel@linux-m68k.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] Fix Buffer overflow in hfsplus with a corrupted image
Message-ID: <20080824152454.GA27964@alice>
References: <20080824130736.GA27742@alice> <84144f020808240814l41be03a6x53d4c521d7d95eb6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <84144f020808240814l41be03a6x53d4c521d7d95eb6@mail.gmail.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.27-rc3 (x86_64)
X-Uptime: 17:20:17 up 5 days,  7:29,  3 users,  load average: 1.56, 0.80,
	0.38
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg (penberg@cs.helsinki.fi) wrote:
> Hi Eric,
> 
> On Sun, Aug 24, 2008 at 4:07 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
> > when an hfsplus image gets corrupted it might happen that the catalog
> > namelength field gets b0rked. If we mount such an image
> > the memcpy() in hfsplus_cat_build_key_uni() writes more than the 255
> > that fit in the name field. Depending on the size of the overwritten
> > data, we either only get memory corruption or also trigger an oops like
> > this:
> >
> > --- linux/fs/hfsplus/catalog.c.orig     2008-08-24 14:52:03.000000000 +0200
> > +++ linux/fs/hfsplus/catalog.c  2008-08-24 14:54:15.000000000 +0200
> > @@ -168,6 +168,11 @@ int hfsplus_find_cat(struct super_block
> >                return -EIO;
> >        }
> >
> > +       if (be16_to_cpu(tmp.thread.nodeName.length) >= 127) {
> > +               printk(KERN_ERR "hfs: catalog name length corrupted\n");
> > +               return -EIO;
> > +       }
> 
> So, where does this 127 come from? I can only find reference to a
> maximum length of 255 unicode characters (16 bits per character) in
> the following technical note for HFS+ (see sections "HFS Plus Names"
> and "Catalog Thread Records"):
> 
>   http://developer.apple.com/technotes/tn/tn1150.html
> 
> Hmm?

Ah, i missed that the name array is __be16, i somehow assumed it was a
char array, and tried to account for the multiplication by 2 in 
hfsplus_cat_build_key_uni(). here is an updated fix.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>

--- linux/fs/hfsplus/catalog.c.orig	2008-08-24 14:52:03.000000000 +0200
+++ linux/fs/hfsplus/catalog.c	2008-08-24 14:54:15.000000000 +0200
@@ -168,6 +168,11 @@ int hfsplus_find_cat(struct super_block 
 		return -EIO;
 	}
 
+	if (be16_to_cpu(tmp.thread.nodeName.length) > 255) {
+		printk(KERN_ERR "hfs: catalog name length corrupted\n");
+		return -EIO;
+	}
+
 	hfsplus_cat_build_key_uni(fd->search_key, be32_to_cpu(tmp.thread.parentID),
 				 &tmp.thread.nodeName);
 	return hfs_brec_find(fd);
