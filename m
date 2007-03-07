Return-Path: <linux-kernel-owner+w=401wt.eu-S2992449AbXCGSwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992449AbXCGSwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422978AbXCGSwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:52:12 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:59712 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422998AbXCGSwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:52:10 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] epoll use a single inode ...
Date: Wed, 7 Mar 2007 19:52:13 +0100
User-Agent: KMail/1.9.5
Cc: Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <45ED1A3C.6030707@argo.co.il> <200703071906.58405.dada1@cosmosbay.com> <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703071952.13219.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Not only might memcpy() do a "prefetch for read" on the source for some
> architectures (which in turn may end up being slow for an address that
> isn't in the TLB, like NULL), but you depend on a very much internal

Well, I hope a prefetch(NULL) is OK because we are doing millions of them (see 
include/linux/list.h :) )

> detail, since it *could* have been using something like
>
> 	memcpy(dname, name->name, name->len+1);
>

Yes very true, I will change that and push to Andrew for mm testing

I was thinking about being able to cache the name into the dentry, do you 
think it's worth the pain ? (its not SMP safe for example...)

static char * pipefs_dname(struct dentry *dentry, char *buffer, int buflen)
{
        if (!dentry->d_iname[0])
                snprintf(dentry->d_iname,
			DNAME_INLINE_LEN_MIN,
			"pipe:[%lu]",
			dentry->d_inode->i_ino);
        strlcpy(buffer, dentry->d_iname, buflen);
        return buffer;
}
