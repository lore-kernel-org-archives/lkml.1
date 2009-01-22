Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbZAVXzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbZAVXzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZAVXzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:55:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbZAVXzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:55:39 -0500
Message-ID: <497906A4.2030008@zytor.com>
Date: Thu, 22 Jan 2009 15:52:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "jeremy@xensource.com" <jeremy@xensource.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
References: <20090120110542.GE19505@wotan.suse.de>	 <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu>	 <49763806.5090009@goop.org> <20090120205653.GA19710@elte.hu>	 <20090121072718.GN24891@wotan.suse.de>  <4977A051.8050203@goop.org>	 <1232663311.16317.176.camel@bodhitayantram.eng.vmware.com>	 <4978F6C6.3090003@goop.org>  <4978F7DC.1040503@zytor.com> <1232665120.16317.186.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1232665120.16317.186.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> On Thu, 2009-01-22 at 14:49 -0800, H. Peter Anvin wrote:
> 
>> There is also the option to use assembly wrappers to avoid relying on 
>> the calling convention.  This is particularly so since we have sites 
>> where as little as a two-byte instruction gets bloated up with huge 
>> push/pop sequences around a tiny instruction.  Those would be better 
>> served with a direct call to a stub (5 bytes), which would be repatched 
>> to the two-byte instruction + 3 byte nop.
> 
> Yes, for known trivial ops (most!), there isn't any reason to ever have
> a call to begin with; simply an inline instruction sequence would be
> fine, and only those callers that override the sequence would need to
> patch.  It's possible to write clever macros to assure there is always
> space for a 5 byte call.
> 

It's functionally speaking the same thing... the advantage with starting 
out with the call and then patch in the native code as opposed to the 
other way around is to be able to handle things properly before we're 
ready to run the patching code.

Right now a number of the call sites contain a huge push/pop sequence 
followed by an indirect call.  We can patch in the native code to avoid 
the branch overhead, but the register constraints and icache footprint 
is unchanged.

	-hpa

