Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZFDIk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZFDIk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZFDIku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:40:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54183 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZFDIkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:40:49 -0400
Date: Thu, 4 Jun 2009 17:39:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] remove memory.limit v.s. memsw.limit comparison.
Message-Id: <20090604173918.3b2c68f5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090604083110.GD7504@balbir.in.ibm.com>
References: <20090604141043.9a1064fd.kamezawa.hiroyu@jp.fujitsu.com>
	<20090604083110.GD7504@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 16:31:10 +0800
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-06-04 14:10:43]:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Removes memory.limit < memsw.limit at setting limit check completely.
> > 
> > The limitation "memory.limit <= memsw.limit" was added just because
> > it seems sane ...if memory.limit > memsw.limit, only memsw.limit works.
> > 
> > But To implement this limitation, we needed to use private mutex and make
> > the code a bit complated.
> > As Nishimura pointed out, in real world, there are people who only want
> > to use memsw.limit.
> > 
> > Then, this patch removes the check. user-land library or middleware can check
> > this in userland easily if this really concerns.
> > 
> > And this is a good change to charge-and-reclaim.
> > 
> > Now, memory.limit is always checked before memsw.limit
> > and it may do swap-out. But, if memory.limit == memsw.limit, swap-out is
> > finally no help and hits memsw.limit again. So, let's allow the condition
> > memory.limit > memsw.limit. Then we can skip unnecesary swap-out.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> We can't change behaviour this way without breaking userspace scripts,
> API and code. What does it mean for people already using these
> features? Does it break their workflow?
> 

Hopefully no breaks to current users's workflow.
Because this just has influences to "error path" like below

 echo 200M > memory.memsw.limit
 echo 300M > memory.limit
 => ERROR

If the user program made in sane way, above case will never happens because
they set memsw.limit to be greater than memory.limit and above is treated as error.


Thanks,
-Kame


