Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYHZDuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYHZDuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 23:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYHZDur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 23:50:47 -0400
Received: from mail.lang.hm ([64.81.33.126]:36043 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbYHZDuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 23:50:46 -0400
Date: Mon, 25 Aug 2008 20:50:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Dave Chinner <david@fromorbit.com>
cc: Jamie Lokier <jamie@shareable.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
 snapshotting file system)
In-Reply-To: <20080826030759.GY5706@disturbed>
Message-ID: <alpine.DEB.1.10.0808252041300.29665@asgard.lang.hm>
References: <20080821051508.GB5706@disturbed> <200808211933.34565.nickpiggin@yahoo.com.au> <20080821170854.GJ5706@disturbed> <200808221229.11069.nickpiggin@yahoo.com.au> <20080825015922.GP5706@disturbed> <20080825120146.GC20960@shareable.org>
 <20080826030759.GY5706@disturbed>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008, Dave Chinner wrote:

> 
> On Mon, Aug 25, 2008 at 01:01:47PM +0100, Jamie Lokier wrote:
>> Dave Chinner wrote:
>>> To keep on top of this, we keep adding new variations and types and
>>> expect the filesystems to make best use of them (without
>>> documentation) to optimise for certain situations. Example - the
>>> new(ish) BIO_META tag that only CFQ understands. I can change the
>>> way XFS issues bios to use this tag to make CFQ behave the same way
>>> it used to w.r.t. metadata I/O from XFS, but then the deadline and
>>> AS will probably regress because they don't understand that tag and
>>> still need the old optimisations that just got removed. Ditto for
>>> prioritised bio dispatch - CFQ supports it but none of the others
>>> do.
>>
>> There's nothing wrong with adding BIO_META (for example) and other
>> hints in _principle_.  You should be able to ignore it with no adverse
>> effects.  If its not used by a filesystem (and there's nothing else
>> competing to use the same disk), I would hope to see the same
>> performance as other kernels which don't have it.
>
> Right, but it's what we need to do to make use of that optimisation
> that is the problem. For XFS, it needs to replace the current
> BIO_SYNC hints we use (even for async I/O) to get metadata
> dispatched quickly. i.e. CFQ looks at the sync flag first then the
> meta flag.  Hence to take advantage of it, we need to remove the
> BIO_SYNC hints we currently use which will change the behaviour on
> all other elevators as a side effect.
>
> This is the optimisation problem I'm refering to - the BIO_SYNC
> usage was done years ago to get metadata dispatched quickly because
> that is what all the elevators did with sync I/O. Now to optimise
> for CFQ we need to remove that BIO_SYNC optimisation which is still
> valid for the other elevators....
>
>> If the elevators are being changed in such a way that old filesystem
>> code which doesn't use new hint bits is running significantly slower,
>> surely that's blatant elevator regression, and that's where the bugs
>> should be reported and fixed?
>
> Sure, but in reality getting ppl to go through the pain of triage is
> extremely rare because it only takes 10s to change elevators and
> make the problem go away...

it sounds as if the various flag definitions have been evolving, would it 
be worthwhile to sep back and try to get the various filesystem folks to 
brainstorm together on what types of hints they would _like_ to see 
supported?

it sounds like you are using 'sync' for things where you really should be 
saying 'metadata' (or 'journal contents'), it's happened to work well 
enough in the past, but it's forcing you to keep tweaking the filesystems. 
it may be better to try and define things from the filesystem point of 
view and let the elevators do the tweaking.

basicly I'm proposing a complete rethink of the filesyste <-> elevator 
interface.

David Lang
