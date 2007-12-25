Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047AbXLYWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbXLYWFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 17:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXLYWEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 17:04:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbXLYWEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 17:04:48 -0500
Date: Tue, 25 Dec 2007 14:04:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 004 of 7] md: Allow devices to be shared between md
 arrays.
Message-Id: <20071225140405.550369cd.akpm@linux-foundation.org>
In-Reply-To: <1071214062628.1872@suse.de>
References: <20071214171950.1308.patches@notabene>
	<1071214062628.1872@suse.de>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 17:26:28 +1100 NeilBrown <neilb@suse.de> wrote:

> +		mddev_unlock(rdev->mddev);
> +		ITERATE_MDDEV(mddev, tmp) {
> +			mdk_rdev_t *rdev2;
> +
> +			mddev_lock(mddev);
> +			ITERATE_RDEV(mddev, rdev2, tmp2)
> +				if (test_bit(AllReserved, &rdev2->flags) ||
> +				    (rdev->bdev == rdev2->bdev &&
> +				     rdev != rdev2 &&
> +				     overlaps(rdev->data_offset, rdev->size,
> +					    rdev2->data_offset, rdev2->size))) {
> +					overlap = 1;
> +					break;
> +				}
> +			mddev_unlock(mddev);
> +			if (overlap) {
> +				mddev_put(mddev);
> +				break;
> +			}
> +		}

eww, ITERATE_MDDEV() and ITERATE_RDEV() are an eyesore.

for_each_mddev() and for_each_rdev() would at least mean the reader doesn't
need to check the implementation when wondering what that `break' is
breaking from.

>  #define	In_sync		2		/* device is in_sync with rest of array */
>  #define	WriteMostly	4		/* Avoid reading if at all possible */
>  #define	BarriersNotsupp	5		/* BIO_RW_BARRIER is not supported */
> +#define	AllReserved	6		/* If whole device is reserved for

The naming style here is inconsistent.

A task for the keen would be to convert these to an enum and add some
namespacing prefix to them.  
