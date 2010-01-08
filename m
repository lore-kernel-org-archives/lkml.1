Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358Ab0AHMgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0AHMgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285Ab0AHMgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:36:48 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:37078 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753218Ab0AHMgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:36:47 -0500
Date: Fri, 8 Jan 2010 23:36:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.30 and later] file corruption on ext3 filesystem.
Message-ID: <20100108123641.GB8654@discord.disaster>
References: <201001080254.o082sOXB018423@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001080254.o082sOXB018423@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 11:54:24AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I'm experiencing file corruption problem.
> Can somebody reproduce below result?
> 
> My environment:
>   VMware Workstation 6.5.3 with 2CPUs / 512MB RAM.
>   ext3 filesystem ( /dev/sda1 ) mounted on / .
> 
>   2.6.33-rc3 ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.33-rc3-ext3 )
>   2.6.32.3   ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.32.3-ext3 )
>   2.6.31.11  ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.31.11-ext3 )
>   2.6.30.10
> 
>   So far, I haven't succeeded to reproduce this problem for 2.6.29 and earlier.
>   Maybe this problem exists in only 2.6.30 and later.

Isn't that when the default mount options  changed from data=ordered to
data=writeback?

> Steps to reproduce:
> 
>   Compile below program using "gcc -Wall -O3 -o a.out".
> 
> ----------
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
> 
> int main(int argc, char *argv[])
> {
> 	FILE *fp = fopen("/testfile", "a");
> 	char buffer[4096];
> 	memset(buffer, argc > 1 ? argv[1][0] : 0x20, sizeof(buffer));
> 	buffer[sizeof(buffer) - 1] = '\n';
> 	fwrite(buffer, 1, sizeof(buffer), fp);
> 	fflush(fp);
> 	sleep(5);
> 	fprintf(stderr, "Let power fail after a few seconds.\n");
> 	while (1) {
> 		sleep(1);
> 		fwrite(buffer, 1, sizeof(buffer), fp);
> 	}
> 	return 0;
> }
> ----------
> 
>   Reboot the system by executing /sbin/reboot .
> 
>   Run ./a.out and let the power fail (i.e. unplug the electric cable
>   or do equivalent) after more than 5 seconds (i.e. longer than kjournald's
>   commit interval). Probably 2 or 3 seconds after
>   "Let power fail after a few seconds.\n" was printed is the best.
> 
>   Restart the system (and fsck will be executed).
> 
>   Run "cat /testfile". It should contain only lines of 4095 spaces + '\n'
>   (or the byte specified via argv[]). But it contains different data.

You didn't fsync() it, so there is no reason for the kernel
to have ever written it to disk. Therefore the result after powerfail
is completely undefined - you data may be there, it may not...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
