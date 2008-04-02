Return-Path: <linux-kernel-owner+w=401wt.eu-S1759539AbYDBBjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539AbYDBBjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 21:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYDBBjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 21:39:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370AbYDBBjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 21:39:08 -0400
Date: Tue, 1 Apr 2008 18:38:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Sapan Bhatia" <sapan.bhatia@gmail.com>
Cc: linux-kernel@vger.kernel.org, daniel@hozac.com
Subject: Re: race leading to held mutexes, inode_cache corruption
Message-Id: <20080401183829.110ae2b9.akpm@linux-foundation.org>
In-Reply-To: <3cb76b010804011815l52e69576x9ddb97c07ab38111@mail.gmail.com>
References: <3cb76b010804011815l52e69576x9ddb97c07ab38111@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008 21:15:52 -0400 "Sapan Bhatia" <sapan.bhatia@gmail.com> wrote:

> Hi,
> 
> We've been trying to investigate a file-system corruption issue in our
> kernel (http://svn.planet-lab.org/browser/linux-2.6/trunk) that
> manifests itself both with ext3 and ext2. It appears to be happening
> to due a contamination of the inode cache (we spent some time
> monitoring our systems to arrive at this hypothesis), and can be
> reproduced on a vanilla kernel as well.
> 
> The race that leads to this issue involves a process being terminated
> when it is waiting for a mutex in __mutex_lock_common. eg. when it is
> sent a SIGKILL, and the mutex is unlocked, causing the process to be
> woken up and sent to exit while now holding the lock.
> 
> The way it contaminates the inode_cache slab is that inode->i_mutex is
> only initialized once, and assumes that inodes coming back into the
> cache are initialized. It seems that in our case such poisoned inodes
> were leaking out of pipe.c.
> 
> This (www.cs.princeton.edu/~sapanb/mut.c) is the module we used to
> test the condition, as follows. Writing to the char device locks a
> mutex and reading from it unlocks it.
> # echo 1 > /dev/mut
> # cat /etc/passwd > /dev/mut &
> [2] 6232
> # kill -9 6232
> # cat /dev/mut
> [2]-  Killed                  cat /etc/passwd > /dev/mut
> # echo 1 > /dev/mut
> (goes to sleep)
> 
> I suppose that one could also construct an attack to proactively
> corrupt inode_cache, but I haven't tried that as yet.
> 
> Our base kernel is 2.6.22.19.

This is ... confusing.

Are you saying that some caller of mutex_lock_interruptible() is getting a
return value of -EINTR from mutex_lock_interruptible(), but this task in
fact _did_ acquire the mutex?

That's the only way in which I can interpret your second paragraph, but as
far as I can tell the code cannot do that.

Can you provide more detail?
