Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbXHBPxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbXHBPxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXHBPw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:52:58 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:57190 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbXHBPw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:52:57 -0400
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070801141439.ff1c29f9.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 1 Aug 2007 14:14:39 -0700)
Subject: Re: kupdate weirdness
References: <E1IGL4G-00088R-00@dorka.pomaz.szeredi.hu> <20070801141439.ff1c29f9.akpm@linux-foundation.org>
Message-Id: <E1IGcyd-00025s-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 02 Aug 2007 17:52:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The following strange behavior can be observed:
> > 
> > 1. large file is written
> > 2. after 30 seconds, nr_dirty goes down by 1024
> > 3. then for some time (< 30 sec) nothing happens (disk idle)
> > 4. then nr_dirty again goes down by 1024
> > 5. repeat from 3. until whole file is written
> > 
> > So basically a 4Mbyte chunk of the file is written every 30 seconds.
> > I'm quite sure this is not the intended behavior.
> > 
> > The reason seems to be that __sync_single_inode() will move the
> > partially written inode from s_io onto s_dirty, and sync_sb_inode()
> > will not splice it back onto s_io until the rest of the inodes on s_io
> > has been processed.
> 
> It does all sorts of weird crap.
> 
> > Since there will probably be a recently dirtied inode on s_io, this
> > will take some of time, but always less than 30 sec.
> > 
> > I don't know what's the easiest solution.
> > 
> > Any ideas?
> 
> Try 2.6.23-rc1-mm2.

Much better, but still not perfect.

Now it writes out 1024 pages after 30 seconds and then the rest after
another 30s.

If my analysis is correct, this is because when it first gets onto
s_io other inodes will get there too (with up-to 30s later dirying
time), and the contents of s_more_io won't be recycled until the
current contents of s_io are processed.

Maybe this is OK, the previous weird stuff didn't seem to bother a lot
of people either.

Miklos
