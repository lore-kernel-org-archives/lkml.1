Return-Path: <linux-kernel-owner+w=401wt.eu-S1759781AbYFIO6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbYFIO6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbYFIO6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:58:07 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:36917 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbYFIO6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:58:04 -0400
Date: Mon, 9 Jun 2008 16:57:57 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
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
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in
 blk_lookup_devt()/prepare_namespace()
Message-ID: <20080609165757.184724ff@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <19f34abd0806090728s3b3fdbeq7dd3d31d02c8f28e@mail.gmail.com>
References: <20080609080312.GA32458@elte.hu>
	<20080609020623.b6727f2b.akpm@linux-foundation.org>
	<19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com>
	<20080609133426.GB20194@cs181133002.pp.htv.fi>
	<19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com>
	<19f34abd0806090728s3b3fdbeq7dd3d31d02c8f28e@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 16:28:09 +0200,
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> On 6/9/08, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> >  It seems that this list (block_class.devices) is protected by
> >  block_class_lock in block/genhd.c. This list is only ever modified by
> >  device_add() and device_del() in drivers/base/core.c. Both of those
> >  are (only) protected by dev->class->sem, however. Is there a locking
> >  mismatch here? But none of the locking code here seems to be changed
> >  in years...
> 
> I think this seems correct.
> 
> Everywhere else where we traverse the struct class->devices list, they
> have down(&class->sem); first and up(&class->sem); afterwards.
> 
> Commit fd04897bb20be29d60f7e426a053545aebeaa61a even has this hunk:
> @@ -177,8 +177,7 @@ struct class {
>         struct list_head        devices;
>         struct list_head        interfaces;
>         struct kset             class_dirs;
> -       struct semaphore        sem;    /* locks both the children and interface
> -
> +       struct semaphore        sem; /* locks children, devices, interfaces */
>         struct class_attribute          * class_attrs;
>         struct class_device_attribute   * class_dev_attrs;
>         struct device_attribute         * dev_attrs;
> 
> 
> So why doesn't block/genhd.c do this too? It seems to me that the
> mutex locking here is simply a remnant of old code that happened to
> not crash in most cases by chance.
> 

Does this crash happen with the conversion to the class iterator
functions (should be in linux-next) as well? They take the class
mutex...
