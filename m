Return-Path: <linux-kernel-owner+w=401wt.eu-S937234AbYEVAKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937234AbYEVAKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbYEVAKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:10:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759084AbYEVAKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:10:04 -0400
Message-ID: <4834B8DB.6030504@zytor.com>
Date: Wed, 21 May 2008 17:05:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <20080513011030.GA31448@linux-os.sc.intel.com>	<18477.35703.679574.760417@harpo.it.uu.se>	<20080518013416.GB30034@linux-os.sc.intel.com>	<18481.37905.297556.288317@harpo.it.uu.se>	<20080520015723.GD30034@linux-os.sc.intel.com>	<4832A173.6020203@firstfloor.org>	<4832E672.3090702@zytor.com>	<4832E85B.4080303@firstfloor.org> <20080520201044.ED62B26FA1C@magilla.localdomain>
In-Reply-To: <20080520201044.ED62B26FA1C@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> I don't think there is one. We never copy fxsave completely out of the
>> kernel. x86-64 does FXSAVE directly in/out user space, but the
>> only leak is what there was before.
> 
> ptrace/user_regset copies out and in the whole fxsave block from the ptrace
> caller.  (Only the mxcsr word is constrained after copy-in.)

I see two problems with that:

1. potential information leak out of the kernel if the memory area isn't 
zeroed before the first FXSAVE - I haven't verified if so is the case. 
This would be a (potentially very serious) security hole.

2. Hidden state in the kernel - this means user space can set 
nonarchitectural state in the kernel.  There are a few risks with that:

    a. Malware might use it to hide state.
    b. The possibility of using the stability or lack thereof of this
       state to extract information about kernel internals and/or
       provide a covert channel in the presence of hardware changes.
    c. It is not certain that future architectures will not have
       off-limit fields here, like the equivalent of MXCSR.  This is
       somewhat of a tricky judgement, of course, but it seems safer
       to me if we would explicitly list the modifiable fields.

Thoughts?

	-hpa

