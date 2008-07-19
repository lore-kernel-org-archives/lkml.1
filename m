Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYGSW1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYGSW1h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 18:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYGSW12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 18:27:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:58346 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYGSW11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 18:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nzzaUMqgybR8nJyiITdE6MV/xzpSYv3kYK4AZPPsSTEJ2CP0h2uXi8JS55sA/JCBya
         4q6JnG+9UAxfVacidDqdw0AZYfTvZLTke3wSuSRHoFPU+uuz90xMd2gKcyn6wrSDXt1D
         k0J6jUV6KU2LSiHdX3iiFl7ITkCnGCt+xxYdA=
Message-ID: <19f34abd0807191527u61c5ed61kffe2279c8d46915d@mail.gmail.com>
Date: Sun, 20 Jul 2008 00:27:26 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068 trace_hardirqs_on_caller
Cc: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Dave Hansen" <haveblue@us.ibm.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       kernel-testers@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <20080719221723.GB5578@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080718195352.e562a00f.sfr@canb.auug.org.au>
	 <200807190928.33978.m.kozlowski@tuxland.pl>
	 <19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com>
	 <19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com>
	 <20080719221723.GB5578@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 12:17 AM, Greg KH <gregkh@suse.de> wrote:
> On Sat, Jul 19, 2008 at 02:59:12PM +0200, Vegard Nossum wrote:
>> On Sat, Jul 19, 2008 at 11:55 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> > What I don't get here is how SLUB can be used this early in the boot
>> > process. Notice that this is still miles away from the
>> >
>> >    SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
>> >
>> > line, which comes much later. And that kobject_init() _is_ calling
>> > kzalloc() via verify_dynamic_kobject_allocation(). Isn't this an
>> > error?
>> >
>> > (Unfortunately, my "git log" doesn't turn up any recent changes for
>> > any of the affected code paths here.)
>>
>> Ehe... and this is the reason why: The code was added by this patch:
>>
>> commit 0e3638d1e04040121af00195f7e4628078246489
>> Author: Dave Hansen <haveblue@us.ibm.com>
>> Date:   Thu Mar 16 17:30:16 2006 -0800
>>
>>     warn when statically-allocated kobjects are used
>>
>> ..which only exists in -next. Is that just a truly ancient patch, or
>> did somebody forget to adjust their clock?
>
> It is truely a very old patch, that only lives in my tree, and currently
> isn't planned to go to Linus any year soon.
>
> But it has a very long history of living in the -mm tree, and finding
> real bugs, it's just not "safe" enough to go to Linus's tree.  Unless
> you think it is?

Hm. In this case, the patch is not even reporting a problem, it is in
fact in error itself.

The problem is that it calls kzalloc() before the slab caches have
been set up. (Yes, it's a wonder that nothing crashed.) I can only
suggest the addendum

    if (!slab_is_available())
        return;


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
