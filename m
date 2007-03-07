Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbXCGTHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbXCGTHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965486AbXCGTHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:07:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771AbXCGTHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:07:40 -0500
Date: Wed, 7 Mar 2007 11:07:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <200703071952.13219.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703071059030.5963@woody.linux-foundation.org>
References: <45ED1A3C.6030707@argo.co.il> <200703071906.58405.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org>
 <200703071952.13219.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Eric Dumazet wrote:
> 
> I was thinking about being able to cache the name into the dentry, do you 
> think it's worth the pain ? (its not SMP safe for example...)

Actually, it *can* be SMP-safe, if you do it right. Something like

	len = dentry->d_name.len;

	if (!len) {
		len = snprintf(dentry->d_iname,
			DNAME_INLINE_LEN_MIN,
			"pipe:[%lu]",
			dentry->d_inode->i_ino);
		smp_wmb();
		dentry->d_name.len = len;
	}
	if (len >= buflen)
		len = buflen-1;
	memcpy(buffer, dentry->d_iname, len);
	buffer[len] = 0;
	return buffer;

should work, although it depends on the fact that our snprintf() 
implementation should be "stable" (ie if snprintf() modifies the buffer 
temporarily as it goes along, that would break, but I think our 
vsnprintf is good in that respect).

So you could have two different CPU's doing the snprintf() on the same 
buffer at the same time (and assigning the length at the same time), but 
since they'll write the same thing, you don't really care.

It's a bit subtle, though. And probably not really worth it.

		Linus
