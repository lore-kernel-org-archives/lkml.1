Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZIEVoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZIEVoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 17:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbZIEVn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 17:43:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZIEVn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 17:43:57 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Mark Lord" <lkml@rtr.ca>
Date: Sun, 6 Sep 2009 07:43:41 +1000 (EST)
Message-ID: <bfda833fe08ee0e8e1d6583cab1d00fc.squirrel@neil.brown.name>
In-Reply-To: <4AA26055.2090400@rtr.ca>
References: <20090828064449.GA27528@elf.ucw.cz>
    <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>
    <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>
    <4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>
    <20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>
    <20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>
    <20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com>
    <m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com>
    <m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com>
    <m3ab1cnn7y.fsf@intrepid.localdomain> <4A9FCF6B.1080704@redhat.com>
    <4AA184D7.1010502@rtr.ca> <4AA186B0.5090905@redhat.com>
    <4AA26055.2090400@rtr.ca>
Subject: Re: wishful thinking about atomic,
      multi-sector or full MD stripe width, writes in storage
Cc: "Ric Wheeler" <rwheeler@redhat.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Michael Tokarev" <mjt@tls.msk.ru>, david@lang.hm,
       "Pavel Machek" <pavel@ucw.cz>, "Theodore Tso" <tytso@mit.edu>,
       "Rob Landley" <rob@landley.net>, "Florian Weimer" <fweimer@bfk.de>,
       "Goswin von Brederlow" <goswin-v-b@web.de>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, September 5, 2009 10:57 pm, Mark Lord wrote:
> Ric Wheeler wrote:
>> On 09/04/2009 05:21 PM, Mark Lord wrote:
> ..
>>> How about instead, *fixing* the MD layer to properly support barriers?
>>> That would be far more useful, productive, and better for end-users.
> ..
>> Fixing MD would be great - not sure that it would end up still faster
>> (look at md1 devices with working barriers with compared to md1 with
>> write cache disabled).
> ..
>
> There's no inherent reason for it to be slower, except possibly
> drives with b0rked FUA support.
>
> So the first step is to fix MD to pass barriers to the LLDs
> for most/all RAID types.

Having MD "pass barriers" to LLDs isn't really very useful.
The barrier need to act with respect to all addresses of the device,
and once you pass it down, it can only act with respect to addresses
on that device.
What any striping RAID level needs to do when it sees a barrier
is:
   suspend all future writes
   drain and flush all queues
   submit the barrier write
   drain and flush all queues
   unsuspend writes

I guess "drain can flush all queues" can be done with an empty barrier
so maybe that is exactly what you meant.

The double flush which (I think) is required by the barrier semantic
is unfortunate.  I wonder if it would actually make things slower than
necessary.

NeilBrown

>
> Then, if it has performance issues, those can be addressed
> by more application of little grey cells.  :)
>
> Cheers
>

