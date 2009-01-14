Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZANDCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZANDCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 22:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZANDBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 22:01:51 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56811 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZANDBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 22:01:50 -0500
Date: Wed, 14 Jan 2009 12:00:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH 4/4] cgroup-memcg fix frequent EBUSY at rmdir
Message-Id: <20090114120044.2ecf13db.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830901131848gf7f6996iead1276bc50753b8@mail.gmail.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090108183529.b4fd99f4.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901131848gf7f6996iead1276bc50753b8@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 18:48:43 -0800
Paul Menage <menage@google.com> wrote:

> On Thu, Jan 8, 2009 at 1:35 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > +       if (ret == -EAGAIN) { /* subsys asks us to retry later */
> > +               mutex_unlock(&cgroup_mutex);
> > +               cond_resched();
> > +               goto retry;
> > +       }
> 
> This spinning worries me a bit. It might be better to do an
> interruptible sleep until the relevant CSS's refcount goes down to
> zero. 

Hmm, add wait_queue to css and wake it up at css_put() ?

like this ?
==
__css_put()
{
	if (atomi_dec_return(&css->refcnt) == 1) {
		if (notify_on_release(cgrp) {
			.....
		}
		if (someone_waiting_rmdir(css)) {
			wake_up_him().
		}
	}
}
==

> And is there no way that the memory controller can hang on to a
> reference indefinitely, if the cgroup still has some pages charged to
> it?
> 
pre_destroy() is for that.  Now, If there are still references from "page"
after pre_destroy(), it's bug.
swap-in after pre_destory() may add new refs from pages.
(I implemented reference from "swap" to be memcg internal refcnt not to css.)

Allowing Ctrl-C/alarm() here by signal_pending() will be better, anyway.

Thanks,
-Kame

