Return-Path: <linux-kernel-owner+w=401wt.eu-S1765754AbXGKR0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765754AbXGKR0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbXGKR0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:26:35 -0400
Received: from mail.fieldses.org ([66.93.2.214]:44645 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765579AbXGKR0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:26:33 -0400
Date: Wed, 11 Jul 2007 13:26:23 -0400
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org, cmm@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Message-ID: <20070711172623.GE4138@fieldses.org>
References: <1183275424.4010.126.camel@localhost.localdomain> <20070710163038.ceb2ae94.akpm@linux-foundation.org> <1184105380.3759.65.camel@localhost.localdomain> <20070710182237.e2f88bf3.akpm@linux-foundation.org> <18068.19667.942363.686858@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18068.19667.942363.686858@notabene.brown>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 01:21:55PM +1000, Neil Brown wrote:
> And just by-the-way, the server doesn't really have the option of not
> sending the attribute.  If i_version isn't defined, it has to fake
> something using mtime, and hope that is good enough.

ctime, actually--the change attribute is also supposed to be updated on
attribute updates.

> Alternately we could mandate that i_version is always kept up-to-date
> and if a filesystem doesn't have anything to load from storage, it
> just sets it to the current time in nanoseconds.
> 
> That would mean that a client would need to flush it's cache whenever
> the inode fell out of cache on the server, but I don't think we can
> reliably do better than that.
> 
> I think I like that approach.
> 
> So my vote is to increment i_version in common code every time any
> change is made to the file, and alloc_inode should initialise it to
> current time, which might be changed by the filesystem before it calls
> unlock_new_inode. 

So the client would be invalidating its cache more often than necessary,
rather than failing to invalidate it when it should.  I agree that
that's probably the better tradeoff, although I wish I had a better idea
of the downside.  I don't know, for example, whether users might see
unpleasant results if every client has to reread its cached data on a
reboot.

The currently proposed change--just providing a model change attribute
implementation for ext4 and leaving other filesystems untouched--is a
more conservative step.

So I'm inclined to just do this ext4 thing first, and then look into
further change attribute experiments next time around....

--b.
