Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbZI1OUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbZI1OUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZI1OUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:20:12 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6783 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZI1OUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:20:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RLohVR+jOlBrxK15Q4pqi4wmVKGPFPZQoSCUvWlzM5rbnB5NdR2Ujom7lVgGuXkJu
	l3eb6haZDZrw5W4ypKQZQ==
MIME-Version: 1.0
In-Reply-To: <20090928181310.9492a8a2.kamezawa.hiroyu@jp.fujitsu.com>
References: <200909252158.n8PLwFhG024011@imap1.linux-foundation.org>
	 <20090928154213.8e873dec.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090928180649.b6b7eea9.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090928181310.9492a8a2.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 28 Sep 2009 07:20:08 -0700
Message-ID: <6599ad830909280720u6f70e52cp33b89c02c7e389fa@mail.gmail.com>
Subject: Re: [PATCH][rc1] cgroup: catch bad css refcnt at css_put
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 2:13 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> This is a patch for checking css->refcnt's sanity at css_put().
>
> BTW, I noticed that...css->refcnt may overflow if used with memcg...
> Now, refcnt is incremented per a page. Paul, do you have any idea ?
> (Ah, yes. "don't use css->refcnt per page" is maybe reasonable but
>  it will be big change..)
>
> ==
> __css_put() doesn't check a bug as refcnt goes to minus.
> I think it should be caught. This patch adds a check for it.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Looks reasonable, although there's no guarantee that it will warn on a
buggy release rather than a correct release that occur after a buggy
release.

> ---
>  kernel/cgroup.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.32-rc1/kernel/cgroup.c
> ===================================================================
> --- linux-2.6.32-rc1.orig/kernel/cgroup.c
> +++ linux-2.6.32-rc1/kernel/cgroup.c
> @@ -3708,8 +3708,10 @@ static void check_for_release(struct cgr
>  void __css_put(struct cgroup_subsys_state *css)
>  {
>        struct cgroup *cgrp = css->cgroup;
> +       int val;
>        rcu_read_lock();
> -       if (atomic_dec_return(&css->refcnt) == 1) {
> +       val = atomic_dec_return(&css->refcnt);
> +       if (val == 1) {
>                if (notify_on_release(cgrp)) {
>                        set_bit(CGRP_RELEASABLE, &cgrp->flags);
>                        check_for_release(cgrp);
> @@ -3717,6 +3719,7 @@ void __css_put(struct cgroup_subsys_stat
>                cgroup_wakeup_rmdir_waiter(cgrp);
>        }
>        rcu_read_unlock();
> +       WARN_ON(val < 1);
>  }
>
>  /*
>
>
