Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbZHJFag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZHJFag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 01:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZHJFaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 01:30:35 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:40063 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbZHJFae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 01:30:34 -0400
Date: Mon, 10 Aug 2009 11:00:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, andi.kleen@intel.com,
       Prarit Bhargava <prarit@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Help Resource Counters Scale Better (v3)
Message-ID: <20090810053025.GC5257@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090807221238.GJ9686@balbir.in.ibm.com> <39eafe409b85053081e9c6826005bb06.squirrel@webmail-b.css.fujitsu.com> <20090808060531.GL9686@balbir.in.ibm.com> <99f2a13990d68c34c76c33581949aefd.squirrel@webmail-b.css.fujitsu.com> <20090809121530.GA5833@balbir.in.ibm.com> <20090810093229.10db7185.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090810093229.10db7185.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-10 09:32:29]:

> On Sun, 9 Aug 2009 17:45:30 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Hi, 
> > 
> > Thanks for the detailed review, here is v3 of the patches against
> > mmotm 6th August. I've documented the TODOs as well. If there are
> > no major objections, I would like this to be included in mmotm
> > for more testing. Any test reports on a large machine would be highly
> > appreciated.
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > Changelog v3->v2
> > 
> > 1. Added more documentation and comments
> > 2. Made the check in mem_cgroup_set_limit strict
> > 3. Increased tolerance per cpu to 64KB.
> > 4. Still have the WARN_ON(), I've kept it for debugging
> >    purposes, may be we should make it a conditional with
> >    DEBUG_VM
> > 
> Because I'll be absent for a while, I don't give any Reviewed-by or Acked-by, now.
> 
> Before leaving, I'd like to write some concerns here.
> 
> 1. you use res_counter_read_positive() in force_empty. It seems force_empty can
>    go into infinite loop. plz check. (especially when some pages are freed or swapped-in
>    in other cpu while force_empry runs.)

OK.. so you want me to use _sum_positive(), will do. In all my testing
using the stress scripts I have, I found no issues with force_empty so
far. But I'll change over.

> 
> 2. In near future, we'll see 256 or 1024 cpus on a system, anyway.
>    Assume 1024cpu system, 64k*1024=64M is a tolerance.
>    Can't we calculate max-tolerane as following ?
>   
>    tolerance = min(64k * num_online_cpus(), limit_in_bytes/100);
>    tolerance /= num_online_cpus();
>    per_cpu_tolerance = min(16k, tolelance);
> 
>    I think automatic runtine adjusting of tolerance will be finally necessary,
>    but above will not be very bad because we can guarantee 1% tolerance.
> 

I agree that automatic tuning will be necessary, but I want to go the
CONFIG_MEM_CGROUP_RES_TOLERANCE approach you suggested earlier, since
num_online_cpus() with CPU hotplug can be a bit of a game play and
with Power Management and CPUs going idle, we really don't want to
count those, etc. For now a simple nr_cpu_ids * tolerance and then
get feedback, since it is a heuristic. Again, limit_in_bytes can
change, may be some of this needs to go into resize_limit and
set_limit paths. Right now, I want to keep it simple and see if
others can see the benefits of this patch. Then add some more
heuristics based on your suggestion.

Do you agree?



-- 
	Balbir
