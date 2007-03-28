Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbXC1IOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbXC1IOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 04:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXC1IOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 04:14:20 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:45999
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752667AbXC1IOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 04:14:17 -0400
X-Greylist: delayed 1986 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2007 04:14:17 EDT
Date: Wed, 28 Mar 2007 09:38:53 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Xin Zhao <uszhaoxin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Linux page cache issue?
Message-ID: <20070328073853.GC14429@traven>
References: <4ae3c140703272345y3b3cb3cexf4c4b63e0035d5b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ae3c140703272345y3b3cb3cexf4c4b63e0035d5b9@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

according to the chapter "Linux Kernel Overview" of the
kernelhacking-HOWTO the page cache holds pages associated with *open*
files:

The Page Cache

The page cache is made up of pages, each of which refers to a 4kB
portion of data associated with an open file. The data contained in a
page may come from several disk blocks, which may or may not be
physically neighbours on the disk. The page cache is largely used to
interface the requirements of the memory management subsystem (which
uses fixed, 4kB pages) to the VFS subsystem (which uses different size
blocks for different devices).

The page cache has two important data structures, a page hash table
and an inode queue. The page hash table is used to quickly find the
page descriptor of the page holding data associated with an inode and
offset within a file. The inode queue contains lists of page
descriptors relating to open files.

http://www.kernelhacking.org/docs/kernelhacking-HOWTO/indexs03.html

m.

El Wed, Mar 28, 2007 at 02:45:23AM -0400 Xin Zhao ha dit:

> Hi,
> 
> If a Linux process opens and reads a file A, then it closes the file.
> Will Linux keep the file A's data in cache for a while in case another
> process opens and reads the same in a short time? I think that is what
> I heard before.
> 
> But after I digged into the kernel code, I am confused.
> 
> When a process closes the file A, iput() will be called, which in turn
> calls the follows two functions:
> iput_final()->generic_drop_inode()
> 
> But from the following calling chain, we can see that file close will
> eventually lead to evict and free all cached pages. Actually in
> truncate_complete_page(), the pages will be freed.  This seems to
> imply that Linux has to re-read the same data from disk even if
> another process B read the same file right after process A closes the
> file. That does not make sense to me.
> 
> /***calling chain ***/
> generic_delete_inode/generic_forget_inode()->
> truncate_inode_pages()->truncate_inode_pages_range()->
> truncate_complete_page()->remove_from_page_cache()->
> __remove_from_page_cache()->radix_tree_delete()
> 
> Am I missing something? Can someone please provide some advise?
> 
> Thanks a lot
> -x
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
               For to be free is not merely to cast off
               one's chains, but to live in a way that
              respects and enhances the freedom of others
                           (Nelson Mandela)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
