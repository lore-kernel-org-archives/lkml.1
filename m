Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYCPUeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYCPUeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 16:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYCPUeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 16:34:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37243 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752167AbYCPUeE (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 16:34:04 -0400
Date: Mon, 17 Mar 2008 07:33:47 +1100
From: David Chinner <dgc@sgi.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Milan Broz <mbroz@redhat.com>, David Chinner <dgc@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       dm-devel@redhat.com
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Message-ID: <20080316203347.GX95344431@sgi.com>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com> <47DA44EB.8000307@redhat.com> <alpine.DEB.1.00.0803150044130.4696@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0803150044130.4696@sheep.housecafe.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2008 at 12:58:02AM +0100, Christian Kujau wrote:
> On Fri, 14 Mar 2008, Milan Broz wrote:
> >Yes, there is bug in dm-crypt...
> >Please try if the patch here helps: http://lkml.org/lkml/2008/3/14/71
> 
> Hm, it seems to help the hangs, yes. Applied to today's -git a few hours 
> ago, the hangs are gone. However, when doing lots of disk I/O, the machine 
> locks up after a few (10-20) minutes. Sadly, netconsole got nothing :(
> 
> After the first lockup I tried again and shortly after bootup I got:

False positive. Memory reclaim can inverts the order of iprune_mutex and
the normal inode locking orders. i.e. Both of these are possible:

	do_something()
	enter memory reclaim
	iprune_mutex
	inode lock

or
	do_something()
	inode lock
	do_something_else
	enter memory reclaim
	iprune_mutex
	inode lock on different inode

So depending on what is seen first (in this case the first), the second
will trip lockdep. Neither are a deadlock, because the inode lock
held before memory reclaim is a referenced inode and will *never* be
on the free list for memory reclaim to deadlock on....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
