Return-Path: <linux-kernel-owner+w=401wt.eu-S932725AbXCISXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbXCISXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932743AbXCISXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:23:03 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43515 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932725AbXCISXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:23:00 -0500
Date: Fri, 9 Mar 2007 10:22:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, take2] VFS : Delay the dentry name generation on sockets
 and pipes.
In-Reply-To: <200703091118.58990.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703091014210.10832@woody.linux-foundation.org>
References: <45ED1A3C.6030707@argo.co.il> <200703081758.07179.dada1@cosmosbay.com>
 <200703081929.58265.dada1@cosmosbay.com> <200703091118.58990.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Mar 2007, Eric Dumazet wrote:
> 
> 	CAUTION : d_path() logic is quite  tricky. 
> 	The correct way to return for example "Hello" is to put it
> 	at the end of the buffer, and returns a pointer to the first char.

Yeah, it's subtle, since it wants to use a single buffer, and not copy 
things around too much.

But can I ask you to do a take3, and simply have a helper function like

	char *dynamic_dname(struct dentry *dentry, char *buffer, int len,
		const char *fmt, ...)
	{
		va_list args;
		char temp[64];
		int i;

		va_start(args, fmt);
		i = vsnprintf(tmp,sizeof(tmp),fmt,args) + 1;
		va_end(args);

		if (i > len)
			return ERR_PTR(-ENAMETOOLONG);

		buffer += len - i;
		memcpy(buffer, tmp, i);
		return buffer;
	}

and just require that everybody use that function.

Then the pipe code would just become

	static char *pipefs_dname(struct dentry *dentry, char *buffer, int buflen)
	{
		return dynamic_dname(dentry, buffer, buflen, ""pipe:[%lu]", dentry->d_inode->i_ino);
	}

and you're done, and you have only *one* place in the VFS layer 
(preferably right next to d_path() itself) that cares about the
subtle issues that we have.

		Linus
