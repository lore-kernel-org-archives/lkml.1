Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYK1Cmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYK1Cmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 21:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYK1Cmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 21:42:37 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57160 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbYK1Cmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 21:42:36 -0500
Date: Fri, 28 Nov 2008 11:41:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       taka@valinux.co.jp
Subject: Re: [RFC][PATCH 1/2] CGROUP ID and Hierarchy Code
Message-Id: <20081128114139.f45c98b4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <492F59A2.3000104@cn.fujitsu.com>
References: <20081127160548.3274c8e6.kamezawa.hiroyu@jp.fujitsu.com>
	<492F4941.2030707@cn.fujitsu.com>
	<20081128103533.049f0b7b.kamezawa.hiroyu@jp.fujitsu.com>
	<20081128111832.b52a6909.kamezawa.hiroyu@jp.fujitsu.com>
	<492F59A2.3000104@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 10:38:26 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Fri, 28 Nov 2008 10:35:33 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> >> On Fri, 28 Nov 2008 09:28:33 +0800
> >> Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >>> I think the safe way is:
> >>>
> >>> rcu_read_lock();
> >>> cgrp = cgroup_get_next()
> >>> if (!inc_not_zero(cgrp) {
> >>> 	rcu_read_unlock();
> >>> 	return NULL;
> >>> }
> >>> rcu_read_unlock();
> >>> return cgrp;
> >>>
> >>> But it's also safe to use cgrp = list_entry(&parent->children.next) for the above
> >>> scenario, seems you don't have to invent this cgroup_get_next().
> >>>
> >> But list-walk can't provide us view of hierarchy. Up-Down list walk is better ?
> >> please see memcg's code. it met some troubles.
> >> I'll make kfree(cgrp) to be called by RCU.
> >>
> > 
> > Ah please, I have a question.
> > Following is right ?
> > 	- until mount, cgroup's subsystem root is tied to dummy? root cgroup.
> 
> Yes.
> 
> > 	- cgroup cannot be unmounted while there are any children.
> 
> No, you can unmount. You can have it a try. :)
> 
I tried and did ;)

> > 	- cgroup_root is freed/allocated at umount/mount, then I have to handle
> 
> No, kill_sb() is called when deactivate_super() decreases sb->s_active to 0, and
> whenever we create a cgroup, sb->s_active is increased, so if there are sub-dirs
> the cgroup_root won't be freed at umount.
> 
Thank you! very helpful. 

So, I should take care ofe only kill_sb() case. 
(it frees pointer of root (and root->topcgroup.) and I have to update it.)

Regards,
-Kame


> > 	  this event in cgroup-id.
> > 	 (maybe current code has leak? in umount.)
> >  
> 
> So I think there is no leak. ;)
> 
> > Thanks,
> > -Kame
> > 
> > 
> > 
> 

