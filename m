Return-Path: <linux-kernel-owner+w=401wt.eu-S1762157AbXEPQNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762157AbXEPQNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXEPQNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:13:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132AbXEPQNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:13:36 -0400
Date: Wed, 16 May 2007 09:12:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johann Lombardi <johann@clusterfs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Clear PG_error before reading a page
Message-Id: <20070516091217.b9bb5797.akpm@linux-foundation.org>
In-Reply-To: <20070516153919.GC2630@chiva>
References: <20070515143726.GC2160@chiva>
	<20070515101144.f7072476.akpm@linux-foundation.org>
	<20070515210124.GA23698@chiva>
	<20070515142339.4d9098f3.akpm@linux-foundation.org>
	<20070516153919.GC2630@chiva>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 17:39:19 +0200 Johann Lombardi <johann@clusterfs.com> wrote:

> On Tue, May 15, 2007 at 02:23:39PM -0700, Andrew Morton wrote:
> > > Yes, indeed. However, as soon as a call to get_block() fails,
> > > do_mpage_readpage() will call block_read_full_page() which will attach
> > > buffers to this page.
> > > Consequently, all subsequent reads will go through block_read_full_page().
> > 
> > hm, confused.  Why is get_block() failing?  That has to go and read
> > metadata. 
> 
> In fact, I am referring to the first part of my test case (i.e. mount the ext3
> fs, enable medium errors in scsi_debug and try to read a file from the fs).
> 
> So, when I try to read a file, ext3_get_block() needs to read metadata from the
> disk. However, given that the SCSI disk simulated by scsi_debug reports medium
> errors, ext3_get_block() returns EIO to the caller (i.e. do_mpage_readpage()).
> That's why get_block() is failing.
> 
> Then, do_mpage_readpage() calls block_read_full_page() (via "goto confused").
> block_read_full_page() attaches buffers to this page and calls ext3_get_block()
> which fails for the same reason as before. Consequently, block_read_full_page()
> sets the PG_error flag.
> Moreover, all subsequent readpage calls will go through block_read_full_page()
> because the page has now buffers attached.
> 
> Basically, my problem is that afterwards, when the device no longer returns
> any errors, the PG_error flag is never cleared and, as a result, I keep
> getting -EIO. That's the problem I'd like to address.
> 

hm, OK.  So, where are we up to?

I still worry about the fact that changes in this area could cause the
kernel to do a *lot* more IO attempts against failed devices, or failed
sectors.  We already have a few problems in that area.

What is the actual real-world operational scenario here?  Would it be a
hotplugged disk?  A transient network failure in a SAN?  IOW, is it
something from which the kernel should automatically recover, or it is a
situation in which manual intervention would be better?
