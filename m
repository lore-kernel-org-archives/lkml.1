Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966151Ab0BZU5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:57:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966127Ab0BZU5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:57:30 -0500
Date: Fri, 26 Feb 2010 15:57:21 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: device-mapper development <dm-devel@redhat.com>
cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: How to unload a module? (Was: [dm-devel] rqdm: bad usage of
 dm_get/dm_put)
In-Reply-To: <4B862103.1040802@ct.jp.nec.com>
Message-ID: <Pine.LNX.4.64.1002261535260.6754@hs20-bc2-1.build.redhat.com>
References: <20100219163257.186977438@kvm.kroah.org> <4B815A3D.9040402@canonical.com>
 <4B825982.3060606@ct.jp.nec.com> <20100223175331.GE560@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1002231429210.29863@hs20-bc2-1.build.redhat.com>
 <4B84E05C.4070300@ct.jp.nec.com> <Pine.LNX.4.64.1002241732300.2537@hs20-bc2-1.build.redhat.com>
 <4B862103.1040802@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Feb 2010, Kiyoshi Ueda wrote:

> Hi Mikulas,
> 
> On 02/25/2010 07:33 AM +0900, Mikulas Patocka wrote:
> >> Indeed, we shouldn't use the current dm_put() in any interrupt-context.
> >> But the "mapped_device" can disappear in request-based dm while there
> >> is a request after all bios complete, so I used dm_get()/dm_put() there.
> >> I'll consider another way to prevent the problem without dm_get()/dm_put().
> >> E.g. wait for request completion in dm_put() instead.
> > 
> > How can a request-in-progress exists when all the bios complete and the 
> > device is closed?
> 
> In the current request-based dm, the device opener can remove
> the mapped_device while the last request is still completing,
> because bios in the last request complete first and then the device
> opener can remove the mapped_device before the last request completes:
>  CPU0                                           CPU1
>  ======================================================================
>  <<INTERRUPT>>
>  blk_end_request_all(clone_rq)
>    blk_update_request(clone_rq)
>      bio_endio(clone_bio) == end_clone_bio
>        blk_update_request(orig_rq)
>          bio_endio(orig_bio)
>                                                 <<I/O completed>>
>                                                 dm_blk_close()
>                                                 dev_remove()
>                                                   dm_put(md)
>                                                     <<Free md>>
>    blk_finish_request(clone_rq)
>      ....
>      dm_end_request(clone_rq)
>        free_rq_clone(clone_rq)
>        blk_end_request_all(orig_rq)
>        rq_completed(md)
> 
> So we need a mechanism to defer the md deletion until the last request
> completes.
> 
> Thanks,
> Kiyoshi Ueda

Good point ... but I think this problem may happen even in normal 
non-request based dm.

I don't know what to do with it.

If one thread does:
- bio_endio
				and another thread does:
				- close the device
				- remove the device
				- unload module
- then the first thread, after bio_endio, executes non-existing 
instructions from unloaded module.

Any ideas, how is it solved or how it should be solved?

Module unloading does stop_machine, but AFAIK it waits for all CPUs to 
exit non-preemtable sections, it doesn't wait for the code to get out of 
disk request routine...

Mikulas
