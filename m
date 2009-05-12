Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZELPxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZELPxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZELPxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:53:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZELPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:53:08 -0400
Date: Tue, 12 May 2009 11:53:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Ferenc Wagner <wferi@niif.hu>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, Anton Salikhmetov <salikhmetov@gmail.com>
Subject: Re: mmap vs mtime in 2.6.26 and up
Message-ID: <20090512155301.GA23160@infradead.org>
References: <874ovws94s.fsf@tac.ki.iif.hu> <87ljp2v6vt.fsf@tac.ki.iif.hu> <2c0942db0905120837g702b457bm52a412293925021a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0905120837g702b457bm52a412293925021a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 08:37:43AM -0700, Ray Lee wrote:
> > I've noticed that the last modification times of our RRD files got
> > stuck after upgrading from 2.6.24 to 2.6.26 (Debian Etch -> Lenny; I
> > also tested with 2.6.30-rc5, they are still stuck). ??It has some
> > literature, most notably kernel bug #2645, but that's closed long ago
> > and the resulting patch http://lkml.org/lkml/2008/1/22/370 is present
> > in my kernels. ??Still, the test program (version 3 from the bug report)
> > gives failures:

The problem is pretty simple.  do_wp_page and __do_fault use
file_update_time to update ctime and mtime.  But this function is only
a helper for simply filesystems that have a binary inode dirty/non dirty
state and keep the m/ctime purely in the Linux inode.  It must not be
called from generic code as more complex filesystems need a notification
through ->setattr to update the timestamps.  This will also affect other
filesystems like ubifs.  I'm not entirely sure why it ever worked
before, we must have picked up those c/mtime updates by accident
somehow.
