Return-Path: <linux-kernel-owner+w=401wt.eu-S1759704AbZDQLf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbZDQLf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbZDQLfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:35:20 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:53718 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbZDQLfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:35:19 -0400
Message-ID: <49E86975.1030200@oss.ntt.co.jp>
Date: Fri, 17 Apr 2009 20:35:17 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       matt@bluehost.com, dradford@bluehost.com, ngupta@google.com,
       randy.dunlap@oracle.com, roberto@unbit.it,
       Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] io-throttle documentation
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-2-git-send-email-righi.andrea@gmail.com> <20090417102417.88a0ef93.kamezawa.hiroyu@jp.fujitsu.com> <49E7E1CF.6060209@cn.fujitsu.com> <20090417102539.GA16838@linux>
In-Reply-To: <20090417102539.GA16838@linux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> On Fri, Apr 17, 2009 at 09:56:31AM +0800, Li Zefan wrote:
>> KAMEZAWA Hiroyuki wrote:
>>> On Tue, 14 Apr 2009 22:21:12 +0200
>>> Andrea Righi <righi.andrea@gmail.com> wrote:
>>>
>>>> +Example:
>>>> +* Create an association between an io-throttle group and a bio-cgroup group
>>>> +  with "bio" and "blockio" subsystems mounted in different mount points:
>>>> +  # mount -t cgroup -o bio bio-cgroup /mnt/bio-cgroup/
>>>> +  # cd /mnt/bio-cgroup/
>>>> +  # mkdir bio-grp
>>>> +  # cat bio-grp/bio.id
>>>> +  1
>>>> +  # mount -t cgroup -o blockio blockio /mnt/io-throttle
>>>> +  # cd /mnt/io-throttle
>>>> +  # mkdir foo
>>>> +  # echo 1 > foo/blockio.bio_id
>>> Why do we need multiple cgroups at once to track I/O ?
>>> Seems complicated to me.
>>>
>> IIUC, it also disallows other subsystems to be binded with blockio subsys:
>>   # mount -t cgroup -o blockio cpuset xxx /mnt
>>   (failed)
>>
>> and if a task is moved from cg1(id=1) to cg2(id=2) in bio subsys, this task
>> will be moved from CG1(id=1) to CG2(id=2) automatically in blockio subsys.
>>
>> All these are odd, unexpected, complex and bug-prone I think..
> 
> Implementing bio-cgroup functionality as pure infrastructure framework
> instead of a cgroup subsystem would remove all this oddity and
> complexity.

Andrea, I agree with you completely. In fact, we have been working on that for
a while and have just proposed doing exactly that on a different mail thread
(you are CC'ed). It would be great if you could comment on that proposal.

Thanks,

Fernando

> For example, the actual functionality that I need for the io-throttle
> controller is just an interface to set and get the cgroup owner of a
> page. I think it should be the same also for other potential users of
> bio-cgroup.
> 
> So, what about implementing the bio-cgroup functionality as cgroup "page
> tracking" infrastructure and provide the following interfaces:
> 
> /*
>  * Encode the cgrp->css.id in page_group->flags
>  */
> void set_cgroup_page_owner(struct page *page, struct cgroup *cgrp);
> 
> /*
>  * Returns the cgroup owner of a page, decoding the cgroup id from
>  * page_cgroup->flags.
>  */
> struct cgroup *get_cgroup_page_owner(struct page *page);
> 
> This also wouldn't increase the size of page_cgroup because we can
> encode the cgroup id in the unused bits of page_cgroup->flags, as
> originally suggested by Kame.
> 
> And I think it could be used also by dm-ioband, even if it's not a
> cgroup-based subsystem... but I may be wrong. Ryo what's your opinion?
> 
> -Andrea

