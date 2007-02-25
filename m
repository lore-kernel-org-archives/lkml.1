Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXBYMsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXBYMsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964872AbXBYMsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:48:45 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35282 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964871AbXBYMso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:48:44 -0500
Date: Sun, 25 Feb 2007 04:47:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J.J. Green" <j.j.green@sheffield.ac.uk>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc64 / bbc_i2c.c
Message-Id: <20070225044754.1d849a8d.akpm@linux-foundation.org>
In-Reply-To: <1171978032.18442.11.camel@lax.shef.ac.uk>
References: <1171978032.18442.11.camel@lax.shef.ac.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 20 Feb 2007 13:27:12 +0000 "J.J. Green" <j.j.green@sheffield.ac.uk> wrote:
> Hi all
> 
> I got bitten by this problem on sparc64 (a blade 1000)
> 
>   http://ubuntuforums.org/showthread.php?t=297474
>
> summary :
> 
>   modprobe bbc
> 
> runs kenvctrld which uses 100% of a CPU for 5 seconds,
> then 0% for 5 seconds, then 100% .. and so on. The author
> cited above suggests removing the line 
> 
>   remove_wait_queue(&bp->wq, &wait);
> 
> in the function 
> 
>   static int wait_for_pin(struct bbc_i2c_bus *bp, u8 *status)
> 
> Is there a better way?
> 
> I can test patches if that would be helpful.
> 

The code around there looks relatively unbuggy to me.  Removing that
remove_wait_queue() would be very bad - it would cause later stack
corruption.

msleep_interruptible() certainly shouldn't consume CPU like that.  Do we
know where the CPU time is being spent?  The output of:

readprofile -r
sleep 10
readprofile -n -v -m /boot/System.map | sort -n -k 3 | tail -40

would tell us.
