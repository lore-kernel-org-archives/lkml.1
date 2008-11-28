Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYK1CiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYK1CiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 21:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYK1CiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 21:38:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60732 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbYK1CiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 21:38:14 -0500
Message-ID: <492F59A2.3000104@cn.fujitsu.com>
Date: Fri, 28 Nov 2008 10:38:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       taka@valinux.co.jp
Subject: Re: [RFC][PATCH 1/2] CGROUP ID and Hierarchy Code
References: <20081127160548.3274c8e6.kamezawa.hiroyu@jp.fujitsu.com>	<492F4941.2030707@cn.fujitsu.com>	<20081128103533.049f0b7b.kamezawa.hiroyu@jp.fujitsu.com> <20081128111832.b52a6909.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081128111832.b52a6909.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 28 Nov 2008 10:35:33 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>> On Fri, 28 Nov 2008 09:28:33 +0800
>> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>>> I think the safe way is:
>>>
>>> rcu_read_lock();
>>> cgrp = cgroup_get_next()
>>> if (!inc_not_zero(cgrp) {
>>> 	rcu_read_unlock();
>>> 	return NULL;
>>> }
>>> rcu_read_unlock();
>>> return cgrp;
>>>
>>> But it's also safe to use cgrp = list_entry(&parent->children.next) for the above
>>> scenario, seems you don't have to invent this cgroup_get_next().
>>>
>> But list-walk can't provide us view of hierarchy. Up-Down list walk is better ?
>> please see memcg's code. it met some troubles.
>> I'll make kfree(cgrp) to be called by RCU.
>>
> 
> Ah please, I have a question.
> Following is right ?
> 	- until mount, cgroup's subsystem root is tied to dummy? root cgroup.

Yes.

> 	- cgroup cannot be unmounted while there are any children.

No, you can unmount. You can have it a try. :)

> 	- cgroup_root is freed/allocated at umount/mount, then I have to handle

No, kill_sb() is called when deactivate_super() decreases sb->s_active to 0, and
whenever we create a cgroup, sb->s_active is increased, so if there are sub-dirs
the cgroup_root won't be freed at umount.

> 	  this event in cgroup-id.
> 	 (maybe current code has leak? in umount.)
>  

So I think there is no leak. ;)

> Thanks,
> -Kame
> 
> 
> 
