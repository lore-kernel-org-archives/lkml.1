Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYIDW1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYIDW1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 18:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbYIDW1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 18:27:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47014 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbYIDW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 18:27:43 -0400
To: serue@us.ibm.com
CC: miklos@szeredi.hu, ebiederm@xmission.com, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080904184916.GA19328@us.ibm.com> (serue@us.ibm.com)
Subject: Re: unprivileged mounts git tree
References: <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu> <20080903224334.GA726@us.ibm.com> <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu> <20080904132804.GA14709@us.ibm.com> <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu> <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu> <20080904161729.GA26579@us.ibm.com> <E1KbIqL-0003QO-34@pomaz-ex.szeredi.hu> <20080904174851.GA13693@hallyn.com> <E1KbJBO-0003Xz-0G@pomaz-ex.szeredi.hu> <20080904184916.GA19328@us.ibm.com>
Message-Id: <E1KbNHX-0004mH-Fw@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Sep 2008 00:26:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Serge E. Hallyn wrote:
> We still have the original problem.
> 
> When root does
> 
> 	mount -bind /mnt /mnt
> 	mount --make-rshared /mnt
> 	mount --bind -o user=hallyn /mnt /home/hallyn/mnt
> 
> and hallyn does
> 
> 	mount --bind /usr /home/hallyn/mnt/usr
> 
> then the kernel happily propagates the mount to /mnt/usr.

Obviously, and that's exactly what root _instructed_ in the last step.
If it's a security problem, root shouldn't do that.

Your original bug report correctly pointed out the real security
problem:

|  as root:
|  	mmount --bind -o user=500 /home/hallyn/etc/ /home/hallyn/etc/
|  	mount --bind /mnt /mnt
|  	mount --make-rshared /mnt
|  	mount --bind /dev /mnt/dev
| 
|  as hallyn:
|  	mmount --bind /mnt /home/hallyn/etc/mnt
|  	/usr/src/mmount-0.3/mmount --bind mnt/dev mnt/src

Here root does nothing "unsafe", yet the user can get propagation back
into /mnt, due to the fact that a bind mount makes the new mount part
of the old peer group.  This is the security hole that is fixed, and
AFAICS the only security hole related to propagation vs. user mounts.

(I'm going to be offline tomorrow and the weekend, but will hopefully
have email access next week).

Thanks,
Miklos
