Return-Path: <linux-kernel-owner+w=401wt.eu-S965446AbXCGSbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965446AbXCGSbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965424AbXCGSbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:31:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47495 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965458AbXCGSbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:31:01 -0500
Date: Wed, 7 Mar 2007 10:30:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <200703071906.58405.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org>
References: <45ED1A3C.6030707@argo.co.il> <200703071831.36930.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703070934480.5963@woody.linux-foundation.org>
 <200703071906.58405.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Eric Dumazet wrote:
> 
> OK no problem here is the patch without messing f_path.mnt 

All right. I like it. Definitely worth putting into -mm, or just 
re-sending to me after 2.6.21 is out (I'll forget all about it otherwise).

I have one more worry, namely this::

	-       char name[32];
	-       this.len = sprintf(name, "[%lu]", SOCK_INODE(sock)->i_ino);
	-       this.name = name;
	+       this.len = 0;
	+       this.name = NULL;

I think that's fine, and it *happens* to work, but it happens to work just 
because then d_alloc() will do:

	memcpy(dname, name->name, name->len);
	dname[name->len] = 0;

and passing in NULL to memcpy() is generally ok when len is 0.

HOWEVER. 

Not only might memcpy() do a "prefetch for read" on the source for some 
architectures (which in turn may end up being slow for an address that 
isn't in the TLB, like NULL), but you depend on a very much internal 
detail, since it *could* have been using something like

	memcpy(dname, name->name, name->len+1);

instead, and expected to get the final '\0' character from the source 
string.

So I would actually much prefer it to be written as

	this.len = 0;
	this.name = "";

just because it's safer.

But other than that small detail, I think this is not only an 
optimization, it's an actual cleanup, and we migth some day want to use 
something like this for some other things too (eg maybe this kind of 
approach is usable for /proc/<pid> entries too, to avoid instantiating 
them).

As to avoiding the mntget(), I'm not violently opposed to it, but I do 
think that it's a totally unrelated matter, so even if it's decided it's 
worth it, it should be done as a separate patch regardless.

			Linus
