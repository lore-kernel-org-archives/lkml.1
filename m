Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbYFIPJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbYFIPJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYFIPJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:09:34 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:24384 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYFIPJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bn3NJH6NquMs5eKlk27ZWPgYG7iN4q9sqwsV3BkO+jQv1fjFFfAAJVIkFTxNF/yeby
         CamuMukqKhqe0EJNEES7ZUkPDkNzW8bhKxuuSzErWpamuZr0/X5uExkk+QXbkJs4sAvJ
         ItBdkhcphWa5JX585Dy+aLhwSACgXDPJI+iuQ=
Message-ID: <19f34abd0806090809h6d864fbahc10d41c0aacbfa08@mail.gmail.com>
Date: Mon, 9 Jun 2008 17:09:29 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in blk_lookup_devt()/prepare_namespace()
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Kay Sievers" <kay.sievers@vrfy.org>,
       "Neil Brown" <neilb@suse.de>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Dave Young" <hidave.darkstar@gmail.com>
In-Reply-To: <20080609165757.184724ff@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080609080312.GA32458@elte.hu>
	 <20080609020623.b6727f2b.akpm@linux-foundation.org>
	 <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com>
	 <20080609133426.GB20194@cs181133002.pp.htv.fi>
	 <19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com>
	 <19f34abd0806090728s3b3fdbeq7dd3d31d02c8f28e@mail.gmail.com>
	 <20080609165757.184724ff@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/08, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Mon, 9 Jun 2008 16:28:09 +0200,
>
> "Vegard Nossum" <vegard.nossum@gmail.com> wrote:
>  > Everywhere else where we traverse the struct class->devices list, they
>  > have down(&class->sem); first and up(&class->sem); afterwards.
>  >
>  > Commit fd04897bb20be29d60f7e426a053545aebeaa61a even has this hunk:
>  > @@ -177,8 +177,7 @@ struct class {
>  >         struct list_head        devices;
>  >         struct list_head        interfaces;
>  >         struct kset             class_dirs;
>  > -       struct semaphore        sem;    /* locks both the children and interface
>  > -
>  > +       struct semaphore        sem; /* locks children, devices, interfaces */
>  >         struct class_attribute          * class_attrs;
>  >         struct class_device_attribute   * class_dev_attrs;
>  >         struct device_attribute         * dev_attrs;
>  >
>  >
>  > So why doesn't block/genhd.c do this too? It seems to me that the
>  > mutex locking here is simply a remnant of old code that happened to
>  > not crash in most cases by chance.
>  >
>
>
> Does this crash happen with the conversion to the class iterator
>  functions (should be in linux-next) as well? They take the class
>  mutex...

Ah, you mean this:

commit bb7ee70edb8745021c17ab604f2f4c897004e1c5
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Thu May 22 17:21:08 2008 -0400

    block: make blk_lookup_devt use the class iterator function

    Use the proper class iterator function instead of mucking around in the
    internals of the class structures.

    Cc: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

So it should already be fixed, then. But I guess we'll have to wait
for Ingo to run another couple of thousand tests to know the answer
;-)

Thanks!

Hm. Bugs already fixed elsewhere seems to be a recurring theme... I'll
look harder for changes/fixes in other trees the next time :-(


Vegard

PS: But what about printk_all_partitions()? There are more than just
this instance of the device list traversal code that don't use the
class semaphore.

PPS: Was that patch ever posted to LKML? I couldn't seem to find it.

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
