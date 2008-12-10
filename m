Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYLJKX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYLJKX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 05:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYLJKXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 05:23:48 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51676 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbYLJKXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 05:23:47 -0500
Message-ID: <61242.10.75.179.61.1228904624.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <6599ad830812100100i54132600he52504b4785542ec@mail.gmail.com>
References: <20081205172642.565661b1.kamezawa.hiroyu@jp.fujitsu.com><20081205172845.2b9d89a5.kamezawa.hiroyu@jp.fujitsu.com><6599ad830812050139l5797f16kaf511f831b09e8f4@mail.gmail.com><62469.10.75.179.62.1228476245.squirrel@webmail-b.css.fujitsu.com>
    <6599ad830812100100i54132600he52504b4785542ec@mail.gmail.com>
Date: Wed, 10 Dec 2008 19:23:44 +0900 (JST)
Subject: Re: [RFC][PATCH 1/4] New css->refcnt implementation.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage said:
> On Fri, Dec 5, 2008 at 3:24 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>> The basic rule is that you're only supposed to increment the css
>>> refcount if you have:
>>>
>>> - a reference to a task in the cgroup (that is pinned via task_lock()
>>> so it can't be moved away)
>>> or
>>> - an existing reference to the css
>>>
>> My problem is that we can do css_get() after pre_destroy() and
>> css's refcnt goes down to 0.
>
> But where are you getting the reference from in order to do css_get()?
> Which call in mem cgroup are you concerned about?
>
mem_cgroup_try_charge_swapin() at el. all swap-in codes.
In that functions, follwoing occurs.
==
    assume swp_entry which is being swapped-in
    lookup swap_cgroup for swp_entry.
    get memcg from swap_cgroup.
    charge() against memcg got by swap_cgroup. charge() will do css_get()
==
Currently, mem_cgroup->obsolete is used for making this never happen.
But, mem_cgroup->obsolete flag is broken,now.
I'm looking for alternative. (see other patches. I know there are several
ways to go.)

*AND* any kinds of hierarchy-tree-walk algorithm may call css_get() against
cgroup under rmdir() if it's not marked as REMOVED.

Thanks,
-Kame

