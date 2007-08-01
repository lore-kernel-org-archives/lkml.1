Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbXHAHYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbXHAHYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbXHAHY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:24:28 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:4540 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbXHAHY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:24:27 -0400
Message-ID: <46B03561.9090800@genesi-usa.com>
Date: Wed, 01 Aug 2007 08:25:21 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: Alan Curry <pacman@theworld.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
References: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com> <3a538bd3f5db759abb55a661e6e94c7a@kernel.crashing.org>
In-Reply-To: <3a538bd3f5db759abb55a661e6e94c7a@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah please do a fixup for the boot wrapper.

Or, if you have trouble, go into the firmware and type "nvedit", add
these lines;

" /isa/8042" find-device
" 8042" encode-string device-type

(then ctrl-c to exit and nvstore to run it on next reboot. Try it without
the patch first, on the firmware console, just to be sure I got it right,
because I can't test it here)

You don't need to patch Linux at all. In fact for silly things like this
I would recommend against it :)

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations




Segher Boessenkool wrote:
>> As of 2.6.22 the kernel doesn't recognize the i8042 keyboard/mouse 
>> controller
>> on the PegasosPPC. This is because of a feature/bug in the OF device 
>> tree:
>> the "device_type" attribute is an empty string instead of "8042" as the
>> kernel expects. This patch (against 2.6.22.1) adds a secondary 
>> detection
>> which looks for a device whose *name* is "8042" if there is no device 
>> whose
>> *type* is "8042".
>>
>> Signed-off-by: Alan Curry <pacman@world.std.com>
>>
>> --- arch/powerpc/kernel/setup-common.c.orig	2007-07-24 
>> 19:04:17.000000000 -0500
>> +++ arch/powerpc/kernel/setup-common.c	2007-07-24 19:06:36.000000000 
>> -0500
>> @@ -487,6 +487,10 @@ int check_legacy_ioport(unsigned long ba
>>  	switch(base_port) {
>>  	case I8042_DATA_REG:
>>  		np = of_find_node_by_type(NULL, "8042");
>> +		/* Pegasos has no device_type on its 8042 node, look for the
>> +		 * name instead */
>> +		if (!np)
>> +			np = of_find_node_by_name(NULL, "8042");
> 
> [I know it already got merged, I'm behind on mail, but anyway...]
> 
> Could board-specific quirks like this please always include a
> check for that board?  Or, even better, do a fixup in the
> bootwrapper.
> 
> In this case the workaround won't likely trigger on the wrong
> boards, but "just a little bit" more dangerous workarounds
> _will_, and the law of big numbers works against us...
> 
> 
> Segher
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
