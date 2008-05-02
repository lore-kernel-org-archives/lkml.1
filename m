Return-Path: <linux-kernel-owner+w=401wt.eu-S935413AbYEBTeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935413AbYEBTeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758947AbYEBTd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:33:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36630 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbYEBTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:33:58 -0400
Message-ID: <481B6CA2.8080006@firstfloor.org>
Date: Fri, 02 May 2008 21:33:54 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 3/3] ia64: Call migration code on correctable errors v2
References: <20080502004425.GD12006@sgi.com> <87fxt0vbu4.fsf@basil.nowhere.org> <20080502185030.GH7246@sgi.com>
In-Reply-To: <20080502185030.GH7246@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Anderson wrote:
> On Fri, May 02, 2008 at 07:45:55PM +0200, Andi Kleen wrote:
>> Russ Anderson <rja@sgi.com> writes:
>>
>>> Migrate data off pages with correctable memory errors.  This patch is the 
>>> ia64 specific piece.  It connects the CPE handler to the page migration
>>> code.  It is implemented as a kernel loadable module, similar to the mca
>>> recovery code (mca_recovery.ko).  This allows the feature to be turned off
>>> by uninstalling the module.  Creates /proc/badram to display bad page
>>> information and free bad pages.
>> How do you know what pages have excessive errors? And how is excessive defined?
>> Surely you don't keep  a per page error count? It's unclear from your patch. 
> 
> The code migrates on the first correctable error on a page, so "excessive"
> is one.  Yes, keeping a per page count gets problematic, especially as
> memories get larger.  The issue of the right metric for when to migrate
> will always be debatable and the "right" answer likely will depend on
> the physical memory technology.

That doesn't sound like a good metric. What happens for example if you
have a flakey memory controller or DIMM socket that just occasionally
adds bit errors on transfer without the DIMM actually being bad? I doubt
such a simple heuristic is a good one.

The x86-64 machine check design has a database connected to a user space
program that can keep track of errors. I suspect something like this is
a better solution.

> 
>> Anyways I don't think this should be ia64 specific, but generic code.
> 
> The actual migration code is generic, in mm/migrate.c.
> 
> The ia64 kernel module piece is very arch specific.  It ties into the 
> ia64 CPE handler.  It gets the page address from the CPE record, based
> on the ia64 error handling spec.  Each arch will have a different way of
> determining the physical address of the correctable error (for example).

Still at least part of the code should be generic.

Also in general it's good that you finally realized that trying to write
lockless machine check handlers was a bad idea and that to do any
meaninful handling requires a proper process context. But I still wonder
when you move the rest of the ia64 machine check handling to that too so
that e.g. the sched.c hacks for lockless handling can be removed?


>> I also have my doubts about making such small code subsystems modules. Modules
>> always get rounded to pages so it ultimatively just wastes memory.
> 
> CONFIG_IA64_CPE_MIGRATE=m builds it as module.

It's far too small for it.

-Andi
