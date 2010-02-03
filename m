Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0BCUSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:18:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43946 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757870Ab0BCUSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:18:30 -0500
Message-ID: <4B69D6BA.4030704@zytor.com>
Date: Wed, 03 Feb 2010 12:04:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: arnd@arndb.de, hch@lst.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       tony.luck@intel.com, ralf@linux-mips.org, kyle@mcmartin.ca,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@redhat.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 4/6] improve sys_personality for compat architectures
References: <201002021536.51928.arnd@arndb.de>	<20100202163145.GA30659@lst.de>	<201002031806.27423.arnd@arndb.de> <20100203.091309.52886984.davem@davemloft.net>
In-Reply-To: <20100203.091309.52886984.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 09:13 AM, David Miller wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Wed, 3 Feb 2010 18:06:27 +0100
> 
>>> But if the consensus is that we should fix this properly I can
>>> replace the patch with one introducing a compat_sys_personality
>>> which only gets used for compat tasks.
>>
>> Right now, sparc64 and powerpc64 use sys32_personality for both native
>> and compat tasks, x86 never uses it and all others use it only for
>> compat tasks. That seems more sensible if we keep this function at
>> all.
> 
> If it only gets used for compat tasks, you can only switch in
> one direction.  I think it needs to be handled for both compat
> and non-compat tasks, in order to allow for that.

That seems odd... with the wrapper you can ever only switch in one
direction, and if you use it for non-compat tasks you wouldn't be ever
to switch back, period.

> That's why powerpc64 and sparc64 do things the way they do,
> I am pretty sure.

As far as I can tell, the ppc64 and sparc64 implementations would seem
to be trapdoors from which no return is possible.  That's a pretty
defensible position in some ways -- it mimics the 32-bit machine even
down to the personality() syscall -- but it definitely has disadvantages.

The x86 method of simply not bothering doesn't seem to have caused
problems -- our compat (and noncompat) tasks happily return PER_LINUX32
if that is the mode and we don't seem to have had complaints with it.
If userspace ever had an issue with it -- and they might have, at one
point in history libc used to call personality() during startup, which
it doesn't seem to anymore -- they presumably have worked through it.

As such, I'm more than a little reluctant to change the current behavior.

	-hpa
