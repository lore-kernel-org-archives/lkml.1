Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYADA1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYADA1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 19:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYADA1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 19:27:05 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:30500 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYADA1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 19:27:04 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 19:27:03 EST
Subject: Re: Error returns not
	handled	correctly	by	sysfs.c:subsys_attr_store()
From: Andrew Patterson <andrew.patterson@hp.com>
To: Tejun Heo <teheo@suse.de>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
       bjorn.helgaas@hp.com
In-Reply-To: <477D78BE.1060404@suse.de>
References: <1195683419.16019.225.camel@grinch>
	 <20071126203116.0c93cdb9.akpm@linux-foundation.org>
	 <20071127053321.GA975@kroah.com>  <474D1BD4.2050805@suse.de>
	 <1196278300.5431.9.camel@grinch>  <474E10CF.7050009@suse.de>
	 <1196716558.20124.179.camel@bluto.andrew>
	 <1199404273.7025.21.camel@bluto.andrew>  <477D78BE.1060404@suse.de>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 17:17:10 -0700
Message-Id: <1199405830.7025.33.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-04 at 09:07 +0900, Tejun Heo wrote:
> Hello,
> 
> Andrew Patterson wrote:
> > It looks like this is a shell issue.  After looking through the sysfs
> > code, I realized that this problem seems to be driven from user-land.
> > So I performed some experiments:
> > 
> >      1. Wrote a simple program that just used write(2) to write to the
> >         sysfs entry. This works fine.
> >      2. Used /bin/echo instead of the built-in echo command.  This too
> >         works fine.
> >      3. Tried several shells.  Zsh and Bash both fail.  Csh works fine.
> > 
> > I then ran strace on the following shell-script:
> > 
> > #!/bin/bash
> > 
> > echo x > allow_restart
> > echo y > allow_restart
> > echo z > allow_restart
> > 
> > and got:
> > 
> > # strace -e trace=write ~/tmp/tester.sh 
> > write(1, "x\n", 2)                      = -1 EINVAL (Invalid argument)
> > write(1, "x\n", 2)                      = -1 EINVAL (Invalid argument)
> > write(2, "/home/andrew/tmp/tester.sh: line"..., 72/home/andrew/tmp/tester.sh: line 4: echo: write error: Invalid argument
> > ) = 72
> > write(1, "x\ny\n", 4)                   = -1 EINVAL (Invalid argument)
> > write(1, "x\ny\n", 4)                   = -1 EINVAL (Invalid argument)
> > write(2, "/home/andrew/tmp/tester.sh: line"..., 72/home/andrew/tmp/tester.sh: line 5: echo: write error: Invalid argument
> > ) = 72
> > write(1, "x\ny\nz\n", 6)                = -1 EINVAL (Invalid argument)
> > write(1, "x\ny\nz\n", 6)                = -1 EINVAL (Invalid argument)
> > write(2, "/home/andrew/tmp/tester.sh: line"..., 72/home/andrew/tmp/tester.sh: line 6: echo: write error: Invalid argument
> > ) = 72
> > write(1, "x\ny\nz\n", 6x
> > y
> > z
> > )                = 6
> > Process 3800 detached
> 
> Eeeeeeeekkkk.... That's scary.  Which distro are you using and what does
> 'bash --version' say?

IA64 Debian lenny.  

# bash --version
GNU bash, version 3.1.17(1)-release (ia64-unknown-linux-gnu)

# zsh --version 
zsh 4.3.4 (ia64-unknown-linux-gnu)

# csh --version
tcsh 6.14.00 (Astron) 2005-03-25 (ia64-unknown-linux) options
wide,nls,dl,al,kan,rh,nd,color,filec

I suppose I should try this an ia32 box again, and perhaps with some
other distros.  I am not sure what the kernel can do about this, but it
might be nice to report it to the shell maintainers.

-- 
Andrew Patterson
Hewlett-Packard Company

