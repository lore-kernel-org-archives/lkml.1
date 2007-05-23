Return-Path: <linux-kernel-owner+w=401wt.eu-S1759666AbXEWHev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666AbXEWHev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbXEWHeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:34:44 -0400
Received: from styx.suse.cz ([82.119.242.94]:44653 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755174AbXEWHen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:34:43 -0400
Date: Wed, 23 May 2007 09:45:57 +0200
From: Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] UDF cleanup and fixes
Message-ID: <20070523074557.GA20625@duck.suse.cz>
References: <20070306164447.GC3661@duck.suse.cz> <4632710C.5030104@sandeen.net> <46535503.4020702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46535503.4020702@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-05-07 15:39:31, Eric Sandeen wrote:
> Eric Sandeen wrote:
> 
> > Jan -
> > 
> > I ran 2.6.21 + your udf patches from -mm through some udf tests which,
> > oddly enough, can be found in the xfstests test suite in xfsprogs cvs
> > from sgi.
> > 
> > It looks much better than before, but I was able to trip some of your
> > asserts.  They were generated while fsx was running.  The good news,
> > though, is that fsx passed.  :)  I haven't looked into it much further
> > yet, but wanted to let you know.
> 
> Here's a short hacky testcase that trips the assert around line 123 of
> udf/truncate.c  I'm looking into it but you may immediately see what the
> problem is...?
  Yes, yesterday I've also managed to create a simple testcase - sorry for
not letting you know, I'd have saved you some time. I also know what the
problem is:
  1) discard_prealloc() shouldn't be called from udf_clear_inode() - at
that point inode won't be written any more and thus changes to it won't be
reflected. Actually, this bug is hidden by the fact that UDF calls
discard_prealloc() on each filp release but anyway.
  2) the second problem is extent rounding - when we discard prealloc we
also truncate the extent to match i_size. That is fine but if the buffer
remains in pagecache and is reused on second open, block_prepare_write()
won't call udf_get_block() (as the buffer is already mapped) and thus the
extent remains truncated even though we write after it's end. The easiest
way out would be to simply leave the extent length rounded to block
boundary but I have to check with the specification whether this is
allowed...

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
