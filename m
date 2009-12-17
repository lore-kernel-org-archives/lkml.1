Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbZLQF51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbZLQF51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZLQF5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:57:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56450 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbZLQF5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:57:24 -0500
Message-ID: <4B29C834.8090407@cn.fujitsu.com>
Date: Thu, 17 Dec 2009 13:57:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq: Remove useless css reference get
References: <4B289C93.3070603@cn.fujitsu.com> <20091216163941.GA2807@redhat.com>
In-Reply-To: <20091216163941.GA2807@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2009年12月17日 00:39, Vivek Goyal 写道:
> On Wed, Dec 16, 2009 at 04:38:43PM +0800, Gui Jianfeng wrote:
>> There's no need to take css reference here, for the caller
>> has already called rcu_read_lock() to prevent cgroup from 
>> being removed.
>>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Hi Gui,
> 
> How would an rcu lock protect against the possibility that blkiocg_destroy()
> has not already been called on another cpu? rcu lock will make sure that
> cgroup and blkio_cgroup object should still be around as long as I am
> holding rcu lock but will not protect against deletion path being executed
> on another cpu? So I don't want to end up in following situation.
> 
>      cpu1                      cpu2
> 
> rcu_read_lock()
> 			      blkiocg_destroy()
> 
> blkiocg_add_blkio_group()
> rcu_read_unlock()
> 
> I don't want to add blkg object on a potentially dead blkio_cgroup object
> which will go away. Does this protection is provided by generic cgroup
> code where blkiocg_destroy() will not be called if I have got cgroup
> pointer under rcu lock?
> 
> Currently we are deriving cgroup information from task context so task is
> still inside cgroup, so cgroup can't be deleted anyway. What if I was 
> deriving cgroup information from bio, will taking css object reference be
> necessary in that case or just cgroup pointer under rcu lock is sufficient
> to preclude the race against cgroup deletion path?
> 

We pass a cgroup ptr to cfq_find_alloc_cfqg(), which means the cgroup is
valid. As long as it's safe to access the cgroup, it's safe to access the
corresponding blkio_cgroup.

But if you still want blkio_cgroup to be valid after dropping rcu_read_lock
(or cgroup_mutex), you need to call css_get() first. Note you don't need
to call css_tryget(). css_tryget() is only needed in mem_cgroup, because
mem_cgroup is a bit special, in that a mem_cgroup can remain valid after
a cgroup is destroyed.

If a user tries to rmdir a cgroup when its css refcnt > 0, EBUSY will be
returned.

