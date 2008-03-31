Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYCaAEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYCaAEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 20:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYCaAEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 20:04:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58231 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752650AbYCaAEK (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 20:04:10 -0400
Date: Mon, 31 Mar 2008 10:00:57 +1000
From: David Chinner <dgc@sgi.com>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: David Chinner <dgc@sgi.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] Add timeout feature
Message-ID: <20080331000057.GI108924158@sgi.com>
References: <20080328180736t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328180736t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 06:07:36PM +0900, Takashi Sato wrote:
> The timeout feature is added to freeze ioctl.  And new ioctl
> to reset the timeout period is added.
> o Freeze the filesystem
>   int ioctl(int fd, int FIFREEZE, long *timeval)
>   fd: The file descriptor of the mountpoint
>   FIFREEZE: request code for the freeze
>   timeval: the timeout period in seconds
>            If it's 0 or 1, the timeout isn't set.
>            This special case of "1" is implemented to keep
>            the compatibility with XFS applications.
>   Return value: 0 if the operation succeeds. Otherwise, -1

The timeout is not for the freeze operation - the timeout is
only set up once the freeze is complete. i.e:

$ time sudo ~/test_src/xfs_io -f -x -c 'gfreeze 10' /mnt/scratch/test
freezing with level = 10

real    0m23.204s
user    0m0.008s
sys     0m0.012s

The freeze takes 23s, and then the 10s timeout is started. So
this timeout does not protect against freeze_bdev() hangs at all.
All it does is introduce silent unfreezing of the block device that
can not be synchronised with the application that is operating
on the frozen device.

FWIW, resetting this timeout from userspace is unreliable - there's
no guarantee that under load your userspace process will get to run
again inside the timeout to reset it, hence leaving you with a
unfrozen filesystem when you really want it frozen...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
