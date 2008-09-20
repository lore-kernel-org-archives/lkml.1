Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYITKoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYITKoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYITKoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:44:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:33084 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbYITKoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:44:13 -0400
Date: Sat, 20 Sep 2008 19:43:58 +0900 (JST)
Message-Id: <20080920.194358.07565122.ryusuke@osrg.net>
To: joern@logfs.org
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kihara.seiji@lab.ntt.co.jp,
       amagai.yoshiji@lab.ntt.co.jp
Subject: Re: [PATCH 25/27] nilfs2: block cache for garbage collection
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20080917224953.GB14644@logfs.org>
References: <20080917144146.GD8750@logfs.org>
	<20080918.040945.32654226.ryusuke@osrg.net>
	<20080917224953.GB14644@logfs.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jörn,
On Thu, 18 Sep 2008 00:49:53 +0200, Jörn Engel wrote:
> On Thu, 18 September 2008 04:09:45 +0900, Ryusuke Konishi wrote:
> > If so, the remaining problem would be the lock dependencies as you
> > mentioned before.
> 
> You should have the same problem already - in some shape or another.  If
> you can have two data structures for the same content, a real inode and
> a dummy inode, you have a race condition.  Quite possibly one involving
> data corruption.
>
> Well, one way to avoid both the race and the locking complexity is by
> stopping all writes during GC and destroying all dummy inodes before
> writes resume. 

The current version of NILFS2 really takes this approach.
Pages held by the dummy inodes will be released after they are copied
to a new log.

> But that would be inefficient in several cases.  When
> GC'ing data that is dirty in the caches, you move the old stale data
> during GC and write the new data soon after.  And you always flush the
> caches after GC, even if your machine has no better use for the memory.

As for as NILFS2, the dirty blocks and the blocks to be moved by GC
never overlap because the dirty blocks make a new generation.
So, they rather must be written individually.

Though we can reuse pages in the GC cache, the effect of this
optimization may be much lower than usual LFSes because most of
blocks in the pages may not belong to the latest generation.

Hmm, we would be better off counting frequency of true overlap if
getting to that.

> BTW: Some of the explanation you just gave me would do well as
> documentation in the source file as well.  That's the sort of background
> information new developers can spend month of mistakes and reverse
> engineering on. :)
> 
> Jörn

Well, thanks.  I'll do that.
NILFS2 needs explication than usual file systems; it needs time
perspective as well as it is an LFS. :)

Regards,
Ryusuke
