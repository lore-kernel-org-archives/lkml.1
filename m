Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZFWUEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZFWUEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZFWUEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:04:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51519 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZFWUEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:04:35 -0400
To: torvalds@linux-foundation.org
CC: dhowells@redhat.com, miklos@szeredi.hu, alan@lxorguk.ukuu.org.uk,
       hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, adilger@sun.com,
       akpm@linux-foundation.org
In-reply-to: <alpine.LFD.2.01.0906231019250.3240@localhost.localdomain>
	(message from Linus Torvalds on Tue, 23 Jun 2009 10:34:49 -0700 (PDT))
Subject: Re: [RFC] O_NOACC: open without any access
References: <E1MJ8u3-00083c-TD@pomaz-ex.szeredi.hu> <20090623170610.7fd8a3f8@lxorguk.ukuu.org.uk> <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu> <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu>
 <20090623143408.GA2147@infradead.org> <16370.1245772337@redhat.com> <16755.1245773452@redhat.com>  <17310.1245776720@redhat.com> <alpine.LFD.2.01.0906231019250.3240@localhost.localdomain>
Message-Id: <E1MJCDy-0008Tk-Un@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Jun 2009 22:04:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Linus Torvalds wrote:
> On Tue, 23 Jun 2009, David Howells wrote:
> 
> > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > Define O_NOACC as 3.  On open(..., O_FILESYSTEM | O_NOACC) require no
> > > privileges on the file.
> > 
> > It must also work with O_NOFOLLOW, which I think your suggestion will.
> 
> This does sound like a fairly natural extension of what we already do.
> 
> We essentially already have O_NOACCESS (3), and use it exactly because we 
> need to do operations on a file descriptor without "real" accesses 
> (notably things like accessing /dev/cdrom without waiting/checking for the 
> disk being present etc).
> 
> O_FILESYSTEM I don't like as a name (to me, it doesn't say _what_ it is 
> doing - of course an open works on a filesystem!), but the concept of 
> saying "don't follow device nodes - just open the node itself" makes 
> perfect sense. Together with O_NOFOLLOW it also fairly naturally means 
> "give me the actual symlink _node_, don't return error or follow it".

O_NODEV?  It applies just as well to fifos, sockets and symlinks, but
it's hard to express that in a compact way.

> That said, I do _not_ like the notion of
> 
> 	> Add a new inode->i_filesystem_fop pointer
> 
> regardless of whether it's in inode->i_op or wherever. I think we should 
> just handle this in the regular "inode->f_op->open" routine, the same way 

No, it's a totally different open, one comes from the device/fifo
code, the other from the filesystem.  Yes, the filesystem could
in theory wedge itself between the VFS and device's f_ops.  Not
sure if that's how this should be done, though...

Also how should the default case (filesystem doesn't handle
O_NODEV) be handled.  The nice thing about O_NODEV | O_NOACCESS
would be that it could be implemented totally in generic code in
a secure way and it would even be useful for a variety of
cases.

Thanks,
Miklos
