Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYACXvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYACXvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYACXvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:51:17 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:21236 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbYACXvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:51:15 -0500
Subject: Re: Error returns not handled
	correctly	by	sysfs.c:subsys_attr_store()
From: Andrew Patterson <andrew.patterson@hp.com>
To: Tejun Heo <teheo@suse.de>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
       bjorn.helgaas@hp.com
In-Reply-To: <1196716558.20124.179.camel@bluto.andrew>
References: <1195683419.16019.225.camel@grinch>
	 <20071126203116.0c93cdb9.akpm@linux-foundation.org>
	 <20071127053321.GA975@kroah.com>  <474D1BD4.2050805@suse.de>
	 <1196278300.5431.9.camel@grinch>  <474E10CF.7050009@suse.de>
	 <1196716558.20124.179.camel@bluto.andrew>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 16:51:13 -0700
Message-Id: <1199404273.7025.21.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-03 at 14:15 -0700, Andrew Patterson wrote:
> On Thu, 2007-11-29 at 10:07 +0900, Tejun Heo wrote:
> > Andrew Patterson wrote:
> > > I tried with clean 2.6.24-rc3 and get the same bad behavior.  This is on
> > > an ia64 box, so maybe that is an issue. I can try on an x86 box as well.
> > > Oh, one other thing.  I tried a "uname -r" to make sure I had the
> > > correct kernel booted and got:
> > > 
> > > # uname -r
> > > 2.6.24-rc3
> > > x
> > > y
> > > z
> > > #
> > 
> > Yeah, please try it on another machine from clean tree.  sysfs code is
> > definitely not endian dependent and is 64 bit clean.  Heck, all my test
> > machines run 64 bit these days.  I would be surprised if it's something
> > architecture dependent but please try on a different machine with
> > different userland with kernel built from fresh source tree.
> > 
> > Thanks.
> 
> I tried this on a AMD system running an i386 kernel. I get the same bad
> behavior.  This is from a 2.6.24-rc3 kernel downloaded from kernel.org.
> I ran "make mrproper" followed by "make oldconfig" and accepted all the
> defaults for the config.
> 
> There is one slight change with this experiment.  Other nodes are not
> getting corrupted, i.e., uname -r is getting the correct value.

It looks like this is a shell issue.  After looking through the sysfs
code, I realized that this problem seems to be driven from user-land.
So I performed some experiments:

     1. Wrote a simple program that just used write(2) to write to the
        sysfs entry. This works fine.
     2. Used /bin/echo instead of the built-in echo command.  This too
        works fine.
     3. Tried several shells.  Zsh and Bash both fail.  Csh works fine.

I then ran strace on the following shell-script:

#!/bin/bash

echo x > allow_restart
echo y > allow_restart
echo z > allow_restart

and got:

# strace -e trace=write ~/tmp/tester.sh 
write(1, "x\n", 2)                      = -1 EINVAL (Invalid argument)
write(1, "x\n", 2)                      = -1 EINVAL (Invalid argument)
write(2, "/home/andrew/tmp/tester.sh: line"..., 72/home/andrew/tmp/tester.sh: line 4: echo: write error: Invalid argument
) = 72
write(1, "x\ny\n", 4)                   = -1 EINVAL (Invalid argument)
write(1, "x\ny\n", 4)                   = -1 EINVAL (Invalid argument)
write(2, "/home/andrew/tmp/tester.sh: line"..., 72/home/andrew/tmp/tester.sh: line 5: echo: write error: Invalid argument
) = 72
write(1, "x\ny\nz\n", 6)                = -1 EINVAL (Invalid argument)
write(1, "x\ny\nz\n", 6)                = -1 EINVAL (Invalid argument)
write(2, "/home/andrew/tmp/tester.sh: line"..., 72/home/andrew/tmp/tester.sh: line 6: echo: write error: Invalid argument
) = 72
write(1, "x\ny\nz\n", 6x
y
z
)                = 6
Process 3800 detached

As you can see, subsequent echo commands have their arguments appended
to the previous command. So it seems that the shell is not resetting the
buffer between failed echo commands.  

-- 
Andrew Patterson
Hewlett-Packard Company

