Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbYBZKON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbYBZKON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbYBZKN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:13:59 -0500
Received: from colo.lackof.org ([198.49.126.79]:51803 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbYBZKN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:13:58 -0500
Date: Tue, 26 Feb 2008 03:13:46 -0700
From: dann frazier <dannf@dannf.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Glen Nakamura <glen@imodulo.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.4.36.1 hangs.
Message-ID: <20080226101346.GB20166@colo.lackof.org>
References: <20080223083044.GA24136@1wt.eu> <20080226073612.GA29747@modulo.internal> <20080226081624.GA20022@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226081624.GA20022@1wt.eu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 09:16:25AM +0100, Willy Tarreau wrote:
> On Mon, Feb 25, 2008 at 09:36:12PM -1000, Glen Nakamura wrote:
> > Aloha,
> > 
> > The "ext2_readdir() filp->f_pos fix" patch looks weird...
> > Perhaps the "filp->f_pos += le16_to_cpu(de->rec_len);" line should be
> > outside of the if statement like the indentation implies?
> 
> good catch! At least it's what is done in 2.6.

Yes, that certainly looks like a bug.

> > As it is, filp->f_pos gets corrupted if de->inode is ever zero...
> > This could possibly explain why I had a few strange directory
> > entries until I checked the filesystem with:
> > e2fsck -D -F -f /dev/{ext2 partition}
> > 
> > - glen
> > 
> > Here is an updated (untested) patch:
> 
> unfortunately, neither Dann nor me could reproduce the issue, so
> we'll wait for some victims^Wvolunteers to give it a try.

I'm now able to reliably reproduce it by creating/removing a chroot
(pbuilder create on a Debian system, though I'm sure a simpler test
exists). Correcting the le16_to_cpu placement as Glen described
fixes the issue for me.

> BTW, I notice that 2.6 also has one extra chunk that 2.4 does not
> have :
> 
>                 if (unlikely(need_revalidate)) {
> +                       if (offset) {
>                                 offset = ext2_validate_entry(kaddr, offset, chunk_mask);
> +                               filp->f_pos = (n<<PAGE_CACHE_SHIFT) + offset;
> +                       }
> +                       filp->f_version = inode->i_version;
>                         need_revalidate = 0;
>                 }
> 
> I have no idea whether this part is needed, we'd better ask Theo or Al
> for some advices, as I'm not tempted by merging an uncertain patch when
> it comes to filesystems.

Looks like a test case may be available:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2d7f2ea9c989853310c7f6e8be52cc090cc8e66b

-- 
dann frazier

