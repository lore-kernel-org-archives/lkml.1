Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXHNSAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXHNSAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXHNSAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:00:25 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:33150 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609AbXHNSAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:00:22 -0400
Date: Tue, 14 Aug 2007 20:00:15 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: dst cache overflow
Message-ID: <20070814180015.GB3024@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-net@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20070814160646.GA16283@yamamaya.is-a-geek.org> <20070814192453.5a873723.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070814192453.5a873723.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

> Tobias Diedrich <ranma+kernel@tdiedrich.de> wrote:
> 
> > Hello,
> > 
> > I suspect I'm seeing a slow dst cache leakage on one of my servers.
> > The server in question (oni) regularly needs to be rebooted, because
> > it loses network connectivity. However, netconsole and syslog shows that the
> > machine is still running and the kernel complains about "dst cache
> > overflow".
> > 
> > I have since installed a monitoring script, which stores the output of
> > both "ip route ls cache | fgrep cache | wc -l" and the 'entries' value
> > of /proc/net/stat/rt_cache (as suggested in 
> > http://www.mail-archive.com/netdev@vger.kernel.org/msg02107.html)
> > and produces a nice rrd graph:
> > 
> > http://uguu.de/~ranma/route-month-oni.png
> > So entries is growing more or less constantly, while the number of
> > active routes (not visible on the graph due to being too small) is
> > relatively constant.
> > 
> > Comparing this to another host running the exact same kernel:
> > http://uguu.de/~ranma/route-month-ari.png
> > Here cached_routes and entries barely differ at all.
> > 
> > The funny thing is, both hosts are running the exact same kernel
> > and use more or less the same iptables rules.
> > 
> > So I'm not sure what would cause the dst cache to leak only on host
> > oni?
> > 
> 
> Could you send the result of these commands on oni and ari ?
> 
> ip route ls
> grep . /proc/sys/net/ipv4/route/*

Sure.

AFAICS the only visible difference is gc_thresh, which is probably
double the size on oni since oni has double the amount of memory
(512MB for oni vs. 256MB for ari).

Host oni:

# ip route ls output:
217.172.187.0/24 dev eth0  proto kernel  scope link  src 217.172.187.75 
default via 217.172.187.1 dev eth0 

# grep output:
/proc/sys/net/ipv4/route/error_burst:500
/proc/sys/net/ipv4/route/error_cost:100
/proc/sys/net/ipv4/route/gc_elasticity:8
/proc/sys/net/ipv4/route/gc_interval:60
/proc/sys/net/ipv4/route/gc_min_interval:0
/proc/sys/net/ipv4/route/gc_min_interval_ms:500
/proc/sys/net/ipv4/route/gc_thresh:4096
/proc/sys/net/ipv4/route/gc_timeout:300
/proc/sys/net/ipv4/route/max_delay:10
/proc/sys/net/ipv4/route/max_size:65536
/proc/sys/net/ipv4/route/min_adv_mss:256
/proc/sys/net/ipv4/route/min_delay:2
/proc/sys/net/ipv4/route/min_pmtu:552
/proc/sys/net/ipv4/route/mtu_expires:600
/proc/sys/net/ipv4/route/redirect_load:2
/proc/sys/net/ipv4/route/redirect_number:9
/proc/sys/net/ipv4/route/redirect_silence:2048
/proc/sys/net/ipv4/route/secret_interval:600

Host ari:

# ip route ls output:
217.160.215.0/24 dev eth0  proto kernel  scope link  src 217.160.215.119 
default via 217.160.215.1 dev eth0 

# grep output:
/proc/sys/net/ipv4/route/error_burst:500
/proc/sys/net/ipv4/route/error_cost:100
/proc/sys/net/ipv4/route/gc_elasticity:8
/proc/sys/net/ipv4/route/gc_interval:60
/proc/sys/net/ipv4/route/gc_min_interval:0
/proc/sys/net/ipv4/route/gc_min_interval_ms:500
/proc/sys/net/ipv4/route/gc_thresh:2048
/proc/sys/net/ipv4/route/gc_timeout:300
/proc/sys/net/ipv4/route/max_delay:10
/proc/sys/net/ipv4/route/max_size:32768
/proc/sys/net/ipv4/route/min_adv_mss:256
/proc/sys/net/ipv4/route/min_delay:2
/proc/sys/net/ipv4/route/min_pmtu:552
/proc/sys/net/ipv4/route/mtu_expires:600
/proc/sys/net/ipv4/route/redirect_load:2
/proc/sys/net/ipv4/route/redirect_number:9
/proc/sys/net/ipv4/route/redirect_silence:2048
/proc/sys/net/ipv4/route/secret_interval:600

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
