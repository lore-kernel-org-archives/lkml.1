Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbZAWNnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbZAWNnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZAWNnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:43:31 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39632 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753818AbZAWNna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:43:30 -0500
Date: Fri, 23 Jan 2009 07:45:18 -0600
From: Cliff Wickman <cpw@sgi.com>
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to generate a Kerntypes file?
Message-ID: <20090123134518.GA23513@sgi.com>
References: <4104961b0901220259u51677cbdkda2ed84dc2892543@mail.gmail.com> <20090122133107.GA27592@sgi.com> <4104961b0901222237h7fac5b1vf1b3b7f9d06d550c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4104961b0901222237h7fac5b1vf1b3b7f9d06d550c@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 02:37:12PM +0800, jidong xiao wrote:
> On Thu, Jan 22, 2009 at 9:31 PM, Cliff Wickman <cpw@sgi.com> wrote:
> > Hi Jason,
> >
> > On Thu, Jan 22, 2009 at 06:59:34PM +0800, jidong xiao wrote:
> >> Hi,All,
> >>
> >> Sometimes when I install a kernel I saw there is a Kerntypes file
> >> installed under /boot directory, but sometimes no, I remember when I
> >> install a sles9 kernel, there must be a Kerntypes file installed, but
> >> most of other kernels doesn't include such a Kerntypes file. This file
> >> is very useful for me to do some analysis, so I hope I can generate it
> >> every time I build a kernel. Do I need a patch for this or there are
> >> already some patches I can take use of?Thanks.
> >
> > You had a init/kerntypes.c in sles9 and sles10. It included a lot
> > of basic kernel types.  It was compiled with -g to make the kerntypes.
> > I presume that you used the LKCD project's lcrash with the kerntypes.
> >
> Hi, Cliff,
> 
> Thanks for your guides.
> 
> Well yes I am intending to use lcrash to load the kernel debug information.
> 
> I noticed that recently kdb is going to be able to print out kernel
> structures, and now I want to test that feature, I started my
> experiments by reading the instructions inside
> kdb/modules/kdbm_debugtypes.c which is saying:
> 
>  * Usage:
>  *  in order for the insmod kdbm_debugtypes.ko to succeed in loading types
>  *  you must first use  lcrash -t kerntypes.xxxx -o debug_info
>  *  and echo debug_info > /proc/kdb/debug_info_name
> 
> so I have to generate kerntypes file. I looked into init/kerntypes.c,
> it seems there is nothing but just includes some header files, like
> below:
> 
>      16 #include <linux/compile.h>
>      17 #include <linux/module.h>
>      18 #include <linux/mm.h>
>      19 #include <linux/vmalloc.h>
>      20 #include <linux/config.h>
>      21 #include <linux/utsname.h>
>      22 #include <linux/kernel_stat.h>
>      23 #include <linux/dump.h>
>      24
>      25 #include <asm/kerntypes.h>
> 
> We can see here are 9 files are included, does this mean the resulted
> Kerntypes file only provides kernel structures that are defined within
> these 9 files?
Yes
> If I want to print out more kernel structures I need to
> change this file so as to include more header files?

Yes, in theory. But not so easily done, as you can't throw in any and every
header and get a clean compile.
 
> In addition, if I want to generate Kerntypes file via building a
> mainline kernel(rather than SLES kernel), the only thing I need to do
> is:
> 1. add this init/kerntypes.c and include/asm/kerntypes.h into kernel
> source code.
> 2. change the Makefile accordingly.
> 
> After that I just compile the kernel as usual and I should be able to
> get the Kerntypes file(which is actually nothing but just
> init/kerntypes.o), right?

You wouldn't use init/kerntypes.c
In your .config file set CONFIG_DEBUG_INFO=y
That will cause the whole kernel to be compiled with -g.
Then:   dwarfextract -Pp vmlinux kerntypes
You can append the structures from any modules:
 dwarfextract kerntypes -c xxx.ko,yyy.ko,zzz.ko kerntypes.with.modules

> 
> Regards
> Jason
> 
> > If you download lkcd (lkcd.svn.sourceforge.net) you also build a
> > tool called dwarfextract.  It is able to pull all the structure
> > definitions out of a -g (CONFIG_DEBUG_INFO) kernel and any selected
> > modules.  That is useful with the lcrash command.
BTW  there are recent additions to dwarfextract. you might want to
     re-download lkcd.

-Cliff
-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
