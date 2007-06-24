Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbXFXX3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbXFXX3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXFXX3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:29:41 -0400
Received: from smtpout.mac.com ([17.250.248.177]:51837 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXFXX3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:29:40 -0400
In-Reply-To: <20070624232734.28829225@debian>
References: <20070624232734.28829225@debian>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3FDD4C43-2F9A-46B3-BFA5-DC5E5A30D985@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Arnd Hannemann <arnd@arndnet.de>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: pivot_root alternative
Date: Sun, 24 Jun 2007 19:29:20 -0400
To: Salvatore De Paolis <depaolis.salvatore@libero.it>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 24, 2007, at 17:27:34, Salvatore De Paolis wrote:
> i built the kernel with a busybox initramfs which runs from a usb  
> stick. While i boot i need to mount the real root and i'm using  
> pivot_root.  Pivot_root . old-root return to me an "Invalid  
> argument" error and googling i found here http://lkml.org/lkml/ 
> 2005/10/8/17 that pivot_root should be avoided.  I want to ask now  
> what i should do to switch to a real root?

One interesting fact about the mount() syscall is this: when  
overmounting a directory tree, a process whose current working  
directory is within said directory tree will see the old vfsmounts  
until it does an absolute chdir().  Shells tend not to be terribly  
useful for this because they use absolute paths more than necessary,  
but I think you can make it work.  For instance, if you run these  
commands after mounting the root filesystem:

mount -t proc proc /realroot/proc
cd /
mount --move /realroot /
find /proc/$$/cwd/ -mindepth 1 -maxdepth 1 -print0 \
		| xargs -0 rm -rf -- '{}' ';'
cd /

This will set up proc on the new root filesystem, move /realroot to  
the root directory, and delete the contents of the old initramfs  
using the old current-working-directory link of your shell.  The  
amusing thing is that you are using the "find" and "rm" commands from  
the newly mounted root filesystem to remove the contents of the  
completely hidden initramfs.  The only reason it's actually possible  
is because you have the tenuous thread of the working directory.

Cheers,
Kyle Moffett

