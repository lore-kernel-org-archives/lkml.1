Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZFYXbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZFYXbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 19:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZFYXb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 19:31:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53174 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZFYXb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 19:31:28 -0400
Date: Fri, 26 Jun 2009 08:29:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com,
       lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [PATCH 0/2] memcg: cgroup fix rmdir hang
Message-Id: <20090626082956.a90335db.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090625142809.ac6b7b85.akpm@linux-foundation.org>
References: <20090623160720.36230fa2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090625142809.ac6b7b85.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 14:28:09 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 23 Jun 2009 16:07:20 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > previous discussion was this => http://marc.info/?t=124478543600001&r=1&w=2
> > 
> > This patch tries to fix problem as
> >   - rmdir can sleep very very long if swap entry is shared between multiple
> >     cgroups
> > 
> > Now, cgroup's rmdir path does following
> > 
> > ==
> > again:
> > 	check there are no tasks and children group.
> > 	call pre_destroy()
> > 	check css's refcnt
> > 	if (refcnt > 0) {
> > 		sleep until css's refcnt goes down to 0.
> > 		goto again
> > 	}
> > ==
> > 
> > Unfortunately, memory cgroup does following at charge.
> > 
> > 	css_get(&memcg->css)
> > 	....
> > 	charge(memcg) (increase USAGE)
> > 	...
> > And this "memcg" is not necessary to include the caller, task.
> > 
> > pre_destroy() tries to reduce memory usage until USAGE goes down to 0.
> > Then, there is a race that
> > 	- css's refcnt > 0 (and memcg's usage > 0)
> > 	- rmdir() caller sleeps until css->refcnt goes down 0.
> > 	- But to make css->refcnt be 0, pre_destroy() should be called again.
> > 
> > This patch tries to fix this in asyhcnrounos way (i.e. without big lock.)
> > Any comments are welcome.
> > 
> 
> Do you believe that these fixes should be backported into 2.6.30.x?

Yes, I think so. (If it's easy)

To be honest:

To cause the problem,
  - swap cgroup should be shared between cgroup.
  - rmdir should be called in critical chance.

Considering usual usage of cgroup is "container", there will be no share of swap
in typical users. But,  2.6.30 can be a base kernel of a major distro. So,
I hope this in 2.6.30 if we have no difficulties.

Thanks,
-Kame










