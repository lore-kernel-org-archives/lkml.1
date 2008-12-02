Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYLBGWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYLBGWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 01:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYLBGWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 01:22:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48403 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYLBGWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 01:22:21 -0500
Date: Tue, 2 Dec 2008 15:21:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] cgroup: fix pre_destroy and semantics of
 css->refcnt
Message-Id: <20081202152129.d795da96.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4934D27B.4020904@cn.fujitsu.com>
References: <20081201145907.e6d63d61.kamezawa.hiroyu@jp.fujitsu.com>
	<20081201150208.6b24506b.kamezawa.hiroyu@jp.fujitsu.com>
	<4934D27B.4020904@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Dec 2008 14:15:23 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > Now, final check of refcnt is done after pre_destroy(), so rmdir() can fail
> > after pre_destroy().
> > memcg set mem->obsolete to be 1 at pre_destroy and this is buggy..
> > 
> > Several ways to fix this can be considered. This is an idea.
> > 
> 
> I don't see what's the difference with css_under_removal() in this patch and
> cgroup_is_removed() which is currently available.
> 
> CGRP_REMOVED flag is set in cgroup_rmdir() when it's confirmed that rmdir can
> be sucessfully performed.
> 
> So mem->obsolete can be replaced with:
> 
> bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
> {
> 	return cgroup_is_removed(mem->css.cgroup);
> }
> 
> Or am I missing something?
> 
Yes.
	1. "cgroup" and "css" object are different object.
	2. css object may not be freed at destroy() (as current memcg does.)

Some of css objects cannot be freed even when there are no tasks because
of reference from some persistent object or temporal refcnt.

Please consider css_under_removal() as a kind of css_tryget() which doesn't
increase any refcnt.

Thanks,
-Kame

