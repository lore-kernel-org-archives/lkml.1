Return-Path: <linux-kernel-owner+w=401wt.eu-S934641AbXK2XE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641AbXK2XE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933927AbXK2XD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:03:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:33975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933936AbXK2XDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:03:55 -0500
From: Neil Brown <neilb@suse.de>
To: David Chinner <dgc@sgi.com>
Date: Fri, 30 Nov 2007 10:03:47 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18255.17747.484721.210728@notabene.brown>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Race between generic_forget_inode() and sync_sb_inodes()?
In-Reply-To: message from David Chinner on Friday November 30
References: <20071129215544.GK115527101@sgi.com>
	<18255.14346.684631.944181@notabene.brown>
	<20071129222407.GL115527101@sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday November 30, dgc@sgi.com wrote:
> On Fri, Nov 30, 2007 at 09:07:06AM +1100, Neil Brown wrote:
> > 
> > Hi David,
> > 
> > On Friday November 30, dgc@sgi.com wrote:
> > > 
> > > 
> > > I came across this because I've been making changes to XFS to avoid the
> > > inode hash, and I've found that I need to remove the inode from the
> > > dirty list when setting I_WILL_FREE to avoid this race. I can't see
> > > how this race is avoided when inodes are hashed, so I'm wondering
> > > if we've just been lucky or there's something that I'm missing that
> > > means the above does not occur.
> > 
> > Looking at inode.c in 2.6.23-mm1, in generic_forget_inode, I see code:
> > 
> > 	if (!hlist_unhashed(&inode->i_hash)) {
> > 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
> > 			list_move(&inode->i_list, &inode_unused);
> > 
> > so it looks to me like:
> >    If the inode is hashed and dirty, then move it (off the s_dirty
> >    list) to inode_unused.
> 
> That check is for if the inode is _not_ dirty or being sync, right?
> Or have I just not had enough coffee this morning?

:-)  And I cannot even blame the lack of coffee as I don't drink it.

My second guess is that we have been lucky.... which is hard to believe.

I wonder if iput (and even iget) should BUG on I_WILL_FREE as well...

Perplexed.

NeilBrown
