Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYD2Dv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYD2Dv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYD2DvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:51:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723AbYD2DvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:51:16 -0400
Date: Mon, 28 Apr 2008 20:51:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 007 of 9] md: prevent duplicates in bind_rdev_to_array
Message-Id: <20080428205108.874eb9e3.akpm@linux-foundation.org>
In-Reply-To: <1080429033527.20385@suse.de>
References: <20080429133104.20146.patches@notabene>
	<1080429033527.20385@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 13:35:27 +1000 NeilBrown <neilb@suse.de> wrote:

> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Found when trying to reassemble an active externally managed array.
> Without this check we hit the more noisy "sysfs duplicate" warning in
> the later call to kobject_add.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./drivers/md/md.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff .prev/drivers/md/md.c ./drivers/md/md.c
> --- .prev/drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
> +++ ./drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
> @@ -1369,6 +1369,11 @@ static int bind_rdev_to_array(mdk_rdev_t
>  		MD_BUG();
>  		return -EINVAL;
>  	}
> +
> +	/* prevent duplicates */
> +	if (find_rdev(mddev, rdev->bdev->bd_dev))
> +		return -EEXIST;
> +
>  	/* make sure rdev->size exceeds mddev->size */
>  	if (rdev->size && (mddev->size == 0 || rdev->size < mddev->size)) {
>  		if (mddev->pers) {

Smells racy.  Do we have enough locking in place here to make this more
than a best-effort thing?
