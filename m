Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbXJ3OKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbXJ3OKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXJ3OKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:10:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45327 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbXJ3OKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:10:06 -0400
Date: Tue, 30 Oct 2007 15:10:04 +0100
From: Jan Kara <jack@suse.cz>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: is the inode an orphan?
Message-ID: <20071030141004.GA27039@atrey.karlin.mff.cuni.cz>
References: <47179CAE.6010806@yandex.ru> <20071018180152.GO8181@ftp.linux.org.uk> <471857B1.8090709@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471857B1.8090709@yandex.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Al Viro wrote:
> >Define orphan.  It might very well be still opened after the only link
> >to it had been removed and you still will get IO on it.
> 
> Well, in the mail I called files like open/unlink the last link/do some I/O 
> orphans. Let me shortly describe the problem I'm trying to solve.
> 
> In our FS when we're in ->unlink() and i_nlink becomes 0, we have to record 
> this inode in the table of orphans, and remove it from there in 
> ->delete_inode(). This is needed to be able to dispose of orphans in case 
> of an unclean reboot on the next mount. AFAIK, ext3 has something similar. 
> I just figured that this could be optimized - in most cases 
> ->delete_inode() is called right after ->unlink(), and I wanted to avoid 
> putting the inode to the orphan table in those cases.
  Yes, ext3 has something similar. But actually ext3 would have to insert
inode in the orphan list anyway - in delete_inode we do truncate and
for it we also insert the inode into the orphan list because truncate
can be too large to fit into a single transaction.

> I.e., if one just does "unlink file", then it is not going to be an orphan. 
> And most cases are like this. It is rather rare to open a file, unlink it, 
> and keep utilizing it.
> 
> So my question was - while I'm in ->unlink(), how do I figure out that this 
> is not an orphan. So I was thinking about
> 
> if (atomic_read(&inode->i_count) == 2)
> 
> then this is not an orphan and ->delete_inode() will be called straight 
> away (i_nlink is assumed to be 0).
> 
> But I've now also figured that ->unlink() may race with write-back, and 
> there might be a write-back I/O between ->unlink() (and during it) and 
> ->delete_inode(), even though the user-space does not have the file in 
> question opened.
> 
> So, at the moment, AFAIU
> 
> if (atomic_read(&inode->i_count) == 2 && !(inode->i_state & I_DIRTY))
> 
> then there won't be any I/O on the inode between ->unlink() and 
> ->delete_inode i_nlink is assumed to be 0). Is that right, safe and 
> acceptable to use such checks in ->unlink() for optimization?
> 
> P.S. the code and short description of the FS I refer is here: 
> http://www.linux-mtd.infradead.org/doc/ubifs.html
  Hmm, I'm just not sure whether unlink cannot somehow race with open
(at least I don't see any lock that would prevent open while unlink is
in progress)...

									Honza
