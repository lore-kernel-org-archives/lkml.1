Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbXKGHPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbXKGHPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 02:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbXKGHPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 02:15:11 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:5977 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbXKGHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 02:15:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g974VbzY1isJ1U97XRl4uw5nteTXoERjO8CA2Lr4hK8vnQj38XEv2vhyZLismlvNTMU3ufypTPduW491+QpvMWIJwILflpOoCR8SwlkxFh/gtgjTwnFLwGIK8WL1DHLI15ruB+CQ5e8jFBH79s8Xrni0KYrbyl6ZJQUEZPz73rg=
Message-ID: <64bb37e0711062315jef9efd7xc2ffc11b6d6c60fa@mail.gmail.com>
Date: Wed, 7 Nov 2007 08:15:06 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: writeout stalls in current -git
Cc: "Fengguang Wu" <wfg@mail.ustc.edu.cn>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20071107021324.GD995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
	 <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
	 <394340668.31055@ustc.edu.cn>
	 <64bb37e0711061353g4a8b881cgd78fef3a11378b9c@mail.gmail.com>
	 <20071106233114.GB995458@sgi.com> <20071107021324.GD995458@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/07, David Chinner <dgc@sgi.com> wrote:
> Ok, so it's not synchronous writes that we are doing - we're just
> submitting bio's tagged as WRITE_SYNC to get the I/O issued quickly.
> The "synchronous" nature appears to be coming from higher level
> locking when reclaiming inodes (on the flush lock). It appears that
> inode write clustering is failing completely so we are writing the
> same block multiple times i.e. once for each inode in the cluster we
> have to write.

Works for me. The only remaining stalls are sub second and look
completely valid, considering the amount of files being removed.

iostat 10 from this test:
 3  0      0 3500192    332 204956    0    0   105  8512 1809 6473  6 10 83  1
 0  0      0 3500200    332 204576    0    0     0  4367 1355 3712  2  6 92  0
 2  0      0 3504264    332 203528    0    0     0  6805 1912 4967  4  8 88  0
 0  0      0 3511632    332 203528    0    0     0  2843  805 1791  2  4 94  0
 0  0      0 3516852    332 203516    0    0     0  3375  879 2712  3  5 93  0
 0  0      0 3530544    332 202668    0    0   186   776  488 1152  4  2 89  4
 0  0      0 3574788    332 204960    0    0   226   326  358  787  0  1 98  0
 0  0      0 3576820    332 204960    0    0     0   376  332  737  0  0 99  0
 0  0      0 3578432    332 204960    0    0     0   356  293  606  1  1 99  0
 0  0      0 3580192    332 204960    0    0     0   101  104  384  0  0 99  0

I'm pleased to note that this is now much faster again.
Thanks!

Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>

CC's please note: It looks like this was really a different problem
then the 100% iowait that was seen with reiserfs.
Also the one complete stall I have seen is probably something else.
But I have not been able to reproduce this again with -mm and have
never seen this on mainline, so I will just ignore that single event
until I see it again.

Torsten

> ---
>  fs/xfs/xfs_iget.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c        2007-11-02 13:44:46.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c     2007-11-07 13:08:42.534440675 +1100
> @@ -248,7 +248,7 @@ finish_inode:
>         icl = NULL;
>         if (radix_tree_gang_lookup(&pag->pag_ici_root, (void**)&iq,
>                                                         first_index, 1)) {
> -               if ((iq->i_ino & mask) == first_index)
> +               if ((XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) == first_index)
>                         icl = iq->i_cluster;
>         }
>
>
