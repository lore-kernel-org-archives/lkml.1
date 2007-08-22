Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXHVUlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXHVUlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbXHVUlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:41:45 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:42863 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbXHVUlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:41:44 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=GBcVpbDTgPUe8IfrOlwWqXg6LGPq29ACDSVmhmnP8MSsJRMnYGyKnh77d/qQWfO6Fo++//L16mw8b074wFCwSrbMrfDvYZv/yn48Q1FmeTQl7LUaXAiun7rr3S9JQEIN;
X-IronPort-AV: E=Sophos;i="4.19,295,1183352400"; 
   d="scan'208";a="349001965"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
Date: Wed, 22 Aug 2007 15:41:38 -0500
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F9B18F45@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <alpine.LFD.0.999.0708221122180.30176@woody.linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
Thread-Index: Acfk7B3ZyfNnS7OwSR+nq1svOBa8jgAEDgbA
References: <46C098FD.1030601@googlemail.com> <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org> <alpine.LFD.0.999.0708202255130.30176@woody.linux-foundation.org> <200708202334.38261.david-b@pacbell.net> <alpine.LFD.0.999.0708202348460.30176@woody.linux-foundation.org> <alpine.LFD.0.999.0708210016420.30176@woody.linux-foundation.org> <alpine.LFD.0.999.0708212026200.30176@woody.linux-foundation.org> <DFEF91B22ED07447AB6AA4B237F913F9B18F2A@ausx3mpc125.aus.amer.dell.com> <alpine.LFD.0.999.0708221122180.30176@woody.linux-foundation.org>
From: <Stuart_Hayes@Dell.com>
To: <torvalds@linux-foundation.org>
Cc: <david-b@pacbell.net>, <michal.k.k.piotrowski@gmail.com>,
       <linux-usb-devel@lists.sourceforge.net>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <dex@dragonslave.de>
X-OriginalArrivalTime: 22 Aug 2007 20:41:42.0867 (UTC) FILETIME=[D91B1230:01C7E4FC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> That could definitely cause mouse lock-ups.  Sorry, that should have
>> occurred to me yesterday when you mentioned the problem your kids
>> were seeing, but it didn't for some reason.
> 
> Btw, could it have caused the USB stack to be *really* confused? Some
> of those mouse lockups ended up also locking the machine hard (ie no
> ping, no nothing), and I'm a bit worried that there was something
> else going on too..   
> 

Unfortunately, yes, that sounds exactly like what happened with the
nVidia controller.  The problem was with my patch, but was fixed with
the later patch.  I doubt there was anything else going on.

> That said, if you can actually re-create the MMF problems, could you
> please try the patch that Arjan suggested? Ie add a 
> 
> 	/*
> 	 * Some broadcom chips are buggy and can't take more than 5 usec
as
> DMA 
> 	 * latency; inform the rest of kernel of this.
> 	 */
> 	if (weird_broadcom_chip())
> 		set_acceptable_latency("ehci", 5);
> 
> to the USB driver, and then add something like
> 
> 	static inline int cpufreq_acceptable_latency(struct
cpufreq_policy
> 	*policy) {
> 		unsigned long latency;
> 
> 		/* Policy latency in usec */
> 		latency = policy->cpuinfo.transition_latency / 1000;
> 
> 		if (latency > system_latency_constraint())
> 			return -EINVAL;
> 
> 		return 0;
> 	}
> 
> adn then add calls to this from both the "__cpufreq_set_policy()"
> function and the "__cpufreq_driver_target()" one too.. 
> 
> That should disable cpufreq with that broken chip, which is perhaps a
> big draconian, but it's certainly better than having the USB layer
> know about cpufreq internals directly.  
> 
> In the longer run, I think we can move the
> "system_latency_constraint()" 
> checking from the policy registration into each CPU frequency driver,
> so that it could be more dynamically decide about "can we do it right
> _now_"  
> rather than globally saying "we can't do it with this hardware".
> 
> 				Linus

I will work on that, thank you for the help.

Stuart
