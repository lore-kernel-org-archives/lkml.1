Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbZJ1FNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbZJ1FNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbZJ1FNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:13:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9558 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621AbZJ1FNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:13:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FykVgM24yqxJfun+d+wA6sAXCRkVqEr18wUcyoIzT44CjBh9uJvw0ElWtLp7XUZmu
	qfqEO+LozA2B7DeGDf1+A==
Date: Tue, 27 Oct 2009 22:13:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org> <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com> <hb2cfu$r08$2@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
 <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com>
 <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, KAMEZAWA Hiroyuki wrote:

> not related to child-parent problem.
> 
> Seeing this number more.
> ==
> [97137.709272] Active_anon:671487 active_file:82 inactive_anon:132316
> [97137.709273]  inactive_file:82 unevictable:50 dirty:0 writeback:0 unstable:0
> [97137.709273]  free:6122 slab:17179 mapped:30661 pagetables:8052 bounce:0
> ==
> 
> acitve_file + inactive_file is very low. Almost all pages are for anon.
> But "mapped(NR_FILE_MAPPED)" is a little high. This implies remaining file caches
> are mapped by many processes OR some mega bytes of shmem is used.
> 
> # of pagetables is 8052, this means
>   8052x4096/8*4k bytes = 16Gbytes of mapped area.
> 
> Total available memory is near to be active/inactive + slab 
> 671487+82+132316+82+50+6122+17179+8052=835370x4k= 3.2Gbytes ?
> (this system is swapless)
> 

Yep:

[97137.724965] 917504 pages RAM
[97137.724967] 69721 pages reserved

(917504 - 69721) * 4K = ~3.23G

> Then, considering the pmap kosaki shows,
> I guess killed ones had big total_vm but has not much real rss,
> and no helps for oom.
> 

echo 1 > /proc/sys/vm/oom_dump_tasks can confirm that.

The bigger issue is making the distinction between killing a rogue task 
that is using much more memory than expected (the supposed current 
behavior, influenced from userspace by /proc/pid/oom_adj), and killing the 
task with the highest rss.  The latter is definitely desired if we are 
allocating tons of memory but reduces the ability of the user to influence 
the badness score.
