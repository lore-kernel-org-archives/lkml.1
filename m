Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbYIQRxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbYIQRxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 13:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYIQRxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 13:53:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:36530 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbYIQRxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 13:53:24 -0400
Date: Thu, 18 Sep 2008 02:52:41 +0900 (JST)
Message-Id: <20080918.025241.88481333.ryusuke@osrg.net>
To: joern@logfs.org
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/27] nilfs2: add document
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20080917145437.GE8750@logfs.org>
References: <1221419304-18572-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20080917145437.GE8750@logfs.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 16:54:38 +0200, Jörn Engel wrote:
> On Mon, 15 September 2008 04:07:58 +0900, Ryusuke Konishi wrote:
> > +
> > +The logs include regular files, directory files, symbolic link files
> > +and several meta data files.  The mata data files are the files used
> > +to maintain file system meta data.  The current version of NILFS2 uses
> > +the following meta data files:
> > +
> > + 1) Inode file (ifile)             -- Stores on-disk inodes
> > + 2) Checkpoint file (cpfile)       -- Stores checkpoints
> > + 3) Segment usage file (sufile)    -- Stores allocation state of segments
> > + 4) Data address translation file  -- Maps virtual block numbers to usual
> > +    (DAT)                             block numbers.  This file serves to
> > +                                      make on-disk blocks relocatable.
> > + 5) Sketch file (sketch)           -- Keeps read-only data which can be
> > +                                      associated with checkpoints (optional)
> 
> How are the sufile and the DAT written?  If you naively stick to the
> log-structured approach, their contents will reflect a filesystem state
> prior to writing them and be outdated by the time they hit the medium.
> So either you bend the rules here and update those files in-place or you
> do something tricky.  Can you explain your solution?

That's right.  The DAT, sufile, and cpfile are written at a time so
that they will become consistent and self contained.

Checkpoint creations are predictable, so the cpfile is OK.  But the
sufile depends on the length of logs, therefore it depends on
construction of other files including DAT and the super root block.
Since the virtual block numbers are assigned also to the sufile, there
is a circulation problem.

So, nilfs2 makes the sufile in a speculative way; it will retry
collection of dirty blocks for these three files if it turned out that
more segments are required than expected.  It is not a problem for the
case that expected segments are too many because allocation of
oversupplied segments can be cancelled without breaking consistency.
nilfs2 does this retry on memory and writes the three files at a time
to avoid I/O penalty.

Regards,
Ryusuke
