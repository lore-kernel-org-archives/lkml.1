Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbYBGQmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbYBGQmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYBGQmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:42:47 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51188 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYBGQmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:42:46 -0500
Date: Thu, 7 Feb 2008 16:40:54 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Matt Helsley <matthltc@us.ibm.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Miklos Szeredi <mszeredi@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       William Lee Irwin III <wli@holomorphy.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] sys_remap_file_pages: fix ->vm_file accounting
In-Reply-To: <1202343398.9062.253.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0802071546580.29324@blonde.site>
References: <20080130142014.GA2164@tv-sign.ru>  <1201712101.31222.22.camel@tucsk.pomaz.szeredi.hu>
  <20080130172646.GA2355@tv-sign.ru>  <1201987065.9062.6.camel@localhost.localdomain>
  <20080203182135.GA5827@tv-sign.ru>  <Pine.LNX.4.64.0802062023100.32204@blonde.site>
 <1202343398.9062.253.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Matt Helsley wrote:
> On Wed, 2008-02-06 at 20:33 +0000, Hugh Dickins wrote:
> > 
> > Sorry, Matt, I don't like your patch at all.  It seems to add a fair
> > amount of ugliness and unmaintainablity, all for a peculiar MVFS case
> 
> I thought that getting rid of the separate versions of proc_exe_link()
> improved maintainability.

That's a plus, but I don't see it balances the minus.

> Do you have any specific details on what you
> think makes the code introduced by the patch unmaintainable?

The fact that you now have to shadow operations on vm_file by
operations on your exe_file, easy to get out of step; and that
we'll tend not to notice when it goes wrong, because the common
case will have them both in the root mount (that will hide busy
errors, won't it? or am I mistaken?).

Though I should concede that your latest patch looks like it catches
all the places it needs to, and that they don't really stretch beyond
mm/mmap.c.  If you provided functions to do the get_file/fput/VM_EXE-
CUTABLE stuff, most of the ugliness would be confined to fs/proc/base.c.

I much preferred Andrew's take-a-copy-of-the-pathname approach, but
admit I'm not one to appreciate the namespace arguments against it.
I wish I had a more constructive solution.

> I still think it would help any stacking filesystems that can't use the
> solution adopted by unionfs.

If you think it's going to help lots of others, please get them to
speak up in support.  But we're rather short of stacking filesystems
in the kernel at present, so it can be hard to argue.

> > And I found it quite hard to see where the crucial difference comes.
> > I guess it's that MVFS changes vma->vm_file in its ->mmap?  Well, if
> 
> Yup.
> 
> > MVFS does that, maybe something else does that too, but precisely to
> > rely on the present behaviour of /proc/pid/exe - so in fixing for
> > MVFS, we'd be breaking that hypothetical other?
> 
> 	I'm not completely certain that I understand your point. Are you
> suggesting that some hypothetical code would want to use this "quirk"
> of /proc/pid/exe for a legitimate purpose?

Yes, but our different viewpoints give us a different idea of what's
a quirk.  The quirk I see is that MVFS is fiddling with vma->vm_file
in its ->mmap, which is rather unusual (though not unique); and then
complaining when this doesn't work as it wants.  But you see it as a
quirk that the VM_EXECUTABLE's vm_file gets used for /proc/pid/exe?

> 	Assuming that is your point, I thought my non-hypothetical java example
> clearly demonstrated that at least one non-hypothetical program doesn't
> expect the "quirk" and breaks because of it.

Yes, and I'm suggesting that if we change the behaviour to suit you,
we might be causing a regression in something else.  No evidence for
that, but it's a possibility (though probably not one I'd be arguing,
if I actually liked the patch involved).

When and if the VFS provides integrated support for stacking filesystems,
it would make sense to do something about this.  But as things stand, it's
for the stacking filesystem to manage its stack.  Why uglify the kernel
code (which doesn't include any user for this), instead of managing that
stacking yourself i.e. why not leave vm_file as is (or if necessary
point it to a proxy), and use its private_data for your optimizations?

> Frankly,
> given /proc/pid/exe's output in the non-stacking case, I can't see how
> its output in the stacking case we're discussing could be considered
> anything but buggy.

But whose bug?

Hugh
