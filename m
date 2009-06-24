Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbZFXXsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbZFXXsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbZFXXsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:48:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755303AbZFXXsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:48:22 -0400
Date: Wed, 24 Jun 2009 16:44:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Gary Hade <garyhade@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
In-Reply-To: <4A42B7BC.2000402@lwfinger.net>
Message-ID: <alpine.LFD.2.01.0906241639030.3605@localhost.localdomain>
References: <1245845787.3093.3.camel@localhost.localdomain>  <20090624112849.55b38fff@jbarnes-g45>  <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain>  <20090624194839.GG7239@us.ibm.com> <4A4286F8.9020501@lwfinger.net> 
 <86802c440906241432l6d601f76sf2a413d6e19079e6@mail.gmail.com>  <4A429DAA.3010303@lwfinger.net>  <86802c440906241444g1aabcc5rb2d189dca0965e36@mail.gmail.com>  <4A42A2FD.1060401@lwfinger.net>  <86802c440906241511i3d534723u4dfdef9448b54bb9@mail.gmail.com>
 <86802c440906241553j11c84adm45ef6e6e8f1fe10e@mail.gmail.com> <4A42B7BC.2000402@lwfinger.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Larry Finger wrote:
> 
> From what I read in Linus's mails, it may be a moot point; however, my
> system boots with these 3, and only these 3, patches applied.

Well, it's definitely not moot. We want "use_crs" to work, whether it's 
the default or not. I just doubt it should be the default (necessarily 
ever).

The resources listed in the _CRS table may well be useful to make 
decisions on (minimally: "is this a root bridge", but possibly also 
scanning decisions). But I seriously doubt it makes any sense to insert 
the _CRS resources into the bus resource list. 

It might, for example, make sense to add them to the resource tree (after 
scanning), the same way we add the e820 resources to the resource tree. 

But judging from your dmesg:

	pci_bus 0000:00: resource 0 io:  [0x00-0xcf7]
	pci_bus 0000:00: resource 1 io:  [0xd00-0xffff]
	pci_bus 0000:00: resource 2 mem: [0x0a0000-0x0bffff]
	pci_bus 0000:00: resource 3 mem: [0x0c0000-0x0c3fff]
	pci_bus 0000:00: resource 4 mem: [0x0c4000-0x0c7fff]
	pci_bus 0000:00: resource 5 mem: [0x0c8000-0x0cbfff]
	pci_bus 0000:00: resource 6 mem: [0x0cc000-0x0cffff]
	pci_bus 0000:00: resource 7 mem: [0x0d4000-0x0d7fff]
	pci_bus 0000:00: resource 8 mem: [0x0d8000-0x0dbfff]
	pci_bus 0000:00: resource 9 mem: [0x0dc000-0x0dffff]
	pci_bus 0000:00: resource 10 mem: [0x0e0000-0x0e3fff]
	pci_bus 0000:00: resource 11 mem: [0x0e4000-0x0e7fff]
	pci_bus 0000:00: resource 12 mem: [0x0e8000-0x0ebfff]
	pci_bus 0000:00: resource 13 mem: [0x0ec000-0x0effff]
	pci_bus 0000:00: resource 14 mem: [0x0f0000-0x0fffff]
	pci_bus 0000:00: resource 15 mem: [0xc0000000-0xfebfffff]
	pci_bus 0000:01: resource 1 mem: [0xfc100000-0xfc1fffff]
	pci_bus 0000:01: resource 3 io:  [0x00-0xcf7]
	pci_bus 0000:01: resource 4 io:  [0xd00-0xffff]
	pci_bus 0000:01: resource 5 mem: [0x0a0000-0x0bffff]
	pci_bus 0000:01: resource 6 mem: [0x0c0000-0x0c3fff]
	pci_bus 0000:01: resource 7 mem: [0x0c4000-0x0c7fff]
	pci_bus 0000:01: resource 8 mem: [0x0c8000-0x0cbfff]
	pci_bus 0000:01: resource 9 mem: [0x0cc000-0x0cffff]
	pci_bus 0000:01: resource 10 mem: [0x0d4000-0x0d7fff]
	pci_bus 0000:01: resource 11 mem: [0x0d8000-0x0dbfff]
	pci_bus 0000:01: resource 12 mem: [0x0dc000-0x0dffff]
	pci_bus 0000:01: resource 13 mem: [0x0e0000-0x0e3fff]
	pci_bus 0000:01: resource 14 mem: [0x0e4000-0x0e7fff]
	pci_bus 0000:01: resource 15 mem: [0x0e8000-0x0ebfff]
	pci_bus 0000:01: resource 16 mem: [0x0ec000-0x0effff]
	pci_bus 0000:01: resource 17 mem: [0x0f0000-0x0fffff]
	pci_bus 0000:01: resource 18 mem: [0xc0000000-0xfebfffff]

none of those look in any way like sensible "resources" to be put in the 
device. Quite frankly, they look like total garbage to me.

			Linus
