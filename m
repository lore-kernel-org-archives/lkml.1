Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYEXKja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYEXKja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 06:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYEXKjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 06:39:20 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53713 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbYEXKjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 06:39:19 -0400
Date: Sat, 24 May 2008 14:38:28 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Steve French <smfrench@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: pagevecs of more than PAGEVEC_SIZE pages
Message-ID: <20080524103828.GC10796@2ka.mipt.ru>
References: <524f69650805221213i62488a4fk5a906b2726b9b96a@mail.gmail.com> <20080522225459.5a6f7acc.akpm@linux-foundation.org> <20080523092938.GA16915@2ka.mipt.ru> <524f69650805231013u6d3e26f5lee7d475022623ee3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650805231013u6d3e26f5lee7d475022623ee3@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 12:13:58PM -0500, Steve French (smfrench@gmail.com) wrote:
> Sounds interesting - looks like the only user at the moment is NFS's
> SunRPC right (so no other examples to look at)?
> 
> How much better is this than send_msg?

It depends. In usual life with not that big requests and 64bit arch (or
low mem pages on 32 bit x86) difference is marginal, but with high-pages
and huge requests it was additional 10 MB/s for bulk writing in POHMELFS.

> For the write path (coming from writepage and writepages) - we have a
> small header followed by a list of sequential pages (the servers
> either support 4 pages (old windows), 15 pages (some windows and
> NetApp etc. filers), or 31 pages (older Samba and other Windows) or
> 2048 pages (current Samba supports up to 8MB writes, and this may be
> very useful now that Samba can call splice/receivefile and not have to
> do the extra copy)

kernel_sendpage() has only single page argument, but that should not be
a problem, since stack will combine multiple pages into single skb if
needed (if it can, especially for stuff like TSO/GSO), so just loop for
whatever you fetched pages via find_get_pages_tag() and send them
one-by-one, network stack will coalesce them by itself.

But note that return of kernel_sendpage() does not guarantee that page
has been sent, one can free it (drop refcnt, page will not be freed,
since network stack increases counter), but can not write there until
reply from the server is returned, so just lock page and mark it is
being under writeback and then unlock and end_page_writeback() after
CIFSSMBWrite2() just like it is doen right now.

Btw, should'n end_page_writeback() be called with locked page in CIFS?
Iirc in POHMELFS under huge load I was able to lose writeback clearing
probably because of that, but its subtle and can be not the issue is
CIFS.

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8636cec..ba23c65 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1391,8 +1391,8 @@ retry:
 				if (rc)
 					SetPageError(page);
 				kunmap(page);
-				unlock_page(page);
 				end_page_writeback(page);
+				unlock_page(page);
 				page_cache_release(page);
 			}
 			if ((wbc->nr_to_write -= n_iov) <= 0)

-- 
	Evgeniy Polyakov
