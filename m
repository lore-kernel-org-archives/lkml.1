Return-Path: <linux-kernel-owner+w=401wt.eu-S1767770AbXECT2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767770AbXECT2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767775AbXECT2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:28:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767770AbXECT2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:28:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=HEjvROtdaQor/0r1vMOV5gFaYAWoqM/J5hsJRv/4vy70cCkw1aBwmORWMq8qEZoOI
	JKfUw6eNNp5uRobz8AwPA==
Date: Thu, 3 May 2007 12:24:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Adrian Bunk <bunk@stusta.de>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
In-Reply-To: <20070503190522.GM3531@stusta.de>
Message-ID: <Pine.LNX.4.64.0705031213510.2813@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
 <1178087393.28659.238.camel@localhost.localdomain>
 <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com>
 <1178089444.28659.246.camel@localhost.localdomain>
 <Pine.LNX.4.64.0705020020420.22717@chino.kir.corp.google.com>
 <20070502145550.GE3531@stusta.de> <20070502150546.GF3531@stusta.de>
 <Pine.LNX.4.64.0705021014070.3033@chino.kir.corp.google.com>
 <20070503175125.GL3531@stusta.de> <Pine.LNX.4.64.0705031154310.2312@chino.kir.corp.google.com>
 <20070503190522.GM3531@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Adrian Bunk wrote:

> > static external variables are certainly still static code and gcc issues 
> > the proper warnings if I do:
> > 
> > 	static struct bootnode nodes[MAX_NUMNODES];
> > 
> > and I never reference nodes.
> 
> No disagreement.
> 
> But you said:
>   What about automatic or static external variables that are declared but ...
> 

Ahh, I see the problem.  I was talking about "automatic variables" and 
"static external variables" implicitly, both of which emit compiler 
warnings if they are unreferenced as we saw in the arch/i386/pci/init.c 
case and the example above, respectively.

The only advantage this gives us as opposed to just removing an 
unreferenced variable completely is the case when its usage depends on 
multiple preprocessor macros.  Like in the arch/i386/pci/init.c example, 
the use of 'type' depends on CONFIG_PCI_DIRECT or CONFIG_PCI_MMCONFIG.  It 
gets sloppy pretty quickly when we're adding

	#if defined(CONFIG_PCI_DIRECT) || defined(CONFIG_PCI_MMCONFIG)

around the variable declarations.  Unfortunately we still have the 
drawback of perhaps leaving abandoned declarations in the code but now 
there will be an easy way to detect it: defining __maybe_unused and __used 
to be empty.  Then we won't have hardcoded __attribute__ ((unused)) text 
sprinkled around the tree that would require examination on an individual 
basis.

		David
