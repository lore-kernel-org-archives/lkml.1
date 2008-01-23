Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbYAWFyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbYAWFyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 00:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYAWFys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 00:54:48 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:37730 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798AbYAWFyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 00:54:47 -0500
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200801230554.m0N5sXJL001173@turbo.physics.adelaide.edu.au>
Subject: Re: do_remount_sb(RDONLY) race? (was: XFS oops under 2.6.23.9)
To: dgc@sgi.com (David Chinner)
Date: Wed, 23 Jan 2008 16:24:33 +1030 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org
In-Reply-To: <20080123053412.GN155259@sgi.com> from "David Chinner" at Jan 23, 2008 04:34:12 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave

> On Wed, Jan 23, 2008 at 03:00:48PM +1030, Jonathan Woithe wrote:
> > Last night my laptop suffered an oops during closedown.  The full oops
> > reports can be downloaded from
> > 
> >   http://www.atrad.com.au/~jwoithe/xfs_oops/
> 
> Assertion failed: atomic_read(&mp->m_active_trans) == 0, file:
> fs/xfs/xfs_vfsops.c, line 689.
> 
> The remount read-only of the root drive supposedly completed
> while there was still active modification of the filesystem
> taking place.
> 
> > Kernel version was kernel.org 2.6.23.9 compiled as a low latency desktop. 
> 
> The patch in 2.6.23 that introduced this check was:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=516b2e7c2661615ba5d5ad9fb584f068363502d3
> 
> Basically, the remount-readonly path was not flushing things
> properly, so we changed it to flushing things properly and ensure we
> got bug reports if it wasn't. Yours is the second report of not
> shutting down correctly since this change went in (we've seen it
> once in ~8 months in a QA environment).
> 
> I've had suspicions of a race in the remount-ro code in
> do_remount_sb() w.r.t to the fs_may_remount_ro() check.  That is, we
> do an unlocked check to see if we can remount readonly and then fail
> to check again once we've locked the superblock out and start the
> remount.
> 
> The read only flag only gets set *after* we've made the filesystem
> readonly, which means before we are truly read only, we can race
> with other threads opening files read/write or filesystem
> modifcations can take place.
> 
> The result of that race (if it is really unsafe) will be assert you
> see. The patch I wrote a couple of months ago to fix the problem
> is attached below....

Thanks for the patch.  I will apply it and see what happens.

Will this be in 2.6.24?

Regards
  jonathan
