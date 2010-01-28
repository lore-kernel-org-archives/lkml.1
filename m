Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969Ab0A1KuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0A1KuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 05:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550Ab0A1KuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 05:50:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:60948 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab0A1KuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 05:50:24 -0500
Date: Thu, 28 Jan 2010 21:50:15 +1100
From: Neil Brown <neilb@suse.de>
To: "Ing. Daniel =?UTF-8?B?Um96c255w7M=?=" <daniel@rozsnyo.com>
Cc: Milan Broz <mbroz@redhat.com>, Marti Raudsepp <marti@juffo.org>,
       linux-kernel@vger.kernel.org
Subject: Re: bio too big - in nested raid setup
Message-ID: <20100128215015.0e0ed3a8@notabene>
In-Reply-To: <4B6157DB.6080502@rozsnyo.com>
References: <4B5C963D.8040802@rozsnyo.com>
	<5ec358371001250725l40b13060md880001c96be165f@mail.gmail.com>
	<4B5DE2A9.4030500@redhat.com>
	<20100128132812.2d01f211@notabene>
	<4B6157DB.6080502@rozsnyo.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010 10:24:43 +0100
"Ing. Daniel Rozsnyó" <daniel@rozsnyo.com> wrote:

> Neil Brown wrote:
> > On Mon, 25 Jan 2010 19:27:53 +0100
> > Milan Broz <mbroz@redhat.com> wrote:
> > 
> >> On 01/25/2010 04:25 PM, Marti Raudsepp wrote:
> >>> 2010/1/24 "Ing. Daniel Rozsnyó" <daniel@rozsnyo.com>:
> >>>> Hello,
> >>>>  I am having troubles with nested RAID - when one array is added to the
> >>>> other, the "bio too big device md0" messages are appearing:
> >>>>
> >>>> bio too big device md0 (144 > 8)
> >>>> bio too big device md0 (248 > 8)
> >>>> bio too big device md0 (32 > 8)
> >>> I *think* this is the same bug that I hit years ago when mixing
> >>> different disks and 'pvmove'
> >>>
> >>> It's a design flaw in the DM/MD frameworks; see comment #3 from Milan Broz:
> >>> http://bugzilla.kernel.org/show_bug.cgi?id=9401#c3
> >> Hm. I don't think it is the same problem, you are only adding device to md array...
> >> (adding cc: Neil, this seems to me like MD bug).
> >>
> >> (original report for reference is here http://lkml.org/lkml/2010/1/24/60 )
> > 
> > No, I think it is the same problem.
> > 
> > When you have a stack of devices, the top level client needs to know the
> > maximum restrictions imposed by lower level devices to ensure it doesn't
> > violate them.
> > However there is no mechanism for a device to report that its restrictions
> > have changed.
> > So when md0 gains a linear leg and so needs to reduce the max size for
> > requests, there is no way to tell DM, so DM doesn't know.  And as the
> > filesystem only asks DM for restrictions, it never finds out about the
> > new restrictions.
> 
> Neil, why does it even reduce its block size? I've tried with both 
> "linear" and "raid0" (as they are the only way to get 2T from 4x500G) 
> and both behave the same (sda has 512, md0 127, linear 127 and raid0 has 
> 512 kb block size).
> 
> I do not see the mechanism how 512:127 or 512:512 leads to 4 kb limit

Both raid0 and linear register a 'bvec_mergeable' function (or whatever it is
called today).
This allows for the fact that these devices have restrictions that cannot be
expressed simply with request sizes.  In particular they only handle requests
that don't cross a chunk boundary.

As raid1 never calls the bvec_mergeable function of it's components (it would
be very hard to get that to work reliably, maybe impossible), it treats any
device with a bvec_mergeable function as though the max_sectors were one page.
This is because the interface guarantees that a one page request will always
be handled.

> 
> Is it because:
>   - of rebuilding the array?
>   - of non-multiplicative max block size
>   - of non-multiplicative total device size
>   - of nesting?
>   - of some other fallback to 1 page?

The last I guess.

> 
> I ask because I can not believe that a pre-assembled nested stack would 
> result in 4kb max limit. But I haven't tried yet (e.g. from a live cd).

When people say "I can not believe" I always chuckle to myself.  You just
aren't trying hard enough.  There is adequate evidence that people can
believe whatever they want to believe :-)

> 
> The block device should not do this kind of "magic", unless the higher 
> layers support it. Which one has proper support then?
>   - standard partition table?
>   - LVM?
>   - filesystem drivers?
> 

I don't understand this question, sorry.

Yes, there is definitely something broken here.  Unfortunately fixing it is
non-trivial.

NeilBrown
