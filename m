Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbZLDFnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbZLDFnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 00:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZLDFnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 00:43:18 -0500
Received: from smtp.nokia.com ([192.100.122.233]:59382 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZLDFnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 00:43:18 -0500
Subject: Re: [PATCH] UBI: flush wl before clearing update marker
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Greg KH <gregkh@suse.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       "stable@kernel.org" <stable@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091204015827.GB2589@suse.de>
References: <1259736523-13091-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <20091202154223.GA5895@suse.de> <1259823705.10805.49.camel@localhost>
	 <20091204015827.GB2589@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 04 Dec 2009 07:42:28 +0200
Message-Id: <1259905348.8673.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Dec 2009 05:42:33.0636 (UTC) FILETIME=[93C8F640:01CA74A4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 02:58 +0100, ext Greg KH wrote:
> On Thu, Dec 03, 2009 at 09:01:45AM +0200, Artem Bityutskiy wrote:
> > On Wed, 2009-12-02 at 16:42 +0100, ext Greg KH wrote:
> > > On Wed, Dec 02, 2009 at 08:48:43AM +0200, Artem Bityutskiy wrote:
> > > > From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> > > > 
> > > > ubiupdatevol -t does the following:
> > > > - ubi_start_update()
> > > >   - set_update_marker()
> > > >   - for all LEBs ubi_eba_unmap_leb()
> > > >   - clear_update_marker()
> > > >   - ubi_wl_flush()
> > > > 
> > > > ubi_wl_flush() physically erases all PEB, once it returns all PEBs are
> > > > empty. clear_update_marker() has the update marker written after return.
> > > > If there is a power cut between the last two functions then the UBI
> > > > volume has no longer the "update" marker set and may have some valid
> > > > LEBs while some of them may be gone.
> > > > If that volume in question happens to be a UBIFS volume, then mount
> > > > will fail with
> > > > 
> > > > |UBIFS error (pid 1361): ubifs_read_node: bad node type (255 but expected 6)
> > > > |UBIFS error (pid 1361): ubifs_read_node: bad node at LEB 0:0
> > > > |Not a node, first 24 bytes:
> > > > |00000000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > > 
> > > > if there is at least one valid LEB and the wear-leveling worker managed
> > > > to clear LEB 0.
> > > > 
> > > > The patch waits for the wl worker to finish prior clearing the "update"
> > > > marker on flash. The two new LEB which are scheduled for erasing after
> > > > clear_update_marker() should not matter because they are only visible to
> > > > UBI.
> > > > 
> > > > Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> > > > Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > > > Cc: stable@kernel.org
> > > > Cc: linux-kernel@vger.kernel.org
> > > > ---
> > > >  drivers/mtd/ubi/upd.c |   20 +++++++++++---------
> > > 
> > > 
> > > I'm not the mtd or ubi maintainer, so why did you send this to me?
> > 
> > Sorry, I thought the protocol to get to -stable is to send to you and CC
> > stable. I maintain UBI and just wanted to send this patch to -stable. I
> > googled a bit and could not find the right way.
> 
> Look in the Documentation/stable_kernel_rules.txt that shows all you
> need is the Cc: stable@kernel.org section in the Signed-off-by area like
> you did.
> 
> So when this goes into Linus's tree, I'll automatically get it in the
> right inbox and know to apply it to the -stable tree.

Oh, thanks a lot!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

