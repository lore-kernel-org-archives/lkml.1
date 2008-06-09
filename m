Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbYFIO21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbYFIO21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYFIO2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:28:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:64173 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbYFIO2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lR6RB0zIRUwr5ejJ7vnay5G8XYmB9WQWr5xyoubZKe9hUketrWXG9BlRwz9H/Q8c0L
         +iPlLU0Z1pIaNVjA75yv3A5hLSm9I+4qo1XquNF0012lxc0m6N9ROaaQWYpouaxFJ65M
         whqX2cLl/R3RbG+wgwiobf2cM2RlT21mwh8vw=
Message-ID: <19f34abd0806090728s3b3fdbeq7dd3d31d02c8f28e@mail.gmail.com>
Date: Mon, 9 Jun 2008 16:28:09 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in blk_lookup_devt()/prepare_namespace()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Kay Sievers" <kay.sievers@vrfy.org>,
       "Neil Brown" <neilb@suse.de>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Dave Young" <hidave.darkstar@gmail.com>,
       "Cornelia Huck" <cornelia.huck@de.ibm.com>
In-Reply-To: <19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080609080312.GA32458@elte.hu>
	 <20080609020623.b6727f2b.akpm@linux-foundation.org>
	 <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com>
	 <20080609133426.GB20194@cs181133002.pp.htv.fi>
	 <19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/08, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>  It seems that this list (block_class.devices) is protected by
>  block_class_lock in block/genhd.c. This list is only ever modified by
>  device_add() and device_del() in drivers/base/core.c. Both of those
>  are (only) protected by dev->class->sem, however. Is there a locking
>  mismatch here? But none of the locking code here seems to be changed
>  in years...

I think this seems correct.

Everywhere else where we traverse the struct class->devices list, they
have down(&class->sem); first and up(&class->sem); afterwards.

Commit fd04897bb20be29d60f7e426a053545aebeaa61a even has this hunk:
@@ -177,8 +177,7 @@ struct class {
        struct list_head        devices;
        struct list_head        interfaces;
        struct kset             class_dirs;
-       struct semaphore        sem;    /* locks both the children and interface
-
+       struct semaphore        sem; /* locks children, devices, interfaces */
        struct class_attribute          * class_attrs;
        struct class_device_attribute   * class_dev_attrs;
        struct device_attribute         * dev_attrs;


So why doesn't block/genhd.c do this too? It seems to me that the
mutex locking here is simply a remnant of old code that happened to
not crash in most cases by chance.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
