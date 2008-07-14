Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYGNLm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYGNLm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 07:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYGNLmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 07:42:51 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:7750 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYGNLmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 07:42:50 -0400
Date: Mon, 14 Jul 2008 13:42:28 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg K-H <greg@kroah.com>
Subject: Re: [PATCH] block: fix block_class iteration locking
Message-ID: <20080714134228.1079c6f7@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <487AECD0.5010602@kernel.org>
References: <487AECD0.5010602@kernel.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 15:06:08 +0900,
Tejun Heo <tj@kernel.org> wrote:

> genhd.c used block_class_lock when it wants to iterate over
> block_class.devices list.  This is incorrect as block_class_lock has
> nothing to do with synchronization around block_class.devices list, so
> there's a window, albeit small, where the list can change while it's
> being iterated over.  Fix it by using block_class.sem instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Greg has some patches sitting in his tree that convert those functions
to use class_{for_each,find}_device() instead - and that looks like the
clean solution, especially since the class implementation details will
be moved into a private structure. One worry though...


> @@ -285,7 +285,7 @@ static void *part_start(struct seq_file *part, loff_t *pos)
>  	loff_t k = *pos;
>  	struct device *dev;
> 
> -	mutex_lock(&block_class_lock);
> +	down(&block_class.sem);
>  	list_for_each_entry(dev, &block_class.devices, node) {
>  		if (dev->type != &disk_type)
>  			continue;
> @@ -311,7 +311,7 @@ static void *part_next(struct seq_file *part, void *v, loff_t *pos)
> 
>  static void part_stop(struct seq_file *part, void *v)
>  {
> -	mutex_unlock(&block_class_lock);
> +	up(&block_class.sem);
>  }
> 
>  static int show_partition(struct seq_file *part, void *v)
> @@ -533,7 +533,7 @@ static void *diskstats_start(struct seq_file *part, loff_t *pos)
>  	loff_t k = *pos;
>  	struct device *dev;
> 
> -	mutex_lock(&block_class_lock);
> +	down(&block_class.sem);
>  	list_for_each_entry(dev, &block_class.devices, node) {
>  		if (dev->type != &disk_type)
>  			continue;
> @@ -560,7 +560,7 @@ static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
> 
>  static void diskstats_stop(struct seq_file *part, void *v)
>  {
> -	mutex_unlock(&block_class_lock);
> +	up(&block_class.sem);
>  }
> 
>  static int diskstats_show(struct seq_file *s, void *v)

With your patch, you protect against adding/removing devices to/from
the class between _start and _stop. This wasn't done previously, and
won't be done with Greg's patches (which leaves in the
locking/unlocking of block_class_lock). Not sure if I'm missing
something here...
