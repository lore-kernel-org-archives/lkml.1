Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbXBJOnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbXBJOnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 09:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932435AbXBJOnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 09:43:19 -0500
Received: from mail.suse.de ([195.135.220.2]:33189 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422AbXBJOnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 09:43:18 -0500
From: Andi Kleen <ak@suse.de>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: -mm merge plans for 2.6.21
Date: Sat, 10 Feb 2007 15:43:14 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <p73ps8igo0v.fsf@bingen.suse.de> <20070210134853.5ab6c211@localhost.localdomain>
In-Reply-To: <20070210134853.5ab6c211@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101543.14937.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 14:48, Alan wrote:
> > Well it's a technical issue -- it conflicts with the machine check
> > code that is already implemented by stealing away its events.
> > You would first need a CONFIG_MCE=n on x86-64 at least, otherwise
> > one of them will be unhappy.
> 
> That is a fair point, albeit after far too long sitting stuck in the tree.

I'm pretty sure I mentioned it earlier already.

> I'll have a look into this a bit further, probably MCE_K8 should feed off
> the output of the MCE driver.

You could probably write a simple edac driver that just feeds of the events 
mce.c generates and presents that as the EDAC drivers. Currently 
the user space device is the only consumer, but it wouldn't be hard
to full it off to other kernel users.

Possibly keeping the existing code that reads the DIMMs and 
then reads the address map of the NB and match that, then you
get the same output.

[However see below -- i think matching it to SMBIOS using the address
is a lot more useful for the user in the end]

> 
> > The other issue is that the existing code does everything EDAC
> > K8 does already perfectly fine, just in a small fraction of 
> > the code.
> 
> Which is false. It provided a totally inconsistent interface to user
> space, while the EDAC layer provides the consistency many people need and
> want.

I still don't get that argument because unlike mce.c+mcelog EDAC cannot
actually tell you where the DIMM that failed is located on your motherboard.

As far as i can make it out it's only useful for people who either
have full schematics of their motherboard and know how to read them
or did a full try'n'error of all combinations run once to 
figure out which channel is located where.

Somehow I cannot imagine either of that is very common in "enterprises" ;-)

Ok one argument was that some LinuxBIOS users don't seem to 
set up these tables and have the necessary information at hand
for their custom cluster hardware, but that's still a weird uncommon 
case and it would be far better if they just fixed LB.

> Also unless it has changed remarkably the MCE driver doesn't do 
> scrubbing which is needed in software on some chip revisions.

True, adding that might be a good idea.

[Although I guess that could be done with a small user utility
using /dev/mem though if you really wanted it?]

One thing EDAC also does that mcelog doesn't is decode the ECC 
syndromes -- but I haven't figured out a use case yet where that
is actually useful to know afterwards.

-Andi
