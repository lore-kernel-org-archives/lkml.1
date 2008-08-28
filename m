Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbYH1BJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbYH1BJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYH1BJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:09:05 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:17439 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161AbYH1BJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:09:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AikEAHCVtUh5LD0wamdsb2JhbACSPRICHqcIgWg
X-IronPort-AV: E=Sophos;i="4.32,283,1217773800"; 
   d="scan'208";a="181836058"
Date: Thu, 28 Aug 2008 11:08:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: david@lang.hm
Cc: Jamie Lokier <jamie@shareable.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080828010856.GB30189@disturbed>
Mail-Followup-To: david@lang.hm, Jamie Lokier <jamie@shareable.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>, gus3 <musicman529@yahoo.com>,
	Szabolcs Szakacsits <szaka@ntfs-3g.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <20080821051508.GB5706@disturbed> <200808211933.34565.nickpiggin@yahoo.com.au> <20080821170854.GJ5706@disturbed> <200808221229.11069.nickpiggin@yahoo.com.au> <20080825015922.GP5706@disturbed> <20080825120146.GC20960@shareable.org> <20080826030759.GY5706@disturbed> <alpine.DEB.1.10.0808252041300.29665@asgard.lang.hm> <20080827012013.GC5706@disturbed> <alpine.DEB.1.10.0808271450280.907@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808271450280.907@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 02:54:28PM -0700, david@lang.hm wrote:
> On Wed, 27 Aug 2008, Dave Chinner wrote:
>
>> On Mon, Aug 25, 2008 at 08:50:14PM -0700, david@lang.hm wrote:
>>> it sounds as if the various flag definitions have been evolving, would it
>>> be worthwhile to sep back and try to get the various filesystem folks to
>>> brainstorm together on what types of hints they would _like_ to see
>>> supported?
>>
>> Three types:
>>
>> 	1. immediate dispatch - merge first with adjacent requests
>> 	   then dispatch
>> 	2. delayed dispatch - queue for a short while to allow
>> 	   merging of requests from above
>> 	3. bulk data - queue and merge. dispatch is completely
>> 	   controlled by the elevator
>
> does this list change if you consider the fact that there may be a raid  
> array or some more complex structure for the block device instead of a  
> simple single disk partition?

No. The whole point of immediate dispatch is that those I/Os are
extremely latency sensitive (i.e. whole fs can stall waiting or
them), so it doesn't matter what the end target is. The faster the
storage subsystem, the more important it is to dispatch those
I/Os immediately to keep the pipes filled...

> since I am suggesting re-thinking the filesystem <-> elevator interface,  
> is there anything you need to have the elevator tell the filesystem? (I'm 
> thinking that this may be the path for the filesystem to learn things  
> about the block device that's under it, is it a raid array, a solid-state 
> drive, etc)

Not so much the elevator, but the block layer in general. That is:

	- capability reporting
		- barriers and type
		- discard support
		- integrity support
		- maximum number of I/Os that can be in flight
		  before congestion occurs
	- geometry of the underlying storage
		- independent domains within the device (e.g. boundaries
		  of linear concatentations)
		- stripe unit/width per domain
		- optimal I/O size per domain
		- latency characteristics per domain
	- notifiers to indicate change of status due to device
	  hotplug back up to the filesystem
		- barrier status change
		- geometry changes due to on-line volume modification
		  (e.g. raid5/6 rebuild after adding a new disk,
		   added another disk to a linear concat, etc)

I'm sure there's more, but that's the list quickly off the top of
my head.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
