Return-Path: <linux-kernel-owner+w=401wt.eu-S1761932AbYGOU0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761932AbYGOU0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbYGOU0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:26:12 -0400
Received: from cobra.newdream.net ([66.33.216.30]:36903 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbYGOU0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:26:10 -0400
Date: Tue, 15 Jul 2008 13:26:09 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andreas Dilger <adilger@sun.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
In-Reply-To: <20080715194706.GK6239@webber.adilger.int>
Message-ID: <Pine.LNX.4.64.0807151308250.1976@cobra.newdream.net>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
 <20080715194706.GK6239@webber.adilger.int>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Andreas Dilger wrote:
> > Note that st_blocks is _not_ recursively defined, so 'du' still behaves as 
> > expected.  If mounted with -o norbytes instead, the directory st_size is 
> > the number of entries in the directory.
> 
> Is it possible to extract an environment variable from the process
> in the kernel to decide what behaviour to have (e.g. like LS_COLORS)?

That could work too.  Currently the flag is changing the client's i_size, 
but the conditional can go in place of generic_fillattr, where st_size is 
set.  I would worry about the overhead of looking at the environment for 
every getattr, though.

> > The second interface takes advantage of the fact (?) that read() on a 
> > directory is more or less undefined.  (Okay, that's not really true, but 
> > it used to return encoded dirents or something similar, and more recently 
> > returns -EISDIR.  As far as I know, no sane application expects meaningful 
> > data from read() on a directory...)  So, assuming Ceph is mounted with -o 
> > dirstat,
> 
> Hmm, what about just creating a virtual xattr that can be had with
> getfattr user.dirstats?

Yeah, or ceph.dirstats, which hopefully backup software would ignore?  
(Not quite sure how the xattr 'namespaces' are intended to be used.)  Not 
quite as convenient as 'cat dir' for the user, but cleaner.

> >  - The 'rbytes' summation is over i_size, not blocks used.  That means 
> > sparse files "appear" larger than the storage space they actually consume.
> 
> I'd think that in many cases it is more important to accumulate the
> blocks count and not the size, since a single core file would throw
> off the whole "hunt for the worst space consumer" approach.

Yes.  If and when the MDS actually stores blocks used, that could 
trivially be supported as well.  But currently sparseness is a function of 
the objects on the storage nodes, so things like hole-finding and fiemap 
will require probing objects.

thanks-
sage
