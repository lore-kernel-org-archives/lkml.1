Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZG1PBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZG1PBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZG1PBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:01:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42269 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbZG1PBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:01:40 -0400
Date: Tue, 28 Jul 2009 16:58:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: fix set_binfmt() vs sys_delete_module() race
Message-ID: <20090728145817.GB6664@redhat.com>
References: <20090724171943.GA10778@redhat.com> <20090728071949.GD6036@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728071949.GD6036@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Amerigo Wang wrote:
>
> On Fri, Jul 24, 2009 at 07:19:43PM +0200, Oleg Nesterov wrote:
> >sys_delete_module() can set MODULE_STATE_GOING after search_binary_handler()
> >does try_module_get(). In this case set_binfmt()->try_module_get() fails but
> >since none of the callers check the returned error, the task will run with
> >the wrong old ->binfmt.
> >
> >The proper fix should change all ->load_binary() methods, but we can rely
> >on fact that the caller must hold a reference to binfmt->module and use
> >__module_get() which never fails.
> >
>
> Sounds reasonable.
>
> Would like to put the last words as comments into code below?

Yes, thanks.

Rusty pointed out this too, and I already sent the updated patch.
But due to my mistake (I forgot to CC lkml) this was discussed
off-list.

> >-int set_binfmt(struct linux_binfmt *new)
> >+void set_binfmt(struct linux_binfmt *new)
> > {
> >-	struct linux_binfmt *old = current->binfmt;
> >+	if (current->binfmt)
> >+		module_put(current->binfmt->module);
> >
> >-	if (new) {
> >-		if (!try_module_get(new->module))
> >-			return -1;
> >-	}
> > 	current->binfmt = new;
> >-	if (old)
> >-		module_put(old->module);
> >-	return 0;
> >+	if (new)
> >+		__module_get(new->module);
>
>
> I prefer to put the 'current->binfmt = new;' line as the last
> statement within this function, since this is more readable for me.

Perhaps... but this is purely cosmetic, and the patch is already
in -mm. Unless you have a strong feeleing, I'd prefer to not send
yet another update.

Oleg.

