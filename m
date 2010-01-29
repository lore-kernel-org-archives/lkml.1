Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700Ab0A2QmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab0A2QmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105Ab0A2QmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:42:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55546 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0A2QmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:42:03 -0500
Message-ID: <5a0e6098f900aa36993b2b7f2320f927.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20100129163030.1109ce78@lxorguk.ukuu.org.uk>
References: <f8c9aca9c98db8ae7df3ac2d7ac8d922.squirrel@webmail-b.css.fujitsu.com>
    <20100129162137.79b2a6d4@lxorguk.ukuu.org.uk>
    <c6c48fdf7f746add49bb9cc058b513ae.squirrel@webmail-b.css.fujitsu.com>
    <20100129163030.1109ce78@lxorguk.ukuu.org.uk>
Date: Sat, 30 Jan 2010 01:41:58 +0900 (JST)
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       vedran.furac@gmail.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> > Ultimately it is policy. The kernel simply can't read minds.
>> >
>> If so, all heuristics other than vm_size should be purged, I think.
>> ...Or victim should be just determined by the class of application
>> user sets. oom_adj other than OOM_DISABLE, searching victim process
>> by black magic are all garbage.
>
> oom_adj by value makes sense as do some of the basic heuristics - but a
> lot of the complexity I would agree is completely nonsensical.
>
> There are folks who use oom_adj weightings to influence things (notably
> embedded and desktop). The embedded world would actually benefit on the
> whole if the oom_adj was an absolute value because they usually know
> precisely what they want to die and in what order.
>
okay...I guess the cause of the problem Vedran met came from
this calculation.
==
 109         /*
 110          * Processes which fork a lot of child processes are likely
 111          * a good choice. We add half the vmsize of the children if they
 112          * have an own mm. This prevents forking servers to flood the
 113          * machine with an endless amount of children. In case a single
 114          * child is eating the vast majority of memory, adding only half
 115          * to the parents will make the child our kill candidate of
choice.
 116          */
 117         list_for_each_entry(child, &p->children, sibling) {
 118                 task_lock(child);
 119                 if (child->mm != mm && child->mm)
 120                         points += child->mm->total_vm/2 + 1;
 121                 task_unlock(child);
 122         }
 123
==
This makes task launcher(the fist child of some daemon.) first victim.
And...I wonder this is not good for oom_adj,
I think it's set per task with regard to personal memory usage.

But I'm not sure why this code is used now. Does anyone remember
history or the benefit of this calculation ?

Thanks,
-Kame




