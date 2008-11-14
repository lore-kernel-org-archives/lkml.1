Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbYKNIDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbYKNIDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYKNIDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:03:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52782 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbYKNIDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:03:11 -0500
Subject: RE: [patch 0/4] [RFC] Another proportional weight IO controller
From: Peter Zijlstra <peterz@infradead.org>
To: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
Cc: "'Vivek Goyal'" <vgoyal@redhat.com>,
       "'Nauman Rafique'" <nauman@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       "'Hirokazu Takahashi'" <taka@valinux.co.jp>,
       "'Ryo Tsuruta'" <ryov@valinux.co.jp>,
       "'Andrea Righi'" <righi.andrea@gmail.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com,
       "'Andrew Morton'" <akpm@linux-foundation.org>, menage@google.com,
       ngupta@google.com, "'Rik van Riel'" <riel@redhat.com>,
       "'Jeff Moyer'" <jmoyer@redhat.com>, dpshah@google.com,
       "'Mike Waychison'" <mikew@google.com>, rohitseth@google.com,
       "'Fabio Checconi'" <fchecconi@gmail.com>, paolo.valente@unimore.it
In-Reply-To: <002c01c94615$99061520$cb123f60$@jp.nec.com>
References: <20081106163957.GB7461@redhat.com>
	 <1225990327.7803.4776.camel@twins> <20081106170830.GD7461@redhat.com>
	 <e98e18940811061507t3e19183byf2b8b291458ba81b@mail.gmail.com>
	 <20081107141943.GC21884@redhat.com>
	 <e98e18940811071336n58a073d8w2cbaeddd5657d1e9@mail.gmail.com>
	 <20081110141143.GC26956@redhat.com>
	 <e98e18940811111155q4bd73480pebe088fa1adbe2e4@mail.gmail.com>
	 <20081111223024.GA31527@redhat.com>
	 <e98e18940811121320w5f321302n13b526887cbb4012@mail.gmail.com>
	 <20081113180821.GF7542@redhat.com>
	 <002c01c94615$99061520$cb123f60$@jp.nec.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Nov 2008 09:02:15 +0100
Message-Id: <1226649735.7685.6917.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 13:58 +0900, Satoshi UCHIDA wrote:

> > I think Satoshi's cfq controller patches also do not seem to be considering
> > A, B, C, D and E to be at same level, instead it treats cgroup "/" , D and
> > E
> > at same level and tries to do proportional BW division among these.
> > Satoshi, please correct me, if that's not the case.
> > 
> 
> Yes.
> I think that a controller should be divided share among "/(root)" and two groups.
> This reason is follows:
> 
>   * If these tasks are handled at same level, it is enough by using a traditional 
>     CFQ scheduler.
>     If you want to make all tasks in the same group the same priority(parameter),
>     It is not I/O control but is parameter control.
>     
>   * I think that the group means the environment which makes some sense and 
>     user want to control I/O per groups.
>     Next, the group is the environment.  So, tasks within the group will have
>     priorities for themselves respectively as traditional environment.
>     Of course, group may not be need to control I/O.
>     In such time, a ioprio of tasks should be set the same priority.
> 
> Therefore, our scheduler controls among group and then among tasks

I would suggest abandoning this scheme as its different from how the CPU
scheduler does it. The CPU scheduler is fully hierarchical and tasks in
"/" are on the same level as groups in "/".

That is, we do:

      root
      / | \
     1  2  A
          / \
         B   3
        / \
       4   5

Where digits are tasks, and letters are groups.

Having the two bandwidth (CPU, I/O) doing different things wrt grouping
can only be confusing at best.


