Return-Path: <linux-kernel-owner+w=401wt.eu-S1763252AbYHHXEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763252AbYHHXEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYHHXEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:04:44 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:37029 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYHHXEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:04:43 -0400
Message-ID: <489CD0F9.9060603@cs.columbia.edu>
Date: Fri, 08 Aug 2008 19:04:25 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
References: <20080807224033.FFB3A2C1@kernel> <200808081409.30591.arnd@arndb.de> <489CAC70.7090809@cs.columbia.edu> <200808090029.28286.arnd@arndb.de>
In-Reply-To: <200808090029.28286.arnd@arndb.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnd Bergmann wrote:
> On Friday 08 August 2008, Oren Laadan wrote:
> 
>>> It seems weird that you use __u64 members for the registers, but don't
>>> include r8..r15 in the list. As a consequence, this structure does not
>>> seem well suited for either x86-32 or x86-64.
>> In the context of CR, x86-32 and x86-64 are distinct architectures because
>> you cannot always migrate from one to the other (though 32->64 is sometimes
>> possible). Therefore, each architecture can have a separate checkpoint file
>> format (eg r8..r15 only for x86-64).
> 
> So why do you use __u64 members for your 32 bit registers?

The idea was that x86-32 checkpoints can be restarted on a x86-64 node in
32 bit mode. Clearly it needed more thought...

> 
>> Except for this special case (32 bit running 64 bit), simple conversion can
>> be done in the kernel if needed, but most conversion between kernel the
>> format for different kernel versions (should it change) can be done in
>> user space (eg. with a filter).
> 
> The 32bit on 64bit case is quite common on non-x86 architectures, e.g.
> powerpc or sparc, where 64 bit kernels typically run 32 bit user space.
> 
> A particularly interesting case is mixing 32 and 64 bit tasks in a container
> that you are checkpointing. This is a very realistic scenario, so there
> may be good arguments for keeping the format identical between the variations
> of each architecture.
> 
>>> I would suggest either using struct pt_regs by reference, or defining
>>> it so that you can use the same structure for both 32 and 64 bit x86.
>> We prefer not to use the kernel structure directly, but an intermediate
>> structure that can help mitigate subtle incompatibilities issues (between
>> kernel configurations, versions, and even compiler versions).
>>
>> Anyway, either a single structure for both 32 and 64 bit x86, or separate
>> "struct cr_hdr_cpu{_32,_64}", one for each architecture.
> 
> struct pt_regs is part of the kernel ABI, it will not change.

I'm in favor about keeping the format identical between the variations of
each architecture. Note, however, that "struct pt_regs" won't do because it
may change with these variations.

So we'll take care of the padding and add r8..r15 in the next version.

Oren.


