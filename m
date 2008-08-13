Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYHMQT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYHMQT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYHMQTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:19:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46462 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYHMQTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:19:46 -0400
Date: Wed, 13 Aug 2008 17:19:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Brad Boyer <flar@allandria.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080813161940.GB28946@ZenIV.linux.org.uk>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org> <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <20080813083635.GA5933@cynthia.pants.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813083635.GA5933@cynthia.pants.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 01:36:35AM -0700, Brad Boyer wrote:
> On Wed, Aug 13, 2008 at 01:04:33AM +0100, Al Viro wrote:
> > hfs:	at least missing checks for hfs_bnode_read() failure.  And I'm not
> > 	at all sure that hfs_mac2asc() use is safe there.  BTW, open_dir_list
> > 	handling appears to be odd - how the hell does decrementing ->f_pos
> > 	help anything?  And hfs_dir_release() removes from list without any
> > 	locks, so that's almost certainly racy as well.
> > hfsplus: ditto
> 
> I don't work on this code anymore, but I wrote the original version which
> makes me a bit curious about some of the critcism here. The function
> hfs_bnode_read is declared void, so it doesn't return any errors. The
> only thing inside it that I could even think of failing is kmap, but
> I was under the impression that kmap would sleep until it could
> complete. The actual disk read happens earlier and is saved in the
> page cache as long as the bnode object exists.

Argh... s/failure/arguments/; sorry about the braino.  Take a look at
the call in the main loop.  entrylength comes from 16bit on-disk value
(set in hfs_brec_goto()).  It's not checked anywhere for being too large,
AFAICS.  And we proceed to do memcpy() to entry.  On stack, BTW.

> Is there any reason that hfs_mac2asc would not be safe? I can't think
> of any good way to avoid that call even if it is unsafe, since the
> readdir will expect UTF8 strings rather than the mac (or UTF16 for
> hfsplus) encoding found on disk.

As for mac2asc...  Are multibyte encodings possible there?  If they are,
you'd need to validate the first byte of CName as well - result of conversion
will fit the strbuf, but that doesn't mean we do not overrun the source
buffer...
 
> The open_dir_list stuff is a little odd I admit, and I think you are
> right about the locking issue in release. However, I feel like I should
> explain the way hfs and hfsplus use f_pos on directories. The on-disk
> format requires that the directory entries be sorted in order by
> filename and does not allow any holes in the list. Because of this,
> adding and removing entries will move all the items that are later
> in the order to make room or eliminate the hole. The manipulation
> of f_pos is intended to make it act more like a standard unix
> filesystem where removing an item doesn't usually make a pending
> readdir skip an unrelated item. The value of f_pos for a directory
> is only incremented by one for each entry to make seeking work
> in a more sane fashion.

What happens if you repeatedly create and remove an entry with name below
that of the place where readdir has stopped?  AFAICS, on each iteration
f_pos will decrement...  I see that scanning of the list in hfs_cat_delete()
and nowhere else; we don't have the matching increment of f_pos...

> Because of this, an increment moves to the
> next item and decrement moves to the previous one.
> 
> As a side note about the complexity of making hfs and hfsplus fit
> into a unix model, there is just one file that contains the equivalent
> of every directory and the entire inode table. Because of this, the
> directory code is very synthetic. I tried to make it look as much as
> possible like a normal unix filesystem, including making i_nlink on
> the directory inodes reflect the number of child directories. It
> makes for some code that is admittedly a little hard to follow.

It's actually fairly readable, but AFAICS doesn't validate the on-disk
data enough...  Sure, don't go around mounting corrupt filesystem images
and all such, but getting buffer overruns on kernel stack is a bit over
the top, IMO...

[que the grsec pack popping out of latrines screaming "coverup" and demanding
CVEs to be allocated]
