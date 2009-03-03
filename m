Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZCCLvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZCCLvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZCCLvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:51:03 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37562 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZCCLvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:51:01 -0500
Message-ID: <52c02febf1e87a4f0a6e81124e00876a.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090303111244.GP11421@balbir.in.ibm.com>
References: <20090302044043.GC11421@balbir.in.ibm.com>
    <20090302143250.f47758f9.kamezawa.hiroyu@jp.fujitsu.com>
    <20090302060519.GG11421@balbir.in.ibm.com>
    <20090302152128.e74f51ef.kamezawa.hiroyu@jp.fujitsu.com>
    <20090302063649.GJ11421@balbir.in.ibm.com>
    <20090302160602.521928a5.kamezawa.hiroyu@jp.fujitsu.com>
    <20090302124210.GK11421@balbir.in.ibm.com>
    <c31ccd23cb41f0f7594b3f56b20f0165.squirrel@webmail-b.css.fujitsu.com>
    <20090302174156.GM11421@balbir.in.ibm.com>
    <20090303085914.555089b1.kamezawa.hiroyu@jp.fujitsu.com>
    <20090303111244.GP11421@balbir.in.ibm.com>
Date: Tue, 3 Mar 2009 20:50:56 +0900 (JST)
Subject: Re: [PATCH 0/4] Memory controller soft limit patches (v3)
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Bharata B Rao" <bharata@in.ibm.com>, "Paul Menage" <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-03
> 08:59:14]:
>> But, on NUMA, because memcg just checks "usage" and doesn't check
>> "usage-per-node", there can be memory shortage and this kind of
>> soft-limit
>> sounds attractive for me.
>>
>
>
> Could you please elaborate further on this?
>
Try to explain by artificial example..
.
Assume a system with 4 nodes, and 1G of memory per node.
==
     Node0 -- 1G
     Node1 -- 1G
     Node2 -- 1G
     Node3 -- 1G
==
And assume there are 3 memory cgroups of following hard-limit.
==
    GroupA -- 1G
    GroupB -- 0.6G
    GroupC -- 0.6G
==
If the machine is not-NUMA and 4G SMP, we expect 1.8G of free memory and
we can assume "global memory shortage" is a rare event.

But on NUMA, memory usage can be following.
==
     GroupA -- 950M of usage
     GrouoB -- 550M of usage
     GroupC -- 550M of usage
and
     Node0 -- usage=1G
     Node1 -- usage=1G
     Node2 -- usage=50M
     Node2 -- Usage=0
==
In this case, kswapd will work on Node0, and Node1.
Softlimit will have chance to work. If the user declares GroupA's softlimit
is 800M, GroupA will be victim in this case.

But we have to admit this is hard-to-use scheduling paramter. Almost all
administrator will not be able to set proper value.
A useful case I can think of is creating some "victim" group and guard
other groups from global memory reclaim. I think I need some study about
how-to-use softlimit. But we'll need this kind of paramater,anyway and
I don't have onjection to add this kind of scheduling parameter.
But implementation should be simple at this stage and we should
find best scheduling algorithm under use-case finally...

Thanks,
-Kame

