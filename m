Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbZJSMAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbZJSMAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZJSMAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:00:19 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:57072 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbZJSMAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:00:18 -0400
Subject: Re: Leaks in trace reported by kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <c4e36d110910190215j129e61ey5e20634a4bc19292@mail.gmail.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <4AD6EF65.6080602@cn.fujitsu.com>
	 <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
	 <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
	 <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
	 <c4e36d110910160728n5ceefaa8u6b9989aec0564628@mail.gmail.com>
	 <c4e36d110910160807i2298dacp7d37289ca3ad25f@mail.gmail.com>
	 <1255711285.3008.59.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910190215j129e61ey5e20634a4bc19292@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 19 Oct 2009 13:00:05 +0100
Message-Id: <1255953605.31096.26.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 12:00:06.0496 (UTC) FILETIME=[B2F09600:01CA50B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 11:15 +0200, Zdenek Kabelac wrote:
> 2009/10/16 Catalin Marinas <catalin.marinas@arm.com>:
> > On Fri, 2009-10-16 at 17:07 +0200, Zdenek Kabelac wrote:
> >> So I've tested this modified version and it gives much better result
> >> with respect to amount of leaked objects
> >
> > BTW, I created this tree with kmemleak patches to be pushed upstream:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/kmemleak.git
> >
> > It would be easier to test.
> 
> Yes this branch worked well - and there were no leaks  from i915 or
> kvm modules for trace.
> 
> What is however interesting is the false positive leak for
> dma_debug_init(). Which is sometimes listed and sometimes not - the
> memory is allocated just once in the code during boot, so it's strange
> that pointers to that area are sometimes out of kmemleak scan.

I updated the tree above with another patch which lists where an object
is referred from. So when you get a leak reported and it later
disappears, you can use:

echo dump=0x... > /sys/kernel/debug/kmemleak

and in syslog you can find information about the previously reported
object and where it is referred from (if it is no longer reported as a
leak). I'm not sure whether this option would be useful for anything
other than debugging kmemleak. I still aim on getting to near 0 false
positives.

Anyway, trying this new patch on the debug_objects, when no longer
reported they are referred from obj_hash. My opinion is that they were
moved to obj_hash during the kmemleak scanning but after kmemleak
finished scanning the data section, hence they couldn't be found.

I hoped that not reporting object allocated within the last 5s would
avoid such problems but there are places like debug_objects for which it
doesn't work as the objects were reported earlier.

A workaround I had in the past was to not report an object unless it was
found as a leak in two consecutive scans. I should probably reinstate
this feature (could be optimised to use a second prio_tree containing
only objects found as leaks).

-- 
Catalin

