Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbZE0DXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbZE0DXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZE0DXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:23:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52856 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbZE0DXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:23:07 -0400
Message-ID: <4A1CB266.8000400@cn.fujitsu.com>
Date: Wed, 27 May 2009 11:24:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroups: handle failure of cgroup_populate_dir() at 
 mount/remount
References: <4A16153C.2080004@cn.fujitsu.com>	<20090522172545.1e5e5f81.kamezawa.hiroyu@jp.fujitsu.com>	<6599ad830905261506x480f2167naf1034177bbc7036@mail.gmail.com>	<4A1C9253.3060108@cn.fujitsu.com> <20090527103404.81d3c1a4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090527103404.81d3c1a4.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 27 May 2009 09:07:31 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Paul Menage wrote:
>>> On Fri, May 22, 2009 at 1:25 AM, KAMEZAWA Hiroyuki
>>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>>> Hm, shouldn't we allow "noprefix" to be effective only agaisnt cpuset ?
>>>> I think it's just for backward-compatibility of cpuset.
>>>> (I don't like the option at all.)
>>> Yes, exposing the "noprefix" option externally was one of the mistakes
>>> I made when developing cgroups.
>>>
>>> It seems to me really unlikely that anyone is using "noprefix" for
>> And "noprefix" is not documented in cgroups.txt, so I guess not
>> many people know this option. Even libcgroup doesn't handle it.
>>
>>> anything other than implicitly when mounting the "cpuset" filesystem.
>>> So I'd be inclined to just forbid it if we're mounting more than just
>>> the cpuset subsystem. A bit of a nasty abstraction violation, but it
>>> makes more sense overall. The only problem is that someone *might* be
>>> using it - do we have any way to determine how, and how big do they
>>> have to be before we care?
>>>
>> I think we can never know..
> 
> How about this method ?
> 
>  - add "noprefix" to "to-be-removed" list.
>  - add "WARNING: noprefix option will be removed in 2.6.32 (or 2.6.31)" now
>  - remove "noprefix" in 2.6.31-rc or later
> 

I don't see how we can remove noprefix while reserve the compatibility of
old cpuset..

As Paul Menage said, we can allow noprefix to be used only if we mount just
cpuset subsystem:

(pseudo code)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -886,6 +886,11 @@ static int parse_cgroupfs_options(char *data,
                }
        }

+
+       if (test_bit(ROOT_NOPREFIX, &opts->flags) &&
+           (opts->subsys_bits & ~cpuset_subsys_id) != 0)
+               return -EINVAL;
+
        /* We can't have an empty hierarchy */
        if (!opts->subsys_bits)
                return -EINVAL;

