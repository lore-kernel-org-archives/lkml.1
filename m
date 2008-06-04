Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbYFDAD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbYFDAD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYFDADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:03:18 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:37116 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYFDADR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:03:17 -0400
Message-ID: <4845DBBA.9010607@keyaccess.nl>
Date: Wed, 04 Jun 2008 02:03:06 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 15/15] PNP: convert resource options to single linked
 list
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224934.357694359@ldl.fc.hp.com> <4845A217.3030701@keyaccess.nl> <200806031703.48648.bjorn.helgaas@hp.com>
In-Reply-To: <200806031703.48648.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-06-08 01:03, Bjorn Helgaas wrote:

> That's definitely backwards.  I reversed the sizes, so we'll have
> 8 bits for the priority byte (including compatibility/performance/
> robustness) and 16 bits for the dependent set number.  Actually,
> I made the priority field 12 bits so we'd have space to keep
> PNP_RES_PRIORITY_INVALID as a truly out-of-band value.

Sounds perfect.

>>> +	for (i = 0; i == 0 || i < dev->num_dependent_sets; i++) {
>>> +		ret = pnp_assign_resources(dev, i);
>>> +		if (ret == 0)
>>>  			return 0;
>> Eeeew. Perhaps:
>>
>> i = 0;
>> do {
>> 	ret = pnp_assign_resources(dev, i);
>> 	if (ret == 0)
>> 		return 0;
>> } while (++i < dev->num_dependent_sets);
> 
> Heh :-)  I vacillated on that one because I have a personal aversion
> to "do { ... } while ()", especially with a pre-increment.  How would
> you feel about this alternative?
> 
>         ret = pnp_assign_resources(dev, 0);
>         if (ret == 0)
>                 return 0;
> 
>         for (i = 1; i < dev->num_dependent_sets; i++) {
>                 ret = pnp_assign_resources(dev, i);
>                 if (ret == 0)
>                         return 0;
>         }

You could fix the pre-increment by sticking a i++ inside the loop body 
but there's no arguing with personal aversions...

Yes, I think the latter is better. Straight-forward and clear.

>> Why do you do 0x800, 0x400 in that order? Shouldn't it just be 0x400, 
>> 0x800 to mimick the old order?
> 
> I think they do end up in the correct order because I'm passing the
> same list_head to both list_add() calls, e.g., we'll have something
> like this:
> 
>     io -> ...
>     io -> (io + 0x800) -> ...
>     io -> (io + 0x400) -> (io + 0x800) -> ...

Yep. Just needed to see it happen once in the quirk testing I just now did.

> I need to go back over all your comments and make sure I've addressed
> them all, then I'll post the revised patches, hopefully tomorrow.
> 
> Thanks again for all your work reviewing and testing these.  It's
> been incredibly useful.

I've been impressed by this work. This is a good redesign of PnP with a 
fully bisectable way to get there. And PnP was in need of some work...

Rene.
