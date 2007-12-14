Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbXLNSIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbXLNSIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXLNSH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:07:58 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:51345 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbXLNSHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:07:54 -0500
X-Greylist: delayed 1985 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2007 13:07:53 EST
Date: Fri, 14 Dec 2007 18:29:46 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: linux-net@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: dst cache overflow
Message-ID: <20071214172945.GA10809@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eric Dumazet <dada1@cosmosbay.com>
References: <20070814160646.GA16283@yamamaya.is-a-geek.org> <20070814192453.5a873723.dada1@cosmosbay.com> <20070814180015.GB3024@yamamaya.is-a-geek.org> <20070816184501.cbbd28a2.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070816184501.cbbd28a2.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> On Tue, 14 Aug 2007 20:00:15 +0200
> Tobias Diedrich <ranma+kernel@tdiedrich.de> wrote:
> 
> > Eric Dumazet wrote:
> > 
> > > Tobias Diedrich <ranma+kernel@tdiedrich.de> wrote:
> > > 
> > > > Hello,
> > > > 
> > > > I suspect I'm seeing a slow dst cache leakage on one of my servers.
> > > > The server in question (oni) regularly needs to be rebooted, because
> > > > it loses network connectivity. However, netconsole and syslog shows that the
> > > > machine is still running and the kernel complains about "dst cache
> > > > overflow".
> > > > 
> > > > I have since installed a monitoring script, which stores the output of
> > > > both "ip route ls cache | fgrep cache | wc -l" and the 'entries' value
> > > > of /proc/net/stat/rt_cache (as suggested in 
> > > > http://www.mail-archive.com/netdev@vger.kernel.org/msg02107.html)
> > > > and produces a nice rrd graph:
> > > > 
> > > > http://uguu.de/~ranma/route-month-oni.png
> > > > So entries is growing more or less constantly, while the number of
> > > > active routes (not visible on the graph due to being too small) is
> > > > relatively constant.
> > > > 
> > > > Comparing this to another host running the exact same kernel:
> > > > http://uguu.de/~ranma/route-month-ari.png
> > > > Here cached_routes and entries barely differ at all.
> > > > 
> > > > The funny thing is, both hosts are running the exact same kernel
> > > > and use more or less the same iptables rules.
> > > > 
> > > > So I'm not sure what would cause the dst cache to leak only on host
> > > > oni?
> > > > 
> > > 
> > > Could you send the result of these commands on oni and ari ?
> > > 
> > > ip route ls
> > > grep . /proc/sys/net/ipv4/route/*
> > 
> > Sure.
> > 
> > AFAICS the only visible difference is gc_thresh, which is probably
> > double the size on oni since oni has double the amount of memory
> > (512MB for oni vs. 256MB for ari).
> 
> You might try to boot oni adding this to kernel commandline : rhash_entries=2047
> so that oni has the same route cache hashtable, and see if it changes anything.

That hasn't helped I'm afraid.
However I think it actually does affect all three systems running
this kernel after all, the problme only manifests itself faster on
oni.

Meanwhile I added a slab statistic rrd script. Nothing obvious to
see on ari or yumi yet, but on oni (which after all is the most
affected by this) I can see 'size_2048' and 'TCPv6' growing
steadily along with the route cache size (Presumably 'ip_dst_cache',
which is also growing larger at a more or less constant rate).

http://www.tdiedrich.de/~ranma/oni_20071214_route-week.png
http://www.tdiedrich.de/~ranma/oni_20071214_slab-week.png
http://www.tdiedrich.de/~ranma/oni_20071214_route-year.png
http://www.tdiedrich.de/~ranma/ari_20071214_route-year.png
http://www.tdiedrich.de/~ranma/yumi_20071214_route-year.png

You can see that the difference on ari and yumi was also growing
until they were rebooted (in the beginning of december for ari,
beginning of november for yumi).

Currently all three are running 2.6.23.9 and the problem is still
there.

HTH,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
