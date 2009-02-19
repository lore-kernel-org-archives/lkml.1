Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbZBSGTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbZBSGTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 01:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZBSGTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 01:19:31 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:47151 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbZBSGTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 01:19:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At8CAMiGnEl5LClxgWdsb2JhbACUUwEBFiK9dYQOBg
X-IronPort-AV: E=Sophos;i="4.38,233,1233495000"; 
   d="scan'208";a="294219415"
Date: Thu, 19 Feb 2009 17:19:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de
Subject: Re: xfs problems (possibly after upgrading from linux kernel
	2.6.27.10 to .14)
Message-ID: <20090219061925.GE8830@disturbed>
Mail-Followup-To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-kernel@vger.kernel.org,
	npiggin@suse.de
References: <499ACE6C.4060304@aei.mpg.de> <20090218091935.GD8830@disturbed> <499BD6BB.2000406@aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499BD6BB.2000406@aei.mpg.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 10:36:59AM +0100, Carsten Aulbert wrote:
> Dave Chinner schrieb:
> > On Tue, Feb 17, 2009 at 03:49:16PM +0100, Carsten Aulbert wrote:
> >> Do you need more information or can I send these nodes into a re-install?
> > 
> > More information. Can you get a machine into a state where you can
> > trigger this condition reproducably by doing:
> > 
> > 	mount filesystem
> > 	touch /mnt/filesystem/some_new_file
> > 
> > If you can get it to that state, and you can provide an xfs_metadump
> > image of the filesystem when in that state, I can track down the
> > problem and fix it.
> 
> I can try doing that on a few machines, would a metadump help on a
> machine where this corruption occurred some time ago and is still in
> this state?

If you unmount the filesystem, mount it again and then touch a new
file and it reports the error again, then yes, a metadump woul dbe
great.

If the error doesn't show up after a unmount/mount, then I
can't use a metadump image to reproduce the problem.

> >> Feb 16 22:01:28 n0260 kernel: [1129250.851451] Filesystem "sda6": xfs_iflush: Bad inode 1176564060 magic number 0x36b5, ptr 0xffff8801a7c06c00
> > 
> > However, this implies some kind of memory corruption is occurring.
> > That is reading the inode out of the buffer before flushing the
> > in-memory state to disk. This implies someone has scribbled over
> > page cache pages.
> > 
> > 
> >> Feb 17 05:57:44 n0463 kernel: [1156816.912129] Filesystem "sda6": XFS internal error xfs_btree_check_sblock at line 307 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff802dd15b
> > 
> > And that is another buffer that has been scribbled over.
> > Something is corrupting the page cache, I think. Whether the
> > original shutdown is caused by the some corruption, i don't
> > know.
> > 
> 
> At least on two nodes  we ran memtest86+ overnight and so far no error.

I don't think it is hardware related.

> >> plus a few more nodes showing the same characteristics 
> > 
> > Hmmmm. Did this show up in 2.6.27.10? Or did it start occurring only
> > after you upgraded from .10 to .14?
> 
> As far as I can see this only happened after the upgrade about 14 days
> ago. What strikes me odd is that we only had this occurring massively on
> Monday and Tuesday this week.
> 
> I don't know if a certain access pattern could trigger this somehow.

I suspect so. We've already had XFS trigger one bug in the new
lockless pagecache code, and the fix for that went in 2.6.27.11 -
between the good version and the version that you've been seeing
these memory corruptions on. I'm wondering if that fix exposed or
introduced another bug that you've hit....

Nick?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
