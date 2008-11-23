Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbYKWLZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbYKWLZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 06:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYKWLZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 06:25:24 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55742 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063AbYKWLZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:25:23 -0500
X-Sasl-enc: 5AGvTt76urQrwI5EK0I86axu0eZ4ouDapJ3HGjgQsYas 1227439520
Date: Sun, 23 Nov 2008 09:25:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: phillip@lougher.demon.co.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Zero-clearing all zero-clearable bytes.
Message-ID: <20081123112517.GB17607@khazad-dum.debian.net>
References: <200811221236.FJE81778.LtMHOQFJFVFSOO@I-love.SAKURA.ne.jp> <4928DBAF.4030209@lougher.demon.co.uk> <200811231403.BHG87011.OFOOQFHVJLFSMt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811231403.BHG87011.OFOOQFHVJLFSMt@I-love.SAKURA.ne.jp>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2008, Tetsuo Handa wrote:
> What I wanted to do is "Zero-clearing *all zero-clearable* bytes".

Other than acessing the fs directly with something fs-specific that knows
how to do it, the following trick comes to mind:

1. compress all files to a tar.bz2.
2. remove all files
3. zero fs using dd to a file (will zero all blocks except for the ones used
by the tar.bz2
4. unpack tar.bz2
5. remove tar.bz2
6. redo the dd trick. This will now zero all blocks that were in use by
the tar.bz2.

Of course, this only works if the (kernel, glibc, tar) are not writing
random junk to the unused parts of a fs block.

The cost is from 1 to 3 rm'ed inodes left behind.  If you use two
filesystems (i.e. tar to outside the filesystem), you avoid that
possibility.

> I wished there is a utility to zero-fill such bytes.

So do I.  And a IOCTL/syscall/whatever that we could use to sanitize (i.e.
fill with an user-supplied byte) half-used blocks, so that we could have it
on the most used filesystems (ext2, ext3, xfs, reiser...), and that we could
implement scrub-erasing of unused filesystem areas properly.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
