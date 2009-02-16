Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbZBPCrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbZBPCrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 21:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZBPCqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 21:46:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57849 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbZBPCqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 21:46:51 -0500
Message-ID: <4998D3A6.9010406@cn.fujitsu.com>
Date: Mon, 16 Feb 2009 10:47:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, gregkh@ZenIV.linux.org.uk,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [cgroup or VFS ?] WARNING: at fs/namespace.c:636	mntput_no_expire+0xac/0xf2()
References: <4993C2A0.3050507@cn.fujitsu.com> <4993C7C2.4060100@cn.fujitsu.com> <20090212070729.GF28946@ZenIV.linux.org.uk> <4995007D.7040101@cn.fujitsu.com> <20090213054751.GI28946@ZenIV.linux.org.uk> <49950F3D.3030704@cn.fujitsu.com> <20090213064135.GJ28946@ZenIV.linux.org.uk> <20090213071816.GK28946@ZenIV.linux.org.uk> <4995208D.8050700@cn.fujitsu.com> <4998C15C.2070203@cn.fujitsu.com> <20090216023812.GT28946@ZenIV.linux.org.uk>
In-Reply-To: <20090216023812.GT28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK...  So here's what we really want:
> 	* we know that nobody will set cpu_writer->mnt to mnt from now on
> 	* all changes to that sucker are done under cpu_writer->lock
> 	* we want the laziest equivalent of
> 		spin_lock(&cpu_writer->lock);
> 		if (likely(cpu_writer->mnt != mnt)) {
> 			spin_unlock(&cpu_writer->lock);
> 			continue;
> 		}
> 		/* do stuff */
> that would make sure we won't miss earlier setting of ->mnt done by another
> CPU.
> 

If this is done, I'll be available to test it.

> Anyway, for now (HEAD and all -stable starting with 2.6.26) we want this:
> 

And here is my:

Tested-by: Li Zefan <lizf@cn.fujitsu.com>

> --- fs/namespace.c	2009-01-25 21:45:31.000000000 -0500
> +++ fs/namespace.c	2009-02-15 21:31:14.000000000 -0500
> @@ -614,9 +614,11 @@
>  	 */
>  	for_each_possible_cpu(cpu) {
>  		struct mnt_writer *cpu_writer = &per_cpu(mnt_writers, cpu);
> -		if (cpu_writer->mnt != mnt)
> -			continue;
>  		spin_lock(&cpu_writer->lock);
> +		if (cpu_writer->mnt != mnt) {
> +			spin_unlock(&cpu_writer->lock);
> +			continue;
> +		}
>  		atomic_add(cpu_writer->count, &mnt->__mnt_writers);
>  		cpu_writer->count = 0;
>  		/*

