Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab0BORBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 12:01:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697Ab0BORBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:01:37 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2]  cfq: reorder cfq_queue removing padding on 64bit & allowing more objects/slab in it's kmem_cache
References: <1266243036.2149.21.camel@localhost>
	<20100215141626.GB5355@redhat.com> <1266251188.7362.3.camel@localhost>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 15 Feb 2010 12:01:18 -0500
In-Reply-To: <1266251188.7362.3.camel@localhost> (Richard Kennedy's message of
	"Mon, 15 Feb 2010 16:26:28 +0000")
Message-ID: <x49eikmph5t.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy <richard@rsk.demon.co.uk> writes:

> This removes 8 bytes of padding from struct cfq_queue on 64 bit builds,
> shrinking it's size to 256 bytes, so fitting into 1 fewer cachelines and
> allowing 1 more object/slab in it's kmem_cache.

OK, I ran pahole to verify your findings:

$ pahole -C cfq_queue build/master/block/cfq-iosched.o 
struct cfq_queue {
...
         unsigned int               allocated_slice;      /*   136     4  */

         /* XXX 4 bytes hole, try to pack */

         long unsigned int          slice_start;          /*   144     8  */

...
        pid_t                      pid;                  /*   216     4   */

        /* XXX 4 bytes hole, try to pack */

        struct cfq_rb_root *       service_tree;         /*   224     8   */

...
        /* size: 264, cachelines: 5, members: 34 */
        /* sum members: 256, holes: 2, sum holes: 8 */
        /* last cacheline: 8 bytes */

After applying the patch, it indeed does save a cacheline.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
