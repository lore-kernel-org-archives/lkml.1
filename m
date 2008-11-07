Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbYKGOyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbYKGOyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYKGOyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:54:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43132 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYKGOyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:54:06 -0500
Date: Fri, 7 Nov 2008 09:50:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, Rik van Riel <riel@redhat.com>,
       fernando@oss.ntt.co.jp, Jeff Moyer <jmoyer@redhat.com>,
       menage@google.com, ngupta@google.com,
       Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com
Subject: Re: [patch 3/4] io controller: Core IO controller implementation
	logic
Message-ID: <20081107145036.GF21884@redhat.com>
References: <20081106153022.215696930@redhat.com> <20081106153135.869625751@redhat.com> <20081107122145.69500cd3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107122145.69500cd3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 12:21:45PM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 06 Nov 2008 10:30:25 -0500
> vgoyal@redhat.com wrote:
> 
> > 
> > o Core IO controller implementation
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > 
> 
> 2 comments after a quick look.
> 
>  - I don't recommend generic work queue. More stacked dependency between "work"
>    is not good. (I think disk-driver uses "work" for their jobs.)

Sorry, I did not get this. Are you recommending that don't create a new
work queue, instead use existing work queue (say kblockd) to submit the bios
here?

I will look into it. I was little worried about a kblockd being overworked
in case of too many logical devices enabling IO controller.

> 
>  - It seems this bio-cgroup can queue the bio to infinite. Then, a process can submit
>    io unitl cause OOM.
>    (IIUC, Dirty bit of the page is cleared at submitting I/O. 
>     Then dirty_ratio can't help us.)
>    please add "wait for congestion by sleeping" code in bio-cgroup.

Yes, you are right. I need to put some kind of control on max number of
bios I can queue on a cgroup and after crossing the limit, I should put
the submitting task to sleep. (Something like request descriptor kind of
flow control implememented by elevators).

Thanks
Vivek
