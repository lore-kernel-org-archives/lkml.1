Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbZLCHCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbZLCHCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZLCHCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:02:47 -0500
Received: from smtp.nokia.com ([192.100.122.230]:26201 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZLCHCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:02:45 -0500
Subject: Re: [PATCH] UBI: flush wl before clearing update marker
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Greg KH <gregkh@suse.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       "stable@kernel.org" <stable@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091202154223.GA5895@suse.de>
References: <1259736523-13091-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <20091202154223.GA5895@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Thu, 03 Dec 2009 09:01:45 +0200
Message-Id: <1259823705.10805.49.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Dec 2009 07:01:46.0693 (UTC) FILETIME=[7A6A2750:01CA73E6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 16:42 +0100, ext Greg KH wrote:
> On Wed, Dec 02, 2009 at 08:48:43AM +0200, Artem Bityutskiy wrote:
> > From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> > 
> > ubiupdatevol -t does the following:
> > - ubi_start_update()
> >   - set_update_marker()
> >   - for all LEBs ubi_eba_unmap_leb()
> >   - clear_update_marker()
> >   - ubi_wl_flush()
> > 
> > ubi_wl_flush() physically erases all PEB, once it returns all PEBs are
> > empty. clear_update_marker() has the update marker written after return.
> > If there is a power cut between the last two functions then the UBI
> > volume has no longer the "update" marker set and may have some valid
> > LEBs while some of them may be gone.
> > If that volume in question happens to be a UBIFS volume, then mount
> > will fail with
> > 
> > |UBIFS error (pid 1361): ubifs_read_node: bad node type (255 but expected 6)
> > |UBIFS error (pid 1361): ubifs_read_node: bad node at LEB 0:0
> > |Not a node, first 24 bytes:
> > |00000000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > 
> > if there is at least one valid LEB and the wear-leveling worker managed
> > to clear LEB 0.
> > 
> > The patch waits for the wl worker to finish prior clearing the "update"
> > marker on flash. The two new LEB which are scheduled for erasing after
> > clear_update_marker() should not matter because they are only visible to
> > UBI.
> > 
> > Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> > Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > Cc: stable@kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/mtd/ubi/upd.c |   20 +++++++++++---------
> 
> 
> I'm not the mtd or ubi maintainer, so why did you send this to me?

Sorry, I thought the protocol to get to -stable is to send to you and CC
stable. I maintain UBI and just wanted to send this patch to -stable. I
googled a bit and could not find the right way.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

