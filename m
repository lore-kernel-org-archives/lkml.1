Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYAQVbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYAQVbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYAQVbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:31:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:57147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbYAQVbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:31:32 -0500
X-ExtLoop1: 1
Date: Thu, 17 Jan 2008 13:31:31 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Herrmann3 <andreas.herrmann3@amd.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Message-ID: <20080117213131.GA25389@linux-os.sc.intel.com>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117211308.GA7858@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 10:13:08PM +0100, Ingo Molnar wrote:
> but in general we must be robust enough in this case and just degrade 
> any overlapping page to UC (and emit a warning perhaps) - instead of 
> failing the ioremap and thus failing the driver (and the bootup).

But then, this will cause an attribute conflicit. Old one was specifying
WB in PAT (ioremap with noflags) and the new ioremap specifies UC.

As Linus mentioned, main problem is to figure out the correct attribute
for ioremap() which doesn't specify the actual attribute to be used.

One mechanism to fix the issue generically (somewhat atleast) is to use
MTRR's and figure out the default MTRR attribute for that physical address
and use it for ioremap().

> no, there should be no such need. There can be "mapping leaks", in that 
> the mapped object is not unmapped. There's detection code in today's 
> x86.git that should report something like this if it occurs:
> 
>   Debug warning: early ioremap leak of 1 areas detected.
>   please boot with early_ioremap_debug and report the dmesg.
>   ------------[ cut here ]------------
>   WARNING: at arch/x86/mm/ioremap_32.c:346 ()
> 
> but i have not seen this message in your boot log. Could you boot with 
> early_ioremap_debug and send us the dmesg - i'm curious which ACPI 
> tables are actively mapped while those devices are initialized.

In this scenario, ACPI is using ioremap() leaving some dangling references.
Venki is looking to fix this code. Getting the attribute for MTRR
for ioremap noflags, might solve some of these issues aswell. Will look into
this.

thanks,
suresh
