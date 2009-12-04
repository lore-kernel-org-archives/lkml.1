Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbZLDCAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbZLDCAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZLDCA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:00:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZLDCA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:00:28 -0500
Date: Thu, 3 Dec 2009 17:58:27 -0800
From: Greg KH <gregkh@suse.de>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       "stable@kernel.org" <stable@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: flush wl before clearing update marker
Message-ID: <20091204015827.GB2589@suse.de>
References: <1259736523-13091-1-git-send-email-Artem.Bityutskiy@nokia.com> <20091202154223.GA5895@suse.de> <1259823705.10805.49.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259823705.10805.49.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 09:01:45AM +0200, Artem Bityutskiy wrote:
> On Wed, 2009-12-02 at 16:42 +0100, ext Greg KH wrote:
> > On Wed, Dec 02, 2009 at 08:48:43AM +0200, Artem Bityutskiy wrote:
> > > From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> > > 
> > > ubiupdatevol -t does the following:
> > > - ubi_start_update()
> > >   - set_update_marker()
> > >   - for all LEBs ubi_eba_unmap_leb()
> > >   - clear_update_marker()
> > >   - ubi_wl_flush()
> > > 
> > > ubi_wl_flush() physically erases all PEB, once it returns all PEBs are
> > > empty. clear_update_marker() has the update marker written after return.
> > > If there is a power cut between the last two functions then the UBI
> > > volume has no longer the "update" marker set and may have some valid
> > > LEBs while some of them may be gone.
> > > If that volume in question happens to be a UBIFS volume, then mount
> > > will fail with
> > > 
> > > |UBIFS error (pid 1361): ubifs_read_node: bad node type (255 but expected 6)
> > > |UBIFS error (pid 1361): ubifs_read_node: bad node at LEB 0:0
> > > |Not a node, first 24 bytes:
> > > |00000000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > 
> > > if there is at least one valid LEB and the wear-leveling worker managed
> > > to clear LEB 0.
> > > 
> > > The patch waits for the wl worker to finish prior clearing the "update"
> > > marker on flash. The two new LEB which are scheduled for erasing after
> > > clear_update_marker() should not matter because they are only visible to
> > > UBI.
> > > 
> > > Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> > > Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > > Cc: stable@kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >  drivers/mtd/ubi/upd.c |   20 +++++++++++---------
> > 
> > 
> > I'm not the mtd or ubi maintainer, so why did you send this to me?
> 
> Sorry, I thought the protocol to get to -stable is to send to you and CC
> stable. I maintain UBI and just wanted to send this patch to -stable. I
> googled a bit and could not find the right way.

Look in the Documentation/stable_kernel_rules.txt that shows all you
need is the Cc: stable@kernel.org section in the Signed-off-by area like
you did.

So when this goes into Linus's tree, I'll automatically get it in the
right inbox and know to apply it to the -stable tree.

thanks,

greg k-h
