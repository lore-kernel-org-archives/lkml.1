Return-Path: <linux-kernel-owner+w=401wt.eu-S1031294AbXEDQRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031294AbXEDQRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031341AbXEDQRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:17:03 -0400
Received: from blaster.systems.pipex.net ([62.241.163.7]:33705 "EHLO
	blaster.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031294AbXEDQRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:17:00 -0400
X-Greylist: delayed 1139 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 12:17:00 EDT
Message-ID: <463B5803.6050802@tungstengraphics.com>
Date: Fri, 04 May 2007 16:57:55 +0100
From: Keith Whitwell <keith@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
Cc: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@gmail.com>
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>	<1178137279.53297.114.camel@vonnegut>	<46391860.3070409@tungstengraphics.com>	<1178251621.27028.9.camel@neko.keithp.com>	<463AE9AE.7070806@tungstengraphics.com> <1178291702.27028.30.camel@neko.keithp.com>
In-Reply-To: <1178291702.27028.30.camel@neko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard wrote:

>> OTOH, letting DRM resolve the deadlock by unmapping and remapping shared 
>> buffers in the correct order might not be the best one either. It will 
>> certainly mean some CPU overhead and what if we have to do the same with 
>> buffer validation? (Yes for some operations with thousands and thousands 
>> of relocations, the user space validation might need to stay).
> 
> I do not want to do relocations in user space. I don't see why doing
> thousands of these requires moving this operation out of the kernel.

Agreed.  The original conception for this was to have valdiation plus 
relocations be a single operation, and by implication in the kernel. 
Although the code as it stands doesn't do this, I think that should 
still be the approach.

The issue with thousands of relocations from my point of view isn't a 
problem - that's just a matter of getting appropriate data structures in 
place.

Where things get a bit more interesting is with hardware where you are 
required to submit a whole scene's worth of rendering before the 
hardware will kick off, and with the expectation that the texture 
placement will remain unchanged throughout the scene.  This is a very 
easy way to hit any upper limit on texture memory - the agp aperture 
size in the case of integrated chipsets.

That's a special case of a the general problem of what do you do when a 
client submits any validation list that can't be satisfied.  Failing to 
render isn't really an option, either the client or the memory manager 
has to either prevent it happening in the first place or have some 
mechanism for chopping up the dma buffer into segments which are 
satisfiable...  Neither of which I can see an absolutely reliable way to 
do.

I think that any memory manager we can propose will have flaws of some 
sort - either it is prone to failures that aren't really allowed by the 
API, is excessively complex or somewhat pessimistic.  We've chosen a 
design that is simple, optimistic, but can potentially say "no" 
unexpectedly.  It would then be up to the client to somehow pick up the 
pieces & potentially submit a smaller list.  So far we just haven't 
touched on how that might work.

The way to get around this is to mandate that hardware supports paged 
virtual memory...  But that seems to be a difficult trick.

Keith
