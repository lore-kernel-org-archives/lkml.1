Return-Path: <linux-kernel-owner+w=401wt.eu-S935987AbXGMJGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935987AbXGMJGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbXGMJGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:06:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbXGMJGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:06:12 -0400
Date: Fri, 13 Jul 2007 02:05:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
 features in larger inode
Message-Id: <20070713020529.1486491f.akpm@linux-foundation.org>
In-Reply-To: <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
References: <1183275482.4010.133.camel@localhost.localdomain>
	<20070710163247.5c8bfa3f.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 16:32:47 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	brelse(bh);
> > +	up_write(&EXT4_I(inode)->xattr_sem);
> > +	return error;
> > +}
> > +
> 
> We're doing GFP_KERNEL memory allocations while holding xattr_sem.  This
> can cause the VM to reenter the filesystem, perhaps taking i_mutex and/or
> i_truncate_sem and/or journal_start() (I forget whether this still
> happens).  Have we checked whether this can occur and if so, whether we are
> OK from a lock ranking POV?  Bear in mind that journalled-data mode is more
> complex in this regard.

I notice that everyone carefully avoided addressing this ;)

Oh well, hopefully people are testing with lockdep enabled.  As long
as the fs is put under extreme memory pressure, most bugs should be reported.

Except lockdep doesn't know about journal_start(), which has ranking
requirements similar to a semaphore.  Nor does it know about lock_page().
We already have hard-to-hit but deadlockable bugs in this area.


