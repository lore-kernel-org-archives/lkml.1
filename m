Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYL3OtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYL3OtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 09:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYL3OtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 09:49:13 -0500
Received: from verein.lst.de ([213.95.11.210]:56851 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbYL3OtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 09:49:13 -0500
Date: Tue, 30 Dec 2008 15:48:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
       Al@oss.sgi.com, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, bfields@fieldses.org,
       xfs-masters@oss.sgi.com, Viro <viro@ZenIV.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [xfs-masters] RFC: Fix f_flags races without the BKL
Message-ID: <20081230144836.GA31439@lst.de>
References: <20081229041352.6bbdf57c@tpl> <20081229124151.GA29634@redhat.com> <20081229152732.GH496@one.firstfloor.org> <20081230055956.1747bd86@tpl> <20081230130439.GA28874@lst.de> <20081230133737.GM496@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230133737.GM496@one.firstfloor.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 02:37:37PM +0100, Andi Kleen wrote:
> That's not clear. Mutexes can be much slower than a spinlock
> like BKL in some situations, mostly because they schedule more and
> have generally more overhead.
> 
> As long as you don't have another BKL user contending the BKL
> is likely faster than the mutex.

Note that I did not say faster, but better.  The subtle races the
BKL semantics introduce are nasty.

That beeing said I took another look at the patch and it seems like
most places are indeed just very quick flags setting / clearing
with the only sleeping possible inside ->fasync.  So having a
file_flags_lock spinlock, and another sleeping mutex protecting
->fasync might be another options.

Jon, do you remember what we actually need to protect in -fasync?
any reason not to take the locking inside the method?  Together with
->lock and the old ->ioctl it's pretty special in fops as none of
the others have any locking at all.

> 
> -Andi
> 
> -- 
> ak@linux.intel.com
> 
> _______________________________________________
> xfs-masters mailing list
> xfs-masters@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs-masters
---end quoted text---
