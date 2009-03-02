Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbZCBHMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbZCBHMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 02:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbZCBHMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 02:12:21 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:30611 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752886AbZCBHMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 02:12:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=B4rSicmFRS1Jb2yVHqj+ainRONCWE4tf3wEta6/TG+p87nXomtadnpecmZUlGv2MNke+tXE/LbMOFlw7PhPD9bS2TWGULK5roxVT+ahflbeJO3W+65vGHFJrx5tz+woVz/ljnWiR/d5xXy8D5pzuyONICHo9snX7iXz73R/ofkg=  ;
X-YMail-OSG: Zp3fiT4VM1kFzLgNmC42cSy3gHtRatoV1k0STeY8EjLpZFiJN4sBXG09laWirI.ev_9aSzQVtxDBRYZ9D1wRqE6fnqvbVqGIFWUww7HAmMi_KD7mnvqknbjbZn9L5WA9ejS9KbGXPi.h.vBWEZr9I9U9B49kixmPXTs.OteFfhIfoCLlYEGWXnG845nLPM3eNza.p15frgm.vKIpfVp3TTNW_4.OPevvn0M-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Question regarding concurrent accesses through block device and fs
Date: Mon, 2 Mar 2009 18:11:43 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <m2hc2yulrw.fsf@gmail.com> <200903020232.48311.nickpiggin@yahoo.com.au> <m2y6vplzot.fsf@gmail.com>
In-Reply-To: <m2y6vplzot.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021811.43653.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009 08:07:30 Francis Moreau wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:

> > Depends on the filesystem. Many do just use the buffercache as a
> > writeback cache for their metadata, and are happy to just let the
> > dirty page flushers write it out when it suits them
>
> I guess you're talking about the pdflush threads here.

Yeah.


> This is the case where I can't find when the metadata are actually
> written back to the disk by the flushers. I looked at
> writback_inodes() but I fail to find this out.
>
> Could you point out the place in the code where this happen ?


I guess it picks them up via their block device inodes.


> > (or when there are explicit sync instructions given).
>
> yes I see where this happens in these cases.
>
> > Most of the time, these filesystems don't really know or care when
> > exactly their metadata is under writeback.
>
> This sounds very weird to me but I need to learn how things work
> before doing any serious comments.

Why would they? They just operate on their metadata, and the buffer
cache is basically a transparent writeback cache to them. In the
same way, an application doesn't really know or care when exactly
its data is under writeback. unmap_underlying_metadata is the
important exception because Linux pagecache otherwise doesn't have
a good way to keep pagecache of different mappings coherent. So if
a block switches from buffercache to file mapping, it needs to be
made coherent.

When switching back the other way, the truncate code actually makes
sure of this, that there won't be blocks under writeout after
being deallocated.

Things do get more complicated with journalling file systems.

