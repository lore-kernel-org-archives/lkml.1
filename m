Return-Path: <linux-kernel-owner+w=401wt.eu-S1765879AbXJZWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765879AbXJZWBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbXJZWBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:01:02 -0400
Received: from adsl-67-117-79-109.dsl.sntc01.pacbell.net ([67.117.79.109]:4436
	"EHLO aurum.uhlenkott.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbXJZWBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:01:00 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 18:01:00 EDT
Date: Fri, 26 Oct 2007 14:55:50 -0700
From: Jason Uhlenkott <jasonuhl@jasonuhl.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mike Waychison <mikew@google.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] Drop CAP_SYS_RAWIO requirement for FIBMAP
Message-ID: <20071026215550.GA27037@aurum.uhlenkott.net>
References: <20071025230758.945535769@crlf.corp.google.com> <20071026012217.4cc30390@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071026012217.4cc30390@the-village.bc.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 01:22:17 +0100, Alan Cox wrote:
> On Thu, 25 Oct 2007 16:06:40 -0700
> Mike Waychison <mikew@google.com> wrote:
> 
> > Remove the need for having CAP_SYS_RAWIO when doing a FIBMAP call on an open file descriptor.
> > 
> > It would be nice to allow users to have permission to see where their data is landing on disk, and there really isn't a good reason to keep them from getting at this information.
> 
> Historically this was done because people felt it was more secure. It
> also allows you to make some deductions about other activities on the
> disk but thats probably only a concern for very very security crazed
> compartmentalised boxes
> 
> Also historically at least FIBMAP could be abused to crash the system.
> Now if you can verify that has been fixed I have no problem, but given
> that I can find no record of that being fixed it would be wise to audit
> it first and review Chris Evans and other reports about what occurs when
> FIBMAP is passed random block numbers.
> 
> FIBMAP has another problem for this general use as well - it takes an int
> but the block number can now be bigger for very large files on 32bit.

Additionally, ext3_bmap() has this to say about it:

        if (EXT3_I(inode)->i_state & EXT3_STATE_JDATA) {
                /*
                 * This is a REALLY heavyweight approach, but the use of
                 * bmap on dirty files is expected to be extremely rare:
                 * only if we run lilo or swapon on a freshly made file
                 * do we expect this to happen.
                 *
                 * (bmap requires CAP_SYS_RAWIO so this does not
                 * represent an unprivileged user DOS attack --- we'd be
                 * in trouble if mortal users could trigger this path at
                 * will.)
