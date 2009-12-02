Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZLBPph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZLBPph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZLBPpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:45:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZLBPpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:45:36 -0500
Date: Wed, 2 Dec 2009 07:42:23 -0800
From: Greg KH <gregkh@suse.de>
To: Artem Bityutskiy <Artem.Bityutskiy@Nokia.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: flush wl before clearing update marker
Message-ID: <20091202154223.GA5895@suse.de>
References: <1259736523-13091-1-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259736523-13091-1-git-send-email-Artem.Bityutskiy@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 08:48:43AM +0200, Artem Bityutskiy wrote:
> From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> ubiupdatevol -t does the following:
> - ubi_start_update()
>   - set_update_marker()
>   - for all LEBs ubi_eba_unmap_leb()
>   - clear_update_marker()
>   - ubi_wl_flush()
> 
> ubi_wl_flush() physically erases all PEB, once it returns all PEBs are
> empty. clear_update_marker() has the update marker written after return.
> If there is a power cut between the last two functions then the UBI
> volume has no longer the "update" marker set and may have some valid
> LEBs while some of them may be gone.
> If that volume in question happens to be a UBIFS volume, then mount
> will fail with
> 
> |UBIFS error (pid 1361): ubifs_read_node: bad node type (255 but expected 6)
> |UBIFS error (pid 1361): ubifs_read_node: bad node at LEB 0:0
> |Not a node, first 24 bytes:
> |00000000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> if there is at least one valid LEB and the wear-leveling worker managed
> to clear LEB 0.
> 
> The patch waits for the wl worker to finish prior clearing the "update"
> marker on flash. The two new LEB which are scheduled for erasing after
> clear_update_marker() should not matter because they are only visible to
> UBI.
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: stable@kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/mtd/ubi/upd.c |   20 +++++++++++---------


I'm not the mtd or ubi maintainer, so why did you send this to me?

confused,

greg k-h
