Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbXK2WHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbXK2WHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762737AbXK2WHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:07:15 -0500
Received: from ns2.suse.de ([195.135.220.15]:50399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762711AbXK2WHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:07:13 -0500
From: Neil Brown <neilb@suse.de>
To: David Chinner <dgc@sgi.com>
Date: Fri, 30 Nov 2007 09:07:06 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18255.14346.684631.944181@notabene.brown>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Race between generic_forget_inode() and sync_sb_inodes()?
In-Reply-To: message from David Chinner on Friday November 30
References: <20071129215544.GK115527101@sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

On Friday November 30, dgc@sgi.com wrote:
> 
> 
> I came across this because I've been making changes to XFS to avoid the
> inode hash, and I've found that I need to remove the inode from the
> dirty list when setting I_WILL_FREE to avoid this race. I can't see
> how this race is avoided when inodes are hashed, so I'm wondering
> if we've just been lucky or there's something that I'm missing that
> means the above does not occur.

Looking at inode.c in 2.6.23-mm1, in generic_forget_inode, I see code:

	if (!hlist_unhashed(&inode->i_hash)) {
		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
			list_move(&inode->i_list, &inode_unused);

so it looks to me like:
   If the inode is hashed and dirty, then move it (off the s_dirty
   list) to inode_unused.

So it seems to me that generic_forget_inode also finds it needs to
remove the inode from the dirty list when setting I_WILL_FREE.

Maybe we are looking at different kernel versions?  Maybe I
misunderstood your problem?

NeilBrown
