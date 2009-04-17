Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbZDQKlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbZDQKlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZDQKll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:41:41 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:8230 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbZDQKlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=CbS6dUdaGJXXlNqZ2nUp/MVpFUMrSb1ISVc9djyk5xIvIcOWasK9VkhScr0MAHK6hI
         pIiPqy2KWckO+2xPMtdxb8hp6hvhYieDMGJ4JGKqfqkz17VWjW1S4kYS2NiLmDlex4qZ
         AtNS16To8hv61x5gUJp1AxqyiueufcPly/1Pc=
Date: Fri, 17 Apr 2009 12:41:35 +0200
From: Andrea Righi <righi.andrea@gmail.com>
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
Message-ID: <20090417104134.GA19872@linux>
Mail-Followup-To: Li Zefan <lizf@cn.fujitsu.com>,
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
	yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-2-git-send-email-righi.andrea@gmail.com> <20090417102417.88a0ef93.kamezawa.hiroyu@jp.fujitsu.com> <49E7E1CF.6060209@cn.fujitsu.com> <20090417102539.GA16838@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417102539.GA16838@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 12:25:40PM +0200, Andrea Righi wrote:
> So, what about implementing the bio-cgroup functionality as cgroup "page
> tracking" infrastructure and provide the following interfaces:
> 
> /*
>  * Encode the cgrp->css.id in page_group->flags

sorry, I meant css_id(struct cgroup_subsys_state *css) here.

>  */
> void set_cgroup_page_owner(struct page *page, struct cgroup *cgrp);
> 
> /*
>  * Returns the cgroup owner of a page, decoding the cgroup id from
>  * page_cgroup->flags.
>  */
> struct cgroup *get_cgroup_page_owner(struct page *page);

Or better, even more generic:

/*
 * Encode id in page_group->flags.
 */
void set_page_id(struct page *page, unsigned short id);

/*
 * Returns the id of a page, decoding it from page_cgroup->flags.
 */
unsigned short get_page_id(struct page *page);

Then we can use css_id() for cgroups, or any kind of ID for other
potential users (dm-ioband, etc.).

-Andrea

> 
> This also wouldn't increase the size of page_cgroup because we can
> encode the cgroup id in the unused bits of page_cgroup->flags, as
> originally suggested by Kame.
> 
> And I think it could be used also by dm-ioband, even if it's not a
> cgroup-based subsystem... but I may be wrong. Ryo what's your opinion?
