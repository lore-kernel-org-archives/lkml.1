Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZFWRgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZFWRgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZFWRfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:35:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905AbZFWRfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:35:53 -0400
Date: Tue, 23 Jun 2009 10:34:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, alan@lxorguk.ukuu.org.uk,
       hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, adilger@sun.com,
       akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
In-Reply-To: <17310.1245776720@redhat.com>
Message-ID: <alpine.LFD.2.01.0906231019250.3240@localhost.localdomain>
References: <E1MJ8u3-00083c-TD@pomaz-ex.szeredi.hu> <20090623170610.7fd8a3f8@lxorguk.ukuu.org.uk> <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu> <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu>
 <20090623143408.GA2147@infradead.org> <16370.1245772337@redhat.com> <16755.1245773452@redhat.com>  <17310.1245776720@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Jun 2009, David Howells wrote:

> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Define O_NOACC as 3.  On open(..., O_FILESYSTEM | O_NOACC) require no
> > privileges on the file.
> 
> It must also work with O_NOFOLLOW, which I think your suggestion will.

This does sound like a fairly natural extension of what we already do.

We essentially already have O_NOACCESS (3), and use it exactly because we 
need to do operations on a file descriptor without "real" accesses 
(notably things like accessing /dev/cdrom without waiting/checking for the 
disk being present etc).

O_FILESYSTEM I don't like as a name (to me, it doesn't say _what_ it is 
doing - of course an open works on a filesystem!), but the concept of 
saying "don't follow device nodes - just open the node itself" makes 
perfect sense. Together with O_NOFOLLOW it also fairly naturally means 
"give me the actual symlink _node_, don't return error or follow it".

And we can trivially test at a higher level that O_FILESYSTEM (with a 
better name, please), is always paired with O_NOACCESS (not O_NOACC: we do 
not try to save three letters, there is no shortage). Because the raw node 
obviously must never really be "accessed" (ie you can't do read/write etc 
on it).

That said, I do _not_ like the notion of

	> Add a new inode->i_filesystem_fop pointer

regardless of whether it's in inode->i_op or wherever. I think we should 
just handle this in the regular "inode->f_op->open" routine, the same way 
we handle FMODE_EXCLUSIVE (O_EXCL), FMODE_NDELAY (O_NONBLOCK) and lack of 
access rights (O_NOACCESS) in the driver open routines that currently 
handle those specially (O_NDELAY is spe

Al?

			Linus
