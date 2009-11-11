Return-Path: <linux-kernel-owner+w=401wt.eu-S1757153AbZKKPni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbZKKPni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbZKKPnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:43:37 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42189 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbZKKPnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:43:37 -0500
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
CC: ranma+kernel@tdiedrich.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-to: <20091111151937.GC20655@yumi.tdiedrich.de> (message from Tobias
	Diedrich on Wed, 11 Nov 2009 16:19:37 +0100)
Subject: Re: posix_fadvise/WILLNEED synchronous on fuse/sshfs instead of async?
References: <20091111151937.GC20655@yumi.tdiedrich.de>
Message-Id: <E1N8FM6-0007GI-6o@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Nov 2009 16:43:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009, Tobias Diedrich wrote:
> While trying to use posix_fadvise(...POSIX_FADVISE_WILLNEED) to
> implement userspace read-ahead (with a bigger read-ahead window than
> the kernel default) I found that if the underlying filesystem is
> fuse/sshfs posix_fadvise is no longer doing asynchronous reads:
> 
> strace -tt with mnt/testfile on sshfs and server with very slow
> upstream (ADSL):
> 5345  00:00:17.334209 open("mnt/testfile", O_RDONLY|O_LARGEFILE) = 3
> 5345  00:00:18.011383 _llseek(3, 0, [3544379], SEEK_END) = 0
> 5345  00:00:18.011626 _llseek(3, 0, [0], SEEK_SET) = 0
> 5345  00:00:18.012393 fadvise64_64(3, 0, 1048576, POSIX_FADV_WILLNEED) = 0
> 5345  00:01:02.438097 write(1, "[file] File size is 3544379 byte"..., 34) = 34
> 
> Note that fadvise takes 40 seconds...
> Is this expected behaviour?

I think this is because fuse limits the number of outstanding
requests.

In 2.6.31 you can raise these limits in

 /sys/fs/fuse/connections/N/congestion_threshold
 /sys/fs/fuse/connections/N/max_background

Thanks,
Miklos
