Return-Path: <linux-kernel-owner+w=401wt.eu-S1030200AbXCAUbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200AbXCAUbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 15:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030206AbXCAUbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 15:31:35 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49757 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030200AbXCAUbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 15:31:34 -0500
Message-ID: <45E73825.30800@vmware.com>
Date: Thu, 01 Mar 2007 12:31:33 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug in on_each_cpu?
References: <45E6AC1A.8050608@vmware.com>	<20070301024524.c7c8ea1a.akpm@linux-foundation.org>	<45E6BA3A.2040306@vmware.com>	<1172749278.10271.43.camel@localhost.localdomain>	<45E6BD5B.4030305@vmware.com> <20070301072225.9f00c36c.akpm@linux-foundation.org>
In-Reply-To: <20070301072225.9f00c36c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> The handler for smp_call_function() is called with local interrupts
> disabled (from the IPI handler).
>
> So to provide a consistent call environment for that handler, on_each_cpu()
> will also disable local interrupts when making the direct call on this CPU.
>
> Similarly the !CONFIG_SMP version of on_each_cpu() disables local
> interrupts when running the caller's function.
>   

Yes, that is sensible.  Something akin to on_each_cpu(synchronize_tscs) 
would certainly not like interrupts coming in.  Similarly, acpi_nmi 
disable and probably rcu barriers as well.  The irq disable here can 
very validly be used as a barrier, but trying to ensure preserved shared 
state with irq handlers over the call is a bug.

If one had all the spare time in the world, a new "sense" of irq disable 
that communicated this fact would be nice from a static or dynamic 
checking perspective.

Zach

------
sutra I.1 - atha linushasaanam
