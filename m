Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbYLBAPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbYLBAPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 19:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYLBAOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 19:14:53 -0500
Received: from mga10.intel.com ([192.55.52.92]:49512 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752021AbYLBAOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 19:14:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,698,1220252400"; 
   d="scan'208";a="645964634"
Message-ID: <49347E0C.10106@linux.intel.com>
Date: Tue, 02 Dec 2008 01:15:08 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>, Al Viro <viro@zeniv.linux.org.uk>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG? "Call fasync() functions without the BKL" is racy
References: <20081128192508.GA21369@redhat.com> <4933CBB0.2060003@linux.intel.com> <20081201191555.GA21385@redhat.com>
In-Reply-To: <20081201191555.GA21385@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Perhaps, we can add O_LOCK_FLAGS, then something like
> 
> 	--- a/fs/fcntl.c
> 	+++ b/fs/fcntl.c
> 	@@ -175,6 +175,15 @@ static int setfl(int fd, struct file * f
> 		if (error)
> 			return error;
> 	 
> 	+	spin_lock(&current->files->file_lock);
> 	+	if (!(filp->f_flags & O_LOCK_FLAGS))
> 	+		filp->f_flags |= O_LOCK_FLAGS;
> 	+	else
> 	+		error = -EAGAIN;
> 	+	spin_unlock(&current->files->file_lock);
> 	+	if (error) /* pretend ->f_flags was changed after us */
> 	+		return 0;
> 	+
> 		if ((arg ^ filp->f_flags) & FASYNC) {
> 			if (filp->f_op && filp->f_op->fasync) {
> 				error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
> 	@@ -183,7 +192,8 @@ static int setfl(int fd, struct file * f
> 			}
> 		}
> 	 
> 	-	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
> 	+	filp->f_flags = (arg & SETFL_MASK) |
> 	+			(filp->f_flags & ~(SETFL_MASK | O_LOCK_FLAGS));
> 	  out:
> 		return error;
> 	 }
> 
> What do you think?

Looks reasonable. Just would need to make sure that O_LOCK_FLAGS doesn't
leak out to user space.

-Andi

>
