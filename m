Return-Path: <linux-kernel-owner+w=401wt.eu-S1751054AbZHRVaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbZHRVaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbZHRVaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:30:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbZHRVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:30:08 -0400
Date: Tue, 18 Aug 2009 14:30:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Altobelli <david.altobelli@hp.com>
Cc: david.altobelli@hp.com, linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 2/3] hpilo: add interrupt handler
Message-Id: <20090818143003.4924d26a.akpm@linux-foundation.org>
In-Reply-To: <20090810200005.GB29404@ldl.fc.hp.com>
References: <20090810195735.GA29372@ldl.fc.hp.com>
	<20090810200005.GB29404@ldl.fc.hp.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 14:00:05 -0600
David Altobelli <david.altobelli@hp.com> wrote:

> Add interrupt handler to hpilo.  This is enablement for poll handler, and
> it also simplifies the logic for handling an iLO reset, because now 
> only the interrupt handler needs to look for reset, the file system interfaces
> only need to return failure when a reset has happened.
> 
> Please CC me on any replies.

It would be very helpful if there were comments in hpilo.h which fully
describe the roles of each lock.

>
> ...
>
> @@ -496,27 +491,28 @@ static int ilo_close(struct inode *ip, s
>  	int slot;
>  	struct ccb_data *data;
>  	struct ilo_hwinfo *hw;
> +	unsigned long flags;
>  
>  	slot = iminor(ip) % MAX_CCB;
>  	hw = container_of(ip->i_cdev, struct ilo_hwinfo, cdev);
>  
> -	spin_lock(&hw->alloc_lock);
> -
> -	if (is_device_reset(hw))
> -		ilo_locked_reset(hw);
> +	spin_lock(&hw->open_lock);
>  
>  	if (hw->ccb_alloc[slot]->ccb_cnt == 1) {
>  
>  		data = fp->private_data;
>  
> +		spin_lock_irqsave(&hw->alloc_lock, flags);
> +		hw->ccb_alloc[slot] = NULL;
> +		spin_unlock_irqrestore(&hw->alloc_lock, flags);
> +
>  		ilo_ccb_close(hw->ilo_dev, data);
>  
>  		kfree(data);
> -		hw->ccb_alloc[slot] = NULL;
>  	} else
>  		hw->ccb_alloc[slot]->ccb_cnt--;
>  
> -	spin_unlock(&hw->alloc_lock);
> +	spin_unlock(&hw->open_lock);
>  
>  	return 0;
>  }

Here I'd have expected that alloc_lock would provide the protection for
->ccb_cnt.  But the code doesn't do that - it instead appears to use
->open_lock.

The code doesn't tell us what open_lock's role is intended to be so
this reviewer can't really tell whether or not this was a mistake.


>
> ...
>
> @@ -549,22 +543,31 @@ static int ilo_open(struct inode *ip, st
>  			goto out;
>  		}
>  
> +		data->ccb_cnt = 1;
> +		data->ccb_excl = fp->f_flags & O_EXCL;
> +		data->ilo_hw = hw;
> +		init_waitqueue_head(&data->ccb_waitq);
> +
>  		/* write the ccb to hw */
> +		spin_lock_irqsave(&hw->alloc_lock, flags);
>  		ilo_ccb_open(hw, data, slot);
> +		hw->ccb_alloc[slot] = data;
> +		spin_unlock_irqrestore(&hw->alloc_lock, flags);
>  
>  		/* make sure the channel is functional */
>  		error = ilo_ccb_verify(hw, data);
>  		if (error) {
> +
> +			spin_lock_irqsave(&hw->alloc_lock, flags);
> +			hw->ccb_alloc[slot] = NULL;
> +			spin_unlock_irqrestore(&hw->alloc_lock, flags);
> +
>  			ilo_ccb_close(hw->ilo_dev, data);
> +
>  			kfree(data);
>  			goto out;
>  		}
>  
> -		data->ccb_cnt = 1;
> -		data->ccb_excl = fp->f_flags & O_EXCL;
> -		data->ilo_hw = hw;
> -		hw->ccb_alloc[slot] = data;
> -
>  	} else {
>  		kfree(data);
>  		if (fp->f_flags & O_EXCL || hw->ccb_alloc[slot]->ccb_excl) {
> @@ -580,7 +583,7 @@ static int ilo_open(struct inode *ip, st
>  		}
>  	}
>  out:
> -	spin_unlock(&hw->alloc_lock);
> +	spin_unlock(&hw->open_lock);
>  
>  	if (!error)
>  		fp->private_data = hw->ccb_alloc[slot];
> @@ -596,6 +599,41 @@ static const struct file_operations ilo_
>  	.release 	= ilo_close,
>  };

>From this function I infer that the designed lock nesting is

	open_lock
	->alloc_lock
	  ->fifo_lock

yes?  It would be useful to document that also.

Have these changes been runtime tested with lockdep enabled?

>
> ...
>

