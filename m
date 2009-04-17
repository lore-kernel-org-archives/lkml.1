Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZDQHWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZDQHWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZDQHWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:22:06 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:48448 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751600AbZDQHWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:22:03 -0400
Date: Fri, 17 Apr 2009 16:22:01 +0900 (JST)
Message-Id: <20090417.162201.183038478.ryov@valinux.co.jp>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: yoshikawa.takuya@oss.ntt.co.jp, righi.andrea@gmail.com, menage@google.com,
       balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, lizf@cn.fujitsu.com, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090417112433.085ed604.kamezawa.hiroyu@jp.fujitsu.com>
References: <1239740480-28125-4-git-send-email-righi.andrea@gmail.com>
	<49E7E037.9080004@oss.ntt.co.jp>
	<20090417112433.085ed604.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 17 Apr 2009 11:24:33 +0900

> On Fri, 17 Apr 2009 10:49:43 +0900
> Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp> wrote:
> 
> > Hi,
> > 
> > I have a few question.
> >    - I have not yet fully understood how your controller are using
> >      bio_cgroup. If my view is wrong please tell me.
> > 
> > o In my view, bio_cgroup's implementation strongly depends on
> >    page_cgoup's. Could you explain for what purpose does this
> >    functionality itself should be implemented as cgroup subsystem?
> >    Using page_cgoup and implementing tracking APIs is not enough?
> 
> I'll definitely do "Nack" to add full bio-cgroup members to page_cgroup.
> Now, page_cgroup is 40bytes(in 64bit arch.) And all of them are allocated at
> boot time as memmap. (and add member to struct page is much harder ;)
> 
> IIUC, feature for "tracking bio" is just necesary for pages for I/O.
> So, I think it's much better to add misc. information to struct bio not to the page.
> But, if people want to add "small hint" to struct page or struct page_cgroup
> for tracking buffered I/O, I'll give you help as much as I can.
> Maybe using "unused bits" in page_cgroup->flags is a choice with no overhead.

In the case where the bio-cgroup data is allocated dynamically,
   - Sometimes quite a large amount of memory get marked dirty.
     In this case it requires more kernel memory than that of the
     current implementation.
   - The operation is expansive due to memory allocations and exclusive
     controls by such as spinlocks.

In the case where the bio-cgroup data is allocated by delayed allocation, 
  - It makes the operation complicated and expensive, because
    sometimes a bio has to be created in the context of other
    processes, such as aio and swap-out operation.

I'd prefer a simple and lightweight implementation. bio-cgroup only
needs 4bytes unlike memory controller. The reason why bio-cgroup chose
this approach is to minimize the overhead.

Thanks,
Ryo Tsuruta
