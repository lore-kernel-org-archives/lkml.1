Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbXEYFrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbXEYFrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbXEYFrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:47:16 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbXEYFrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:47:16 -0400
Date: Thu, 24 May 2007 22:47:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Anton Altaparmakov <aia21@cantab.net>
Subject: Re: 2.6.22-rc2-mm1 NTFS & SLUB related fix
Message-Id: <20070524224709.0719acfe.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0705242222n2414a66bo97d20c82c6a497e4@mail.gmail.com>
References: <a8e1da0705242201r13a26d92hcb0059f55e15a24a@mail.gmail.com>
	<Pine.LNX.4.64.0705242202340.1327@schroedinger.engr.sgi.com>
	<a8e1da0705242222n2414a66bo97d20c82c6a497e4@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 05:22:50 +0000 "young dave" <hidave.darkstar@gmail.com> wrote:

> Hi,
> 
> > Is this ntfs_init_locked_inode?
> 
> Yes, it is.
> 
> > >  Bytes b4 0xc2959e28:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a
> > >    Object 0xc2959e38:  24 00 51 00 00 00 6b a5
> > >   Redzone 0xc2959e40:  00 00 cc cc
> >
> > First two bytes after the object overwritten. The allocation for this
> > object should have been two bytes longer.
> >
> > > Last alloc: ntfs_init_locked_inode+0x9e/0x110 jiffies_ago=5140 cpu=0 pid=1604
> >
> > This is the function that allocated a too short object.
> >
> 
> Only the last one byte of  the string  is zeroed, but It malloced 2
> more byte appended the string because size of thentfschar type is 2
> bytes , is this the reason? But why?
> 

Thing is, ntfs_inode.name[] is an array of le16's.  But local variable `i'
in there is a byte index, not an le16 index.  We end up writing that 0x0000
at twice the intended offset.

So I think this was meant:

--- a/fs/ntfs/inode.c~a
+++ a/fs/ntfs/inode.c
@@ -140,7 +140,7 @@ static int ntfs_init_locked_inode(struct
 		if (!ni->name)
 			return -ENOMEM;
 		memcpy(ni->name, na->name, i);
-		ni->name[i] = 0;
+		ni->name[na->name_len] = 0;
 	}
 	return 0;
 }
_

