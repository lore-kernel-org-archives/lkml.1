Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbXIUNAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbXIUNAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbXIUNAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:00:30 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:49694 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbXIUNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:00:29 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070921124323.GA8088@infradead.org> (message from Christoph
	Hellwig on Fri, 21 Sep 2007 13:43:23 +0100)
Subject: Re: [patch 3/5] VFS: pass open file to ->xattr()
References: <20070921122343.307289079@szeredi.hu> <20070921123333.247493758@szeredi.hu> <20070921124323.GA8088@infradead.org>
Message-Id: <E1IYi74-0001dX-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Sep 2007 15:00:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Sep 21, 2007 at 02:23:46PM +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Pass the open file into the filesystem's *xattr() methods.
> > 
> > This is needed to be able to correctly implement open-unlink-f*xattr
> > semantics, without having to resort to "silly-renaming".
> > 
> > Do this by adding a 'struct file *' parameter to i_op->*xattr().  For
> > f... variants pass the open file pointer, in other cases pass NULL.
> > 
> > This is safe from a compatibility standpoint, out-of-tree old stuff
> > will continue to work, but will get a warning at compile time.
> 
> NACK, no more optional arguments, and passing file structs to xattr
> stuff is silly.  If your filesystem doesn't get open but unliked
> right you will have to resort to silly renaming, I'm sorry.
> 
> Same argument applies to all pass file down patches in the series,
> I won't comment on the separately.

I don't think it's silly.  Read/write get passed the file descriptor,
and it makes a lot of sense, if the filesystem has stateful opens.

Similarly for any fs operation that gets a file descriptor, it makes
sense to pass the relevant open file down into the filesystem.

If you look carefully, the ftrunacate() already does this, becuse
without that it's impossible to implement correct semantics in the
filesystem in some cases.

For other operations it's not impossible, but it would mean more hacks
in the filesystem itself (such as sillyrenaming) that are entirely
unneeded if the file info is available.

I agree, that the xattr API is quite ugly already, but adding one more
argument won't make it all that much worse.

Miklos
