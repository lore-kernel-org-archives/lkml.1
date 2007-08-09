Return-Path: <linux-kernel-owner+w=401wt.eu-S939574AbXHIQBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939574AbXHIQBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758718AbXHIQBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:01:15 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:36027 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935188AbXHIQBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:01:14 -0400
Message-ID: <46BB3692.5010003@vmware.com>
Date: Thu, 09 Aug 2007 08:45:22 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>, lguest <lguest@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Lguest] [PATCH] lguest: Fix Malicious Guest GDT Host Crash
References: <1186657033.17752.58.camel@localhost.localdomain>
In-Reply-To: <1186657033.17752.58.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> If a Guest makes hypercall which sets a GDT entry to not present, we
> currently set any segment registers using that GDT entry to 0.
> Unfortunately, this is not sufficient: there are other ways of
> altering GDT entries which will cause a fault.
>
> The correct solution to do what Linux does: let them set any GDT value
> they want and handle the #GP when popping causes a fault.  This has
> the added benefit of making our Switcher slightly more robust in the
> case of any other bugs which cause it to fault.
>
> We kill the Guest if it causes a fault in the Switcher: it's the
> Guest's responsibility to make sure it's not using segments when it
> changes them.
>   

Linux doesn't obey that rule.  It changes descriptors behind FS/GS all 
over the place.  Well, not all over the place, only when updating LDT 
entries, TLS entries, and during context switch.  This means lguest 
handling interrupts in one of those regions can result in the guest dying.

Zach
