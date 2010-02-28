Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936405Ab0B1Ssp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:48:45 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57452 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935375Ab0B1Sso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:48:44 -0500
Date: Sun, 28 Feb 2010 19:48:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] relay: move remove_buf_file inside relay_close_buf
Message-ID: <20100228184843.GK5768@kernel.dk>
References: <1267292137-12930-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267292137-12930-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27 2010, Dmitry Monakhov wrote:
> Currently remove_buf_file callback is called from from kobject
> release method. This result in follow issue:
> # blktrace -d /dev/sda1 -d /dev/sda -o test
> blktrace_setup()
>  dir = create_dir()
>  rchan = relay_open(dir,...)
>  ->create_buf_file_callback
>     buf_file  = debugfs_create_file(dir, )
> 
> Userspace will open buf_file.
> Later we make a decision to stop tracing
> blktrace_down()
>   relay_close(rhcan)  /* just decrement kobj reference  */
>                       /* since it is not zero then callback not called */
>   debugfs_remove(dir) /* FAIL due to non empty dir   */
> 
> Later user space will close the file and file will be deleted,
> but directory still exist.
> user_space_close()
>  ->file_release
>    ->release_buf_file_callback
>      ->debugfs_remove(buf_file)
> 
> In fact this is general issue, blktrace is just one of examples.
> We can not reliably remove parent dir until all users close the
> buf_file.
> 
> We don't have to wait this long. File may be deleted
> inside relay_close_buf().

Thanks, I believe this fixes a long standing problem we've had with
blktrace. You can add my acked-by.

-- 
Jens Axboe

