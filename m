Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZCLIXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZCLIXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZCLIW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:22:59 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:28516 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751539AbZCLIW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:22:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HGjqNiFl3pJPJQHHbUFy/cN8RyTuV65NxDgoQra5KMvUpfKYlNQoVp1W8dCvIT7wUgQ2r1tuHxsNe2TItutCRpvjo6/TVwVk5n7qMOIGuEUG4iNd6pH13p2ecI4ainQbIuatUzcF9ukDuG8tT+TEn7aO8/bV2rGkMwekwl1jii0=  ;
X-YMail-OSG: 6uT0w90VM1nSiezhPOctrOvD.Vx3Lw_17iZjzMA5RnLexzPvx5mwoYqjGuP.Tti0pLM2jSrYT6O5LFHbpPoqQ.jXqndLtAntIGBJUjm8wu2FhqpP6rTgneoU5tEdefKj1IZ81kKeqbGkdat43nIn32dgpFObKDMN5jLM78MPfnOOSPCDaTft_kydedJy8g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Question regarding concurrent accesses through block device and fs
Date: Thu, 12 Mar 2009 19:22:53 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <m2hc2yulrw.fsf@gmail.com> <200903031452.43086.nickpiggin@yahoo.com.au> <38b2ab8a0903120105s59f21e0dv1dd67df41dcb2f9d@mail.gmail.com>
In-Reply-To: <38b2ab8a0903120105s59f21e0dv1dd67df41dcb2f9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121922.53529.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 19:05:39 Francis Moreau wrote:

> > It was an educated guess ;) I'm quite sure it does.
>
> Ok I think I got the idea now. I though block device main purpose was
> to handle block nodes such as /dev/sdx but it isn't.

Well, /dev/sdX access is important, at least to create and fsck the
filesystem ;) But for most Linux users, I think majority of buffercache
access will be by filesystem metadata access.


> >> I looked at the place where page are normally written back to disk (ie
> >> in background_writeout()) but I can see only the writeback of data, not
> >> metadata...
> >
> > What are you expecting writeback of metadata to look like? To the
> > core kernel it looks the same as writeback of data.
>
> I don't know. I was just thinking that since metadata are special since
> they handle critical file system information, the kernel did treat them
> specially.

It is, but you have to look in the filesystems themselves to see that.
There are some exceptions to that -- eg. sync_mapping_buffers in
buffer.c where it writes out dirty metadata buffers that the filesystem
has attached to a file. But that's fsync driven rather than background
writeout. 


> > But the cache layer on top of that ensures it *appears* not to be mixed
> > up. A problem arises when the system crashes in the middle of this, and
> > we lose that information and see a mixed up filesystem. Hence journalling
> > filesystems.
>
> Ok I guess I win a new tour in the kernel code ;) to understand how the
> cache layer do that.

Ignore details like crashes, direct IO and coherency between data mappings
and buffercache where things get a bit hairy, and it's just a writeback
cache. The last thing you write to some location will be what you get back
if you read from that location -- regardless of whether it is dirty or clean
or not present when you ask for it (and has to be read from disk).

