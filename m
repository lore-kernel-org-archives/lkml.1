Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbZE2N7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbZE2N7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759280AbZE2N6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:58:55 -0400
Received: from smtp.nokia.com ([192.100.122.233]:16849 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbZE2N6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:58:54 -0400
Message-ID: <4A1FE9F2.1050904@nokia.com>
Date: Fri, 29 May 2009 16:58:10 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/2] UBIFS: start using hrtimers
References: <20090529150929.8912.33879.sendpatchset@localhost.localdomain>	 <20090529150944.8912.95076.sendpatchset@localhost.localdomain> <1243603957.23657.217.camel@twins>
In-Reply-To: <1243603957.23657.217.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 May 2009 13:58:16.0316 (UTC) FILETIME=[83BB03C0:01C9E065]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2009-05-29 at 18:09 +0300, Artem Bityutskiy wrote:
>> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>> Subject: [PATCH 2/2] UBIFS: start using hrtimers
>>
>> UBIFS uses timers for write-buffer write-back. It is not
>> crucial for us to write-back exactly on time. We are fine
>> to write-back a little earlier or later. And this means
>> we may optimize UBIFS timer so that it could be groped
>> with a close timer event, so that the CPU would not be
>> waken up just to do the write back. This is optimization
>> to lessen power consumption, which is important in
>> embedded devices UBIFS is used for.
>>
>> hrtimers have a nice feature: they are effectively range
>> timers, and we may defind the soft and hard limits for
>> it. Standard timers do not have these feature. They may
>> only be made deferrable, but this means there is effectively
>> no hard limit. So, we will better use hrtimers.
>>
>> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>> ---
> 
> Seems sane enough from a hrtimer POV, but isn't this already
> functionality that the VFS/pdflush provide?

Yeah, VFS/pdflush takes care of the page-cache and inode cache,
and dirty superblocks. But additionally to this UBIFS has its
own small buffer of (usually) 2KiB size, we call it write-buffer.
This is a very important optimization for NAND flash. And we
have a separate timer to synchronize this small write-buffer.

I was also thinking to hook to VFS, which would mean creating
a fake inode representing our write-bufffer. But this would be
very hacky.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
