Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbZI2Avm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbZI2Avm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZI2Avk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:51:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753694AbZI2Avj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:51:39 -0400
Message-ID: <4AC159D9.8020900@cn.fujitsu.com>
Date: Tue, 29 Sep 2009 08:50:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: Re: [PATCH][rc1] cgroup: catch bad css refcnt at css_put
References: <200909252158.n8PLwFhG024011@imap1.linux-foundation.org>	<20090928154213.8e873dec.kamezawa.hiroyu@jp.fujitsu.com>	<20090928180649.b6b7eea9.kamezawa.hiroyu@jp.fujitsu.com> <20090928181310.9492a8a2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090928181310.9492a8a2.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> This is a patch for checking css->refcnt's sanity at css_put().
> 
> BTW, I noticed that...css->refcnt may overflow if used with memcg...
> Now, refcnt is incremented per a page. Paul, do you have any idea ?

atomic64_t ?

But for 4K pagesize, it won't overflow until when the referenced
memory is > 8T?

> (Ah, yes. "don't use css->refcnt per page" is maybe reasonable but
>  it will be big change..)
> 
> ==
> __css_put() doesn't check a bug as refcnt goes to minus.
> I think it should be caught. This patch adds a check for it.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
>  kernel/cgroup.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.32-rc1/kernel/cgroup.c
> ===================================================================
> --- linux-2.6.32-rc1.orig/kernel/cgroup.c
> +++ linux-2.6.32-rc1/kernel/cgroup.c
> @@ -3708,8 +3708,10 @@ static void check_for_release(struct cgr
>  void __css_put(struct cgroup_subsys_state *css)
>  {
>  	struct cgroup *cgrp = css->cgroup;
> +	int val;
>  	rcu_read_lock();
> -	if (atomic_dec_return(&css->refcnt) == 1) {
> +	val = atomic_dec_return(&css->refcnt);
> +	if (val == 1) {
>  		if (notify_on_release(cgrp)) {
>  			set_bit(CGRP_RELEASABLE, &cgrp->flags);
>  			check_for_release(cgrp);
> @@ -3717,6 +3719,7 @@ void __css_put(struct cgroup_subsys_stat
>  		cgroup_wakeup_rmdir_waiter(cgrp);
>  	}
>  	rcu_read_unlock();
> +	WARN_ON(val < 1);

When we run into this, it'll probably fill up the syslog quickly,
so I think WARN_ON_ONCE() is a bit better.

>  }
>  
