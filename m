Return-Path: <linux-kernel-owner+w=401wt.eu-S936093AbXGQVCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936093AbXGQVCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbXGQVCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:02:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:2508 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbXGQVCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=h6PhwBZEunUaYQF+IjU7kkI9Rj1aIU9DM11GxPSP9/UgLR1l3xj2GMF0PNs2bbu7cm2x3/kbx08gXMKILoWwyG5bKq5HJR5FFImJdJIAiMpyyj6WNMWjy8JUv+ZgmS9fTSao8i2++KWgtArRQ16UqovJ48kShDVyyh+4Lxdh8GY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Giacomo Catenazzi <cate@cateee.net>
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
Date: Tue, 17 Jul 2007 23:20:11 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
References: <469D1D5E.8050609@cateee.net>
In-Reply-To: <469D1D5E.8050609@cateee.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707172320.12141.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 17 July 2007, Giacomo Catenazzi wrote:
> Hello,
> 
> last git changes to git give me the following error (repead very quickly):
> 
> sector 14657019, nr/cmr 0/0
> bio f7b59280, biotail f7b59280, buffer 0000000, date 0000000, len 36
> ide_do_rw_disk-bad command: dev hda: type 2, flags 104c8

Heh, I've just finished describing the source of the issue:

http://lkml.org/lkml/2007/7/17/487

ide-disk driver and type 2 (REQ_TYPE_BLOCK_PC) requests don't mix well

Probably some dumb application is sending packet commands without
checking the device type...

> [note: manually copied]
> 
> 
> I tried bisect:
> 
> 
> cate@catee:~/kernel/6,v2.6/linux-2.6$ git bisect log
> # bad: [a5fcaa210626a79465321e344c91a6a7dc3881fa] Merge branch
> 'drm-patches' of
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
> # good: [8f41958bdd577731f7411c9605cfaa9db6766809] Merge
> git://git.infradead.org/battery-2.6
> git-bisect start 'a5fcaa21' '8f41958b'
> # good: [02b2318e07f98a7cdf7089a4457a8d62424aa824] Merge branch 'master'
> of master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6
> git-bisect good 02b2318e07f98a7cdf7089a4457a8d62424aa824
> # good: [f716a425c15ebadf60286cd4fb60d1d6f46e3cf9] [POWERPC] VIOTAPE:
> Use designated initializers for fops member structures.
> git-bisect good f716a425c15ebadf60286cd4fb60d1d6f46e3cf9
> # good: [14dc5249728ff699b1ca4dac01ad416a350a147a] Merge branch
> 'for-linus' of git://git.kernel.dk/data/git/linux-2.6-block
> git-bisect good 14dc5249728ff699b1ca4dac01ad416a350a147a
> # good: [c2dc1ad582196208a2f990eb0230eb922046c684] Merge branch
> 'drm-patches' of
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
> git-bisect good c2dc1ad582196208a2f990eb0230eb922046c684
> # good: [c5e3ae8823693b260ce1f217adca8add1bc0b3de] forcedeth bug fix:
> realtek phy
> git-bisect good c5e3ae8823693b260ce1f217adca8add1bc0b3de
> # good: [70584578ab3e940ac9d7820f268f9adc9884e407] [POWERPC] Check for
> NULL ppc_md.init_IRQ() before calling
> git-bisect good 70584578ab3e940ac9d7820f268f9adc9884e407
> # good: [bf22f6fe2d72b4d7e9035be8ceb340414cf490e3] Merge branch
> 'for-2.6.23' into merge
> git-bisect good bf22f6fe2d72b4d7e9035be8ceb340414cf490e3
> # bad: [f798634d806615bee27d1b83479034087a02aa0f] [SERIAL] SUNHV: Fix
> jerky console on LDOM guests.
> git-bisect bad f798634d806615bee27d1b83479034087a02aa0f
> # bad: [29417b899a77aaba1c060f5e123db4f50006f58a] Make BLK_DEV_BSG
> depend strictly on SCSI=y
> git-bisect bad 29417b899a77aaba1c060f5e123db4f50006f58a
> 
> but last changeset don't compile (and it doesn't seem relevant).

commit 3d6392cfbd7dc11f23058e3493683afab4ac13a3
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Mon Jul 9 12:38:05 2007 +0200

    bsg: support for full generic block layer SG v3

    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

is the guilty one

Thanks,
Bart
