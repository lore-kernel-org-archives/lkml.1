Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbXE2QN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbXE2QN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbXE2QNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:13:18 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:13132 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXE2QNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:13:16 -0400
Date: Tue, 29 May 2007 18:13:15 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, dmitry.torokhov@gmail.com, oneukum@suse.de,
       rpurdie@rpsys.net, stern@rowland.harvard.edu, maneesh@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sysfs: slim down sysfs_dirent->s_active
Message-ID: <20070529181315.37e31832@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11803694463144-git-send-email-htejun@gmail.com>
References: <118036944617-git-send-email-htejun@gmail.com>
	<11803694463144-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 01:24:06 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Make sysfs_dirent->s_active an atomic_t instead of rwsem.  This
> reduces the size of sysfs_dirent from 136 to 104 on 64bit and from 76
> to 60 on 32bit with lock debugging turned off.  With lock debugging
> turned on the reduction is much larger.

Cool.

> s_active starts at zero and each active reference increments s_active.
> Putting a reference decrements s_active.  Deactivation subtracts
> SD_DEACTIVATED_BIAS which is currently INT_MIN and assumed to be small
> enough to make s_active negative.  If s_active is negative,
> sysfs_get() no longer grants new references.  Deactivation succeeds
> immediately if there is no active user; otherwise, it waits using a
> completion for the last put.
> 
> Due to the removal of lockdep tricks, this change makes things less
> trickier in release_sysfs_dirent().  As all the complexity is
> contained in three s_active functions, I think it's more readable this
> way.

Agreed.


> @@ -32,11 +33,24 @@ static DEFINE_IDA(sysfs_ino_ida);
>   */
>  struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
>  {
> -	if (sd) {
> -		if (unlikely(!down_read_trylock(&sd->s_active)))
> -			sd = NULL;
> +	if (unlikely(!sd))
> +		return NULL;
> +
> +	while (1) {
> +		int v, t;
> +
> +		v = atomic_read(&sd->s_active);
> +		if (unlikely(v < 0))
> +			return NULL;
> +
> +		t = atomic_cmpxchg(&sd->s_active, v, v + 1);
> +		if (likely(t == v))
> +			return sd;
> +		if (t < 0)
> +			return NULL;
> +
> +		cpu_relax();
>  	}
> -	return sd;
>  }

I don't quite like v and t, but don't have a better naming suggestion
either.
