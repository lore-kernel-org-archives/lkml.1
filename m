Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbXDXOz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbXDXOz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 10:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXDXOz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 10:55:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49621 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbXDXOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 10:55:28 -0400
Date: Tue, 24 Apr 2007 15:55:25 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, gnb@sgi.com,
       xfs-oss <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: review: don't block non-blocking writes when frozen
Message-ID: <20070424145525.GA18918@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Chinner <dgc@sgi.com>, gnb@sgi.com, xfs-oss <xfs@oss.sgi.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070423002616.GY32602149@melbourne.sgi.com> <20070423212715.GF13572@infradead.org> <20070423231337.GN32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423231337.GN32602149@melbourne.sgi.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 09:13:37AM +1000, David Chinner wrote:
> So, given the catch-22 you've just presented us can we revisit the
> nfsd non-blocking I/O issue again?  This affects anyone using DM
> snapshots on their NFS servers and has nothing to do with HSMs
> or DMAPI...
> 
> FWIW, you can still do non-blocking userspace I/O to a file, so this
> XFS patch is still valid for mainline (that's how I tested it).

I've been investigating the situation a little bit more, and here's
what's going on:

 - SuS allows for O_NONBLOCK on regular files as per
   http://www.opengroup.org/onlinepubs/007908799/xsh/write.html
 - actually implementing O_NONBLOCK semantics for regular fixes
   breaks userspace when poll/select claims files are ready to
   read/write but they aren't, see http://lkml.org/lkml/2004/10/17/17

So we can't really expose O_NONBLOCK on regular files to userspace,
and we need to make sure in common code this does not happen.

EJUKEBOX on snaphots does make sense, though.  Can you please send
a full patchseries for nfsd, the common code and the xfs writepath
so that this actually gets used and behaviour is consistant for all
(or at least most) filesystems?

Also now that the patch goes to mainline please kill ugly FILP_DELAY_FLAG
and just check the flags directly.  And it should probably only check
O_NONBLOCK.  The only architecture having O_NDELAY different from
O_NONBLOCK is sparc, and it already translates the value for us.



