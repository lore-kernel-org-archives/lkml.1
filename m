Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbYBLXyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbYBLXyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbYBLXyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:54:14 -0500
Received: from zeus.pimb.org ([80.68.88.21]:1430 "EHLO zeus.pimb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757593AbYBLXyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:54:13 -0500
X-Greylist: delayed 980 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2008 18:54:13 EST
Date: Tue, 12 Feb 2008 23:54:04 +0000
From: Jody Belka <lists-lkml@pimb.org>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Ian Campbell <ijc@hellion.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: 2.6.25-rc1 xen pvops regression
Message-ID: <20080212235404.GY7980@pimb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I thought I'd try out 2.6.25-rc1 as a xen 32-bit pae domU the other day.
Unfortunately, I didn't get very far very fast, as the domain just crashed
immediately upon booting, without any direct feedback (I did have messages
on the xen message buffer, which helped). This even with earlyprintk turned on.

After a long, arduous journey, I managed to track this down to the following:

----------
commit	551889a6e2a24a9c06fd453ea03b57b7746ffdc0

x86: construct 32-bit boot time page tables in native format.

Specifically the boot time page tables in a CONFIG_X86_PAE=y enabled
kernel are in PAE format.

early_ioremap is updated to use the standard page table accessors.

Clear any mappings beyond max_low_pfn from the boot page tables in
native_pagetable_setup_start because the initial mappings can extend
beyond the range of physical memory and into the vmalloc area.

Derived from patches by Eric Biederman and H. Peter Anvin.

[ jeremy@goop.org: PAE swapper_pg_dir needs to be page-sized fix ]
----------

However, to make life more interesting, just reverting this isn't quite
enough to get us to the promised land. If we try, we find that although
we do now start booting, we crash again a short way into the process.

In a different manner though. Specifically, in early_ioremap_clear.
Reverting the above commit /except/ for the changes to arch/x86/mm/ioremap.c
gets everything working again.

Well, except that we can't shutdown/reboot properly, but I've sent a patch
for that in another email.


I'm afraid i've no idea what needs to be done to get the change to work
with xen, but i'm willing to try out any patches people come up with.
Please cc me on any replies, as i'm not subscribed, thanks.


J
-- 
Jody Belka
knew (at) pimb (dot) org
