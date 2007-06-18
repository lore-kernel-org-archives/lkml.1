Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbXFRJPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbXFRJPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbXFRJPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:15:07 -0400
Received: from mx1.informatik.uni-tuebingen.de ([134.2.12.5]:35713 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbXFRJPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:15:05 -0400
X-Greylist: delayed 1159 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 05:15:05 EDT
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: "David Brown" <dmlb2000@gmail.com>
Cc: fuse-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [fuse-devel] FS block count, size and seek offset?
References: <9c21eeae0706171428u5a9ff79rad2b2083d3436d7f@mail.gmail.com>
Date: Mon, 18 Jun 2007 10:55:39 +0200
In-Reply-To: <9c21eeae0706171428u5a9ff79rad2b2083d3436d7f@mail.gmail.com>
	(David Brown's message of "Sun, 17 Jun 2007 14:28:28 -0700")
Message-ID: <87645lr69g.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"David Brown" <dmlb2000@gmail.com> writes:

> I was looking at various file systems and how they return
> stat.st_blocks and stat.st_size for directories and had some questions
> on how a fuse filesystem is supposed to implement readdir with the
> seek offset when trying to union two directories together.
>
> Is the offset a byte offset into the DIR *dp? or is it the struct
> dirent size (which is relative based on the name of the file) into the
> dir pointer?

I think it is totaly your call what you store in it. Only requirement
is that you never pass 0 to the filler function.

off_t is 64bit so storing DIR* in it should be no problem. Or a
pointer to

struct UnionDIR {
  DIR *dp;
  struct UnionDIR *next;
}

> Also, if you want to be accurate when you stat a directory that's
> unioned in the fuse file system how many blocks should one return?
> Since each filesystem seems to return different values for size and
> number of blocks for directories. I know I could just say that its not
> supported with my filesystem built using fuse... but I'd like to at
> least try to be accurate.

You could add them up and round it to some common block size (if they
differ). But I don't think it maters and nothing uses that info.

What is more important is the link count. For example find uses the
link count to know how many subdirs a directory has. Once it found
that many it assumes there are no more dirs and saves on stat() calls.

> Is it accurate to assume that the size or number of blocks returned
> from a stat will be used to pass a seek offset?
>
> When does fuse use the seek offset?

Afaik never. The offset is only stored for the next readdir call but
never used inside fuse.

> These are the number of blocks and size on an empty dir.
> ext3
> size 4096 nblocks 8
> reiserfs
> size 48 nblocks 0
> jfs
> size 1 nblocks 0
> xfs
> size 6 nblocks 0
>
> Any help to figure out how to union two directories and return correct
> values would be helpful.

Why don't you use the existing fuse-unionfs?

> Thanks,
> - David Brown
>
> P.S. maybe a posix filesystem interface manual would be good?

MfG
        Goswin
