Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbYGOQBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbYGOQBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYGOQBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:01:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753149AbYGOQBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:01:44 -0400
Date: Tue, 15 Jul 2008 09:01:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: david@lang.hm
cc: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.DEB.1.10.0807150759020.6370@asgard>
Message-ID: <alpine.LFD.1.10.0807150843580.3017@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <20080714.194032.117461306.davem@davemloft.net> <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org>
 <20080715045848.GG1369@1wt.eu> <alpine.LFD.1.10.0807150747540.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807150759020.6370@asgard>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, david@lang.hm wrote:
> 
> has a standard been defined for how to maintain different versions of firmware
> for different versions of drivers yet?

No. We haven't had that possibility, probably largely because we haven't 
even really had the ability (Davem and Jeff talk about "choice" and how 
request_firmware() supposedly removes it, but they ignore the fact that it 
very much cuts the other way too - request_firmware() _adds_ choice and 
makes it easier for people to try to upgrade firmware without upgrading 
the kernel).

> that was one of the things that was identified in the last flamewar that was
> handwaved away but nothing was defined.

I don't think we can - or want to - define things until we've seen the 
problems and advantages in practice over a longer time.

Do we want a versioning scheme? Probably not - exactly because people may 
well want to update (or downgrade) firmware from vendors independently of 
the kernel.

But maybe people will eventually want some kind of blacklisting scheme 
where the driver can say things like "I know I won't work with versions 
that match this checksum" and cause a nice big warning at load-time.

And I think we can all _imagine_ scenarios in all kinds of possible ways 
for things to work better or fail spectaclarly, and even come up with 
anecdotal evidence where scheme X (out of any number of random variations) 
is the "only possible one to work". I'd argue that we simply don't have 
any realistic way to decide which ones make sense.

For example, we can be in the situation where we have some case where
"only this particular firmware is known to work, and others are known to 
break", and people can still take two totally different mental approaches 
to the problem.

One approach is the "strict control one", where people argue that the 
above problem means that we absolutely *must* have very strict versioning, 
and we just always pair things up exactly.

But the other argument is that firmware is part of hardware, and the 
driver should strive to work with different versions of vendor firmware, 
the same way it should strive to work with different versions of chip 
hardware.

Which one is right?  Probably neither. Sometimes one, sometimes the other, 
and in both cases it should probably not be black-and-white.

IOW, I suspect that in the long run we want to say

  "Ok, there's no way we can support _all_ firmware versions, but on the 
   other hand, we also don't want to force particular versions and not let 
   people experiment.

   So drivers should strive to be flexible, and driver writers should not 
   always just say 'there is only one "blessed" firmware', but on the 
   other hand we cannot require drivers to work around horrible known bugs 
   in firmware when a fixed firmware is available"

but the exact details will have to depend on particular drivers.

And we should obviously have _a_ version of the firmware available with 
the kernel when that is possible. But I'd hate for it to be 1:1 with a 
particular driver version - because at that point it smells of being a 
single work, and if it is more than mere aggregation it's no longer viable 
with most of our firmware (I don't think we have source for more than one 
or two cases).

			Linus
