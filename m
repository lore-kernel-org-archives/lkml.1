Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbZLOIKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbZLOIKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZLOIKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:10:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50196 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZLOIKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:10:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Dec 2009 17:07:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: nishimura@mxp.nes.nec.co.jp, containers@lists.linux-foundation.org,
       linux-mm@kvack.org, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/4] memcg: rework usage of stats by soft limit
Message-Id: <20091215170705.3dca982a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <cc557aab0912142348j6d0f6206qd751f74e416c6710@mail.gmail.com>
References: <cover.1260571675.git.kirill@shutemov.name>
	<ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	<c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
	<747ea0ec22b9348208c80f86f7a813728bf8e50a.1260571675.git.kirill@shutemov.name>
	<20091212125046.14df3134.d-nishimura@mtf.biglobe.ne.jp>
	<cc557aab0912120506x56b9a707ob556035fdcf40a22@mail.gmail.com>
	<20091212233409.60da66fb.d-nishimura@mtf.biglobe.ne.jp>
	<cc557aab0912121146y276a8d26v8baee15be1f83a97@mail.gmail.com>
	<20091215103517.75645536.kamezawa.hiroyu@jp.fujitsu.com>
	<cc557aab0912142348j6d0f6206qd751f74e416c6710@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 09:48:09 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Tue, Dec 15, 2009 at 3:35 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Sat, 12 Dec 2009 21:46:08 +0200
> > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> >
> >> On Sat, Dec 12, 2009 at 4:34 PM, Daisuke Nishimura
> >> <d-nishimura@mtf.biglobe.ne.jp> wrote:
> >> > On Sat, 12 Dec 2009 15:06:52 +0200
> >> > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> >> >
> >> >> On Sat, Dec 12, 2009 at 5:50 AM, Daisuke Nishimura
> >> >> <d-nishimura@mtf.biglobe.ne.jp> wrote:
> >> >> > And IIUC, it's the same for your threshold feature, right ?
> >> >> > I think it would be better:
> >> >> >
> >> >> > - discard this change.
> >> >> > - in 4/4, rename mem_cgroup_soft_limit_check to mem_cgroup_event_check,
> >> >> >  and instead of adding a new STAT counter, do like:
> >> >> >
> >> >> >        if (mem_cgroup_event_check(mem)) {
> >> >> >                mem_cgroup_update_tree(mem, page);
> >> >> >                mem_cgroup_threshold(mem);
> >> >> >        }
> >> >>
> >> >> I think that mem_cgroup_update_tree() and mem_cgroup_threshold() should be
> >> >> run with different frequency. How to share MEM_CGROUP_STAT_EVENTS
> >> >> between soft limits and thresholds in this case?
> >> >>
> >> > hmm, both softlimit and your threshold count events at the same place(charge and uncharge).
> >> > So, I think those events can be shared.
> >> > Is there any reason they should run in different frequency ?
> >>
> >> SOFTLIMIT_EVENTS_THRESH is 1000. If use the same value for thresholds,
> >> a threshold can
> >> be exceed on 1000*nr_cpu_id pages. It's too many. I think, that 100 is
> >> a reasonable value.
> >>
> >
> > Hmm, then what amount of costs does this code add ?
> >
> > Do you have benchmark result ?
> 
> I've post some numbers how the patchset affects performance:
> http://article.gmane.org/gmane.linux.kernel.mm/41880
> 
> Do you need any other results?
> 
Ah, sorry. I missed that. The numbers seems good.

(off topic)
multi-fault is too special, It's just a my toy ;)

The test I recommend you is kernel-make on tmpfs.
This is my setup script.
==
#!/bin/sh

mount -t tmpfs none /home/kamezawa/tmpfs
cp /home/kamezawa/linux-2.6.30.tar.bz2 /home/kamezawa/tmpfs
cd /home/kamezawa/tmpfs
mkdir /home/kamezawa/tmpfs/tmp
tar xvpjf linux-2.6.30.tar.bz2
cd linux-2.6.30
make defconfig

and making gcc's tmporarly strage(TMPDIR) on tmpfs.

#make clean; make -j 8 or some.

and check "stime"

But I don't ask you to do this, now.
The whole patch seems attractive to me. Please fix something pointed out.

I stop my patches for memcg's percpu counter rewriting until yours and
Nishimura's patch goes. You can leave your threshold-event-counter as it
is. I'll think of I can do total-rewrite of that counter or not.

Thanks,
-Kame

