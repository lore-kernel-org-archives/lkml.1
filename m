Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYADRUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYADRUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 12:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYADRUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 12:20:11 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:54059 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbYADRUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 12:20:10 -0500
Date: Fri, 4 Jan 2008 18:19:49 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       olof@lixom.net
Subject: Re: [patch 2/2] Add the end-of-trace marker and the module list to
	WARN_ON()
Message-ID: <20080104171949.GA9178@osiris.ibm.com>
References: <477D5340.9090809@linux.intel.com> <20080104104818.GA8198@osiris.boeblingen.de.ibm.com> <477E47C2.3050700@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477E47C2.3050700@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 06:50:42AM -0800, Arjan van de Ven wrote:
> Heiko Carstens wrote:
>> On Thu, Jan 03, 2008 at 10:27:28PM +0100, Arjan van de Ven wrote:
>>> Another issue is that, unlike oopses, WARN_ON() doesn't currently printk
>>> the helpful "cut here" line, nor the "end of trace" marker.
>>> Now that WARN_ON() is out of line, the size increase due to this is
>>> minimal and it's worth adding.
>>>
>>> +static void print_oops_end_marker(void)
>>> +{
>>> +	init_oops_id();
>>> +	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
>>> +		(unsigned long long)oops_id);
>>> +}
>> There is also lib/bug.c which prints the "cut here" line but not the
>> "end of trace" line. 
>
> it ends up printing the "end of trace" line as part of the oops_exit() call

Not on architectures that implement WARN_ON() with the help of lib/bug.c and
an invalid opcode. Your out of line helper function doesn't get called there.

Instead the exception handler calls report_bug() which in turn prints the
warning message, then calls show_regs() and returns BUG_TRAP_TYPE_WARN.

Afterwards the instruction pointer is incremented and execution continues.

This is true for powerpc, avr32, sh, parisc and s390.

Your out of line changes don't have any effect on these architectures.
Dunno.. maybe you are aware of this. Just wanted to make sure we aren't
talking of totally different things.

>> Also it prints whatever it prints with a different
>> printk level.
>
> as it should.. WARN_ON()'s are warnings so get KERN_WARNING ;-)

Not on all architectures.. see above :)

>> Quite a few architectures use lib/bug.c also for WARN_ONs.
>
> is this still the case after Olof's patch?

Yes, of course. Also I like the WARN_ON() with exception semantics much more
since it gives the ability to print the register contents etc. So you get
much more debug informations.

>> Maybe all the code should be in one place so it doesn't diverge all the
>> time?
>
> it's actually ok as is.. the core tracing code lives in panic.c; lib/bug.c 
> is just a few helpers
> for BUG().. for WARN_ON() there is a lot less to help

Not really... lib/bug.c handles both if the architecture wants it. It just
needs to set BUGFLAG_WARNING in the bug table entries for warnings.
