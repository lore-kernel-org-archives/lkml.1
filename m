Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbYDCTCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbYDCTCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYDCTCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:02:13 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56745 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYDCTCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:02:12 -0400
Date: Thu, 3 Apr 2008 20:02:12 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, hch@infradead.org
Subject: Re: fs_stack/eCryptfs: remove 3rd arg of copy_attr_all, add locking
 to copy_inode_size
In-Reply-To: <20080403182001.GB30189@josefsipek.net>
Message-ID: <Pine.LNX.4.64.0804031951430.840@blonde.site>
References: <200804030149.m331nBCv005555@agora.fsl.cs.sunysb.edu>
 <20080403182001.GB30189@josefsipek.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Josef 'Jeff' Sipek wrote:
> On Wed, Apr 02, 2008 at 09:49:11PM -0400, Erez Zadok wrote:
> ...
> > +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> > +	spin_lock(&dst->i_lock);
> > +#endif
> 
> I think you need to check CONFIG_PREEMPT as well.

Don't i_size_read() and i_size_write() handle that case adequately
themselves with preempt_dis/enable?

If you mean it'd be better to have the preempt_dis/enable bracketing
around the i_size_read() along with the i_size_write(): well, could
do, but if lower i_size is changing underneath us in that way,
it can just as well change again a moment later, so no point.

The bit that worries me, that prevents me from saying Acked-by,
is that I'm unsure of the extent to which lower filesystems are
relying on i_mutex or something else for their i_size serialization.
Using the i_lock here plays well with unionfs internally, and fixes
the hangs I used to see; but relying on one locking scheme here and
another below is uncomfortable for me.  But it is an improvement.

Hugh
