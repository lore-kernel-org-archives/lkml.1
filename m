Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752577AbYLQTx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbYLQTx7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYLQTxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:53:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbYLQTxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:53:45 -0500
Date: Wed, 17 Dec 2008 11:53:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: adilger@sun.com, chris.mason@oracle.com, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Notes on support for multiple devices for a single filesystem
Message-Id: <20081217115325.3312858a.akpm@linux-foundation.org>
In-Reply-To: <20081217132343.GA14695@infradead.org>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	<1228962896.21376.11.camel@think.oraclecorp.com>
	<20081211141436.030c2d65.sfr@canb.auug.org.au>
	<20081210200604.8e190b0d.akpm@linux-foundation.org>
	<1229006596.22236.46.camel@think.oraclecorp.com>
	<20081215210323.GB5000@webber.adilger.int>
	<20081217132343.GA14695@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 08:23:44 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> FYI: here's a little writeup I did this summer on support for
> filesystems spanning multiple block devices:
> 
> 
> -- 
> 
> === Notes on support for multiple devices for a single filesystem ===
> 
> == Intro ==
> 
> Btrfs (and an experimental XFS version) can support multiple underlying block
> devices for a single filesystem instances in a generalized and flexible way.
> 
> Unlike the support for external log devices in ext3, jfs, reiserfs, XFS, and
> the special real-time device in XFS all data and metadata may be spread over a
> potentially large number of block devices, and not just one (or two)
> 
> 
> == Requirements ==
> 
> We want a scheme to support these complex filesystem topologies in way
> that is
> 
>  a) easy to setup and non-fragile for the users
>  b) scalable to a large number of disks in the system
>  c) recoverable without requiring user space running first
>  d) generic enough to work for multiple filesystems or other consumers
> 
> Requirement a) means that a multiple-device filesystem should be mountable
> by a simple fstab entry (UUID/LABEL or some other cookie) which continues
> to work when the filesystem topology changes.

"device topology"?

> Requirement b) implies we must not do a scan over all available block devices
> in large systems, but use an event-based callout on detection of new block
> devices.
> 
> Requirement c) means there must be some version to add devices to a filesystem
> by kernel command lines, even if this is not the default way, and might require
> additional knowledge from the user / system administrator.
> 
> Requirement d) means that we should not implement this mechanism inside a
> single filesystem.
> 

One thing I've never seen comprehensively addressed is: why do this in
the filesystem at all?  Why not let MD take care of all this and
present a single block device to the fs layer?

Lots of filesystems are violating this, and I'm sure the reasons for
this are good, but this document seems like a suitable place in which to
briefly decribe those reasons.

