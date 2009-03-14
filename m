Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZCNQ0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZCNQ0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 12:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZCNQ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:26:09 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:37847 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbZCNQ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:26:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqoEALN3u0lMQW1W/2dsb2JhbACBTs4ggjWBSgY
Date: Sat, 14 Mar 2009 12:26:01 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: mbligh@google.com
Subject: Re: [ltt-dev] LTTng 0.108 provides many performance improvements
Message-ID: <20090314162601.GA10998@Krystal>
References: <20090313232811.GA18251@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090313232811.GA18251@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:22:11 up 14 days, 12:48,  1 user,  load average: 0.14, 0.22,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> Hi,
> 
> I just released LTTng 0.108. Time had come to do a bit of performance
> tuning using oprofile.
> 
> Basically, the tbench workload, under flight recorder tracing, passed
> from a 52 % slowdown with previous lttng to a 32 % slowdown with lttng
> 0.108 on my test machine (8-cores x86_64, 16GB ram).
> 

Down to 30% performance impact by using a pointer array instead of a
linked list to manage the buffer pages (it's in 0.110). I ensure that
the accesses done on the array will never cause vmalloc faults (I think
the kernel could potentially fall back to vmalloc'd memory if the array
is too large to be allocated with kmalloc, but I'm unsure about this, as
I cannot find the offending code in 2.6.29-rc7). I call
vmalloc_sync_all() after allocating the array to make sure the TLBs are
populated (it's just safer).

Mathieu

> Modifications done :
> 
> - inlined fast paths. Modularity is now provided by the build system,
>   not by callbacks anymore. Selecting between lockless and locked buffer
>   management must be done at compile-time. I'd like to keep the
>   "transport" around because it will be used eventually to specify where
>   the information must be sent rather than selecting the buffer management
>   mechanism (e.g. sent to physical pages (contiguous or non-contiguous),
>   video card memory...). The "transport" option is still there, but it
>   currently does not do much. The slow paths are now done in function
>   calls.
> 
> - Fixed false sharing problem. It looks like the kzalloc_node()
>   allocator, used to allocate the commit counters, does not align the
>   memory allocated on cache lines.
> 
> Therefore I think the new code will be _much_ easier to optimize,
> because the fastpaths are very well identified and much smaller than
> they were before. I diminished the tracer stack space used, register
> usage and instruction cache usage.
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
