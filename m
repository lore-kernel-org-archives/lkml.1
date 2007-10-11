Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbXJKHkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbXJKHkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbXJKHkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:40:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045AbXJKHkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:40:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <470D7443.6030206@tiscali.nl>
References: <470D7443.6030206@tiscali.nl> <20071010214308.17535.5406.stgit@warthog.procyon.org.uk> <20071010214354.17535.22412.stgit@warthog.procyon.org.uk>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: dhowells@redhat.com, hch@infradead.org, viro@ftp.linux.org.uk,
       torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/31] IGET: Stop BFS from using iget() and read_inode() [try #3]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 11 Oct 2007 08:39:40 +0100
Message-ID: <30783.1192088380@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <12o3l@tiscali.nl> wrote:

> > +	if (IS_ERR(inode))
> > +		return ERR_PTR(-ENOMEM);
> > +	if (!(inode->i_state & I_NEW))
> > +		return inode;
> 
> Don't you have to unlock_new_inode(inode) before returning?

In the first case, no because an OOM error was returned rather than an inode,
and in the second case, no because an extant non-locked inode was returned.

The inode is only returned locked by iget_locked() if it is also new - in
which case we don't return in either of the above two statements.

> > +error:
> 
> and also here?
> 
> > +	iget_failed(inode);
> > +	return ERR_PTR(-EIO);

Take a look at what iget_failed() does (patch #3):

	void iget_failed(struct inode *inode)
	{
		make_bad_inode(inode);
		unlock_new_inode(inode);
		iput(inode);
	}

David
