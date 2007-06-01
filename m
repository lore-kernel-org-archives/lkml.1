Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbXFAREk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbXFAREk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760521AbXFAREd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:04:33 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760593AbXFAREc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:04:32 -0400
Date: Fri, 1 Jun 2007 10:04:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-Id: <20070601100425.89537dda.akpm@linux-foundation.org>
In-Reply-To: <20070601164926.GA8398@cvg>
References: <20070524165935.GB19709@duck.suse.cz>
	<20070524170554.GC19709@duck.suse.cz>
	<20070524203653.GA7693@duck.suse.cz>
	<465DF0B4.2050203@sandeen.net>
	<465DF91F.3010201@sandeen.net>
	<20070531174201.GB8392@cvg>
	<465F09E7.7000300@sandeen.net>
	<20070601164926.GA8398@cvg>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 20:49:26 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Eric Sandeen - Thu, May 31, 2007 at 12:46:15PM -0500]
> | Cyrill Gorcunov wrote:
> | 
> | >Eric, could you please try the following:
> | >
> | >1) declare the spinlock in the top of inode.c as
> | >
> | >	DEFINE_SPINLOCK(udf_drop_lock);
> | >
> | >2) replace in udf_drop_inode()
> | >
> | >	kernel_lock -> spin_lock(&udf_drop_lock);
> | >	kernel_unlock -> spin_unlock(&udf_drop_lock);
> | >
> | >I'm not sure if it help but you may try ;)
> | >
> | >		Cyrill
> | >
> | 
> | I'm sure it'll avoid the deadlock but....
> | 
> | Any sense of what the BKL is actually trying to protect in this case?
> | 
> | Is it really only trying to prevent concurrent prealloc-discarders, or 
> | is there more?
> | 
> | -Eric
> | 
> 
> Hi Eric,
> it seems BKL only trying to protect from concurrent discard_prealloc.
> Moreover, a lot of UDF code does call iput with BKL held, so the only
> solution I see is to add spinlocks to udf_drop_inode... I'm making patch
> soon. Any comments?
> 

Recursive lock_kernel() is OK.

spin_lock() insode lock_kernel() is OK.

lock_kernel() inside spin_lock() is not OK, but if this was happening you'd
only rarely hit a deadlock and I think this locks up every time.

We don't know what's causing this hang, do we?
