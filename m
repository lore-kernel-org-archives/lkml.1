Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbYHGW6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbYHGW6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbYHGW6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:58:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54607 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbYHGW6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:58:33 -0400
Message-ID: <489B7DFE.5010402@kernel.org>
Date: Thu, 07 Aug 2008 15:58:06 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>  <489B6710.9000604@kernel.org>  <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>  <489B6A5C.8030400@kernel.org>  <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>  <489B6E83.7000202@kernel.org> <1218146154.20178.352.camel@bodhitayantram.eng.vmware.com> <489B7470.5030408@kernel.org> <alpine.LFD.1.10.0808071533100.3462@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808071533100.3462@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 7 Aug 2008, H. Peter Anvin wrote:
>> The only way I can see around that, though, is to move the 1:1 mapping base up
>> by 2/4 MB (for PAE/no PAE, respectively) and put the fixmap area there.  Kind
>> of sucks, but would be doable.
> 
> So if the address isn't fixed, you'll end up with an indirect pointer, and 
> it would likely be much better to just use a fixed direct pointer that is 
> not at the top.
> 
> And anything that is within the top 31 bits of the address space should 
> generate the same good code, since the fixed offset is always going to be 
> a 32-bit thing anyway. So moving the FIXMAP area down by 4MB sounds like a 
> fine thing to do with no real downside, if it then means that we don't 
> need to move the FIXMAP area at all.
> 
> Hmm? Am I missing something?

Just moving it down by 4 MB doesn't help, since the VMI guys want as 
much as 64 MB, which is half the standard vmalloc area and hence too 
much address space lost.  We can't put it at the bottom of the vmalloc 
area, since that boundary is not fixed, either.

The one remaining fixed boundary in the machine is the kernel-userspace 
boundary.  Hence moving the 1:1 area up by one PDE unit and sticking the 
fixmap area in that region.

	-hpa
