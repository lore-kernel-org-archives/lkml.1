Return-Path: <linux-kernel-owner+w=401wt.eu-S1764745AbYHFLoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764745AbYHFLoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758641AbYHFLno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:43:44 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:36994 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758381AbYHFLnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:43:43 -0400
Date: Wed, 06 Aug 2008 20:43:39 +0900 (JST)
Message-Id: <20080806.204339.76736223.taka@valinux.co.jp>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: ryov@valinux.co.jp, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory subsystem into
 two parts
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080806165421.f76edd47.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080804.175707.104036289.ryov@valinux.co.jp>
	<20080804.175748.189722512.ryov@valinux.co.jp>
	<20080806165421.f76edd47.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > This patch splits the cgroup memory subsystem into two parts.
> > One is for tracking pages to find out the owners. The other is
> > for controlling how much amount of memory should be assigned to
> > each cgroup.
> > 
> > With this patch, you can use the page tracking mechanism even if
> > the memory subsystem is off.
> > 
> > Based on 2.6.27-rc1-mm1
> > Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
> > Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> > 
> 
> Plese CC me or Balbir or Pavel (See Maintainer list) when you try this ;)
> 
> After this patch, the total structure is
> 
>  page <-> page_cgroup <-> bio_cgroup.
>  (multiple bio_cgroup can be attached to page_cgroup)
>
> Does this pointer chain will add
>   - significant performance regression or
>   - new race condtions 
> ?

I don't think it will cause significant performance loss, because
the link between a page and a page_cgroup has already existed, which
the memory resource controller prepared. Bio_cgroup uses this as it is,
and does nothing about this.

And the link between page_cgroup and bio_cgroup isn't protected
by any additional spin-locks, since the associated bio_cgroup is
guaranteed to exist as long as the bio_cgroup owns pages.

I've just noticed that most of overhead comes from the spin-locks
when reclaiming the pages inside mem_cgroups and the spin-locks to
protect the links between pages and page_cgroups.
The latter overhead comes from the policy your team has chosen
that page_cgroup structures are allocated on demand. I still feel
this approach doesn't make any sense because linux kernel tries to
make use of most of the pages as far as it can, so most of them
have to be assigned its related page_cgroup. It would make us happy
if page_cgroups are allocated at the booting time.

> For example, adding a simple function.
> ==
> int get_page_io_id(struct page *)
>  - returns a I/O cgroup ID for this page. If ID is not found, -1 is returned.
>    ID is not guaranteed to be valid value. (ID can be obsolete)
> ==
> And just storing cgroup ID to page_cgroup at page allocation.
> Then, making bio_cgroup independent from page_cgroup and 
> get ID if avialble and avoid too much pointer walking.

I don't think there are any diffrences between a poiter and ID.
I think this ID is just a encoded version of the pointer.

> Thanks,
> -Kame


