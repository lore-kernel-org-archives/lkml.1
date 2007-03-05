Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbXCEW2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbXCEW2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbXCEW2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:28:41 -0500
Received: from mail10.tpgi.com.au ([203.12.160.147]:34227 "EHLO
	mail10.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbXCEW2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:28:40 -0500
X-TPG-Antivirus: Passed
Date: Tue, 6 Mar 2007 09:25:26 +1100
From: Will Trives <will@trivescon.com.au>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-git3 Unstable for me
Message-ID: <20070306092526.0a7cdd0b@disher.kickcrew>
In-Reply-To: <1173109811.9109.17.camel@kleikamp.austin.ibm.com>
References: <20070305150317.57e62d70@disher.kickcrew>
	<45EC3058.2010903@redhat.com>
	<1173108985.9109.11.camel@kleikamp.austin.ibm.com>
	<1173109811.9109.17.camel@kleikamp.austin.ibm.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Looks like this has fixed the problem for me, it's not falling down
anymore. Thanks Dave.


On Mon, 05 Mar 2007 09:50:11 -0600
Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:

> On Mon, 2007-03-05 at 09:36 -0600, Dave Kleikamp wrote:
> > On Mon, 2007-03-05 at 09:59 -0500, Chuck Ebbert wrote:
> > > Will Trives wrote:
> > > 
> > > [adding JFS maintainer to cc:]
> > 
> > Thanks for adding me to the thread.
> > 
> > > Some kind of JFS problem?
> > 
> > I don' t know yet.  I was notified of the problem through bugzilla:
> > http://bugzilla.kernel.org/show_bug.cgi?id=8128
> > 
> > The problem appears that a non-uptodate page has been marked
> > dirty.  I haven't found much in the way of changes between 2.6.20
> > and the current git tree to explain this.  There's this one:
> > http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=22c8ca78f20724676b6006232bf06cc3e9299539
> > 
> > I'm looking for for a caller to ->prepare_write() which marks the
> > page dirty without calling ->commit_write().
> 
> I think I just found it:
> 
> nobh_truncate_page():
> 
> 	ret = a_ops->prepare_write(NULL, page, offset, to);
> 	if (ret == 0) {
> 		kaddr = kmap_atomic(page, KM_USER0);
> 		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
> 		flush_dcache_page(page);
> 		kunmap_atomic(kaddr, KM_USER0);
> 		set_page_dirty(page);
> 	}
> 	unlock_page(page);
> 	page_cache_release(page);
> 
> > 
> > Will, could you try reverting that patch?  If that fails, narrowing
> > the problem down with git-bisect would be helpful, if you have the
> > time.
> 
> Better yet, try this patch:
> 
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> 
> diff -Nurp linux-orig/fs/buffer.c linux/fs/buffer.c
> --- linux-orig/fs/buffer.c	2007-02-22 07:59:01.000000000 -0600
> +++ linux/fs/buffer.c	2007-03-05 09:47:07.000000000 -0600
> @@ -2466,6 +2466,7 @@ int nobh_truncate_page(struct address_sp
>  		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
>  		flush_dcache_page(page);
>  		kunmap_atomic(kaddr, KM_USER0);
> +		SetPageUptodate(page);
>  		set_page_dirty(page);
>  	}
>  	unlock_page(page);
> 
