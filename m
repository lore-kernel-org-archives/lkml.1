Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbXFQVtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbXFQVtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbXFQVtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:49:09 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:22946 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756089AbXFQVtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:49:07 -0400
Date: Sun, 17 Jun 2007 23:49:05 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Cc: lethal@linux-sh.org, y-goto@jp.fujitsu.com, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070617214905.GA6207@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
	y-goto@jp.fujitsu.com, torvalds@linux-foundation.org
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617195805.GA6125@alinoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Because I CC new people, let me summarize:

2.6.18 works fine. Most kernels after that print
"agpgart: Detected an Intel 965G Chipset."
and then either hang (I have to hard reset them), hard
reset by themselves or print one or two more lines mostly
related to hardcrashes (memory page faults or otherwise)
and hang then. This can vary from boot to boot even
with the same kernel.

Some kernels don't hang. They never hang - they always work.

Kernels that work do NOT print "agpgart: Detected an Intel
965G Chipset." (All I know is that I have an ASUS P5B motherboard
with a iP965, whether it's this 'G' or not I don't know).


This is the regression that 'git bisect' comes with:

hikaru:/usr/src/kernel/git/linux-2.6>git bisect bad
d09c6b809432668371b5de9102f4f9aa6a7c79cc is first bad commit
commit d09c6b809432668371b5de9102f4f9aa6a7c79cc
Author: Paul Mundt <lethal@linux-sh.org>
Date:   Thu Jun 14 15:13:16 2007 +0900

    mm: Fix memory/cpu hotplug section mismatch and oops.

    When building with memory hotplug enabled and cpu hotplug disabled, we
    end up with the following section mismatch:

    WARNING: mm/built-in.o(.text+0x4e58): Section mismatch: reference to
    .init.text: (between 'free_area_init_node' and '__build_all_zonelists')

    This happens as a result of:

            -> free_area_init_node()
              -> free_area_init_core()
                -> zone_pcp_init() <-- all __meminit up to this point
                  -> zone_batchsize() <-- marked as __cpuinit   fo

    This happens because CONFIG_HOTPLUG_CPU=n sets __cpuinit to __init, but
    CONFIG_MEMORY_HOTPLUG=y unsets __meminit.

    Changing zone_batchsize() to __devinit fixes this.

    __devinit is the only thing that is common between CONFIG_HOTPLUG_CPU=y and
    CONFIG_MEMORY_HOTPLUG=y. In the long run, perhaps this should be moved to
    another section identifier completely. Without this, memory hot-add
    of offline nodes (via hotadd_new_pgdat()) will oops if CPU hotplug is
    not also enabled.

    Signed-off-by: Paul Mundt <lethal@linux-sh.org>
    Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

    --

     mm/page_alloc.c |    2 +-
     1 file changed, 1 insertion(+), 1 deletion(-)

:040000 040000 230b105fa4d9eb2ed873cca8e9ec1b5502ffce79 37636618f4eb88827ec1e524ebb3ac37e44e90f1 M      mm

==================

If you want my opinion on this: git bisect is broken :p
I was very surprised that it printed this at this point.
One bisect before, it said there were still 96 revision to check.

Anyway - here are some facts of the kernels that I tested:

188e1f81ba31af1b65a2f3611df4c670b092bbac        BAD     2007-06-17 04:09:12     v2.6.22-rc5
3e903e7b1605aff88d7f89a96fab5e43081b914f        BAD     2007-06-16 19:16:01
de7f928ca460005086a8296be07c217aac4b625d        BAD     2007-06-16 02:34:34     Merge master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6
d1be0a8225f2cb1cdc356ebb0ae6800f023ce67d        BAD     2007-06-16 02:24:44
ce9b2b0abbf019d5259eb089a1cc256852930f67        BAD     2007-06-16 02:24:43
d09c6b809432668371b5de9102f4f9aa6a7c79cc        BAD     2007-06-14 08:13:16     mm: Fix memory/cpu hotplug section mismatch and oops.
cf68676222e54cd0a31efd968da00e65f9a0963f        GOOD    2007-06-11 10:12:49
99f9f3d49cbc7d944476f6fde53a77ec789ab2aa        GOOD    2007-06-12 00:46:08     Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
3334500b460a5eede2e3466ca97a90fe3b91ceb5        GOOD    2007-06-11 20:39:05     Merge master.kernel.org:/pub/scm/linux/kernel/git/davej/agpgart
df80b148869291621ddf51eb8716658d5bfba811        GOOD    2007-05-31 05:51:21     [AGPGART] intel_agp: add support for 945GME
9614ece14f23f2ce54a076c471aec9c91e51e79c        GOOD    2007-05-30 03:45:58     [AGPGART] intel_agp: use table for device probe
c4ca881796b7e14120851ddf6e04845ef94a314a        BAD     2007-05-30 03:40:46     [AGPGART] intel_agp: cleanup intel private data
e141d999b682cda9907179e3b843acb64c34a1d8        BAD     2007-06-10 07:26:20
b44c0267b7571b449e05f390349c4e4d080f0f4c        BAD     2007-06-11 20:32:28     Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb
bb3d2dd72302ea3eefcc6738cdd39ed5864b62f8        BAD     2007-06-11 20:31:43     Merge master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6
1a539a87280b3032fd12bc93a4a82f1d8aa97ca8        BAD     2007-06-08 22:46:58
5ecd3100e695228ac5e0ce0e325e252c0f11806f        BAD     2007-06-05 02:57:25     v2.6.22-rc4
c420bc9f09a0926b708c3edb27eacba434a4f4ba        BAD     2007-05-26 04:55:14     v2.6.22-rc3
55b637c6a003a8c4850b41a2c2fd6942d8a7f530        BAD     2007-05-19 06:06:17     v2.6.22-rc2
...                                             ...
                                                BAD                             v2.6.19-rc1
                                                GOOD                            v2.6.18

The order and date is the order and date as is shown by gitk --all.

I'd appreciate any suggestions or questions at this point, as I have no
idea what to do next to find this problem.

-- 
Carlo Wood <carlo@alinoe.com>

PS The hardware that I'm using is:

An ASUS P5B Deluxe motherboard with an Intel Core 2 Quad QX6700 2.66 GHz,
4 GB of low latency DIMMs (two times KHX6400D2LLK2/2GN - two DIMM's each, 4 DIMM's
in total, which are CL4-4-4). Asus EN8600 GTS 256MB.

