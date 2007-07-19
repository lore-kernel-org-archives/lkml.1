Return-Path: <linux-kernel-owner+w=401wt.eu-S965652AbXGSOQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965652AbXGSOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXGSOOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:14:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42711 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965454AbXGSOOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:14:03 -0400
Date: Thu, 19 Jul 2007 19:42:48 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>, Dan Aloni <da-x@monatomic.org>,
       Neil Horman <nhorman@redhat.com>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070719141248.GA18586@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070716123633.GA10920@in.ibm.com> <20070718230740oomichi@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718230740oomichi@mail.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 11:07:40PM +0900, Ken'ichi Ohmichi wrote:
> 
> Hi,
> 
> 2007/07/16 18:06:33 +0530, Vivek Goyal <vgoyal@in.ibm.com> wrote:
> >On Mon, Jul 16, 2007 at 02:28:54PM +0200, Bernhard Walle wrote:
> >> * Vivek Goyal <vgoyal@in.ibm.com> [2007-07-16 14:25]:
> >> > 
> >> > Ok. Now there seems to be two ways for accessing such info.
> >> > - Through global variables
> >> > - Export through ELF notes.
> >> > 
> >> > Personally, I like the approach taken by Dan Aloni of exporting required
> >> > info through ELF notes. That seems to be more standard in the sense we 
> >> > are not dependent on somebody removing above variable tomorrow.
> >> > 
> >> > Dan, are you planning to put the modified patch for discussions on LKML?
> >> 
> >> You mean the proposal with the makedumpfile-compatible ELF note?
> >> Although I like that idea, I think Ken'ichi Ohmichi was against it.
> >> 
> >
> >Yes, makedumpfile compatible ELF note one. Ken'ichi did not like the idea
> >too much, but I am not sure we discussed his objections in detail. I had
> >also responded with a mail with some of the advantages of ELF note based
> >approach. No response on that.
> 
> Sorry for my delayed response, I took a short vacation.
> 
> I'm not against with the proposal adding PT_NOTE segment to /proc/vmcore.
> I don't like only point that adds the necessary information list
> (some symbols, structures, etc.) for makedumpfile to kernel code.
> 
> The content of mkdfinfo file has been increasing whenever adding
> features and correcting bugs. The content is increasing even now.
> And, the feature addition is done not only for new kernels but also
> for old upstream kernels. When the content of mkdfinfo file is taken 
> into the kernel and fixed, the feature addition in the future is
> remarkably limited. So makedumpfile needs mkdfinfo file outside of
> the kernel.
> 

Well, idea of filtering tool having flexibility to create its own ELF note
and later retrieve it and use it looks good. But at the same time you 
will have to standardize the contents of ELF note. One can not keep on
changing it at will.

> I propose the solution including Dan's, Vivek's and Bernhard's opinions.
> How about the following sequence for distributors ?
> (It is not necessary to rebuild 2nd-kernel initrd even if 1st-kernel changes.
>  A new option "--mkdfinfo" is added to kexec command.)
> 
> * On the kernel building system
>   1. Create the kernel files.
>      # cd linux-2.6.xx
>      # make
>   2. Create the mkdfinfo file from the vmlinux.
>      # makedumpfile -g mkdfinfo-2.6.xx -x vmlinux
>      (OSRELEASE is taken from the vmlinux.)
>   3. Pack the kernel package with the kernel files and the mkdfinfo file.
> 
> * On each system
>   4. Preload 2nd-kernel and the mkdfinfo file.
>      # kexec -p vmlinux-kdump --mkdfinfo=mkdfinfo-2.6.xx ...

Providing first kernel's debug data on commandline while loading second
kernel is little odd but I guess can be lived with.

>      - 2nd-kernel is preloaded.
>      - 1st-kernel's PAGESIZE is taken by sysconf().
>      - The mkdfinfo file and the above PAGESIZE is preloaded
>        into /proc/vmcore's PT_NOTE segment.

>   5. Panic happens, and the system switchs to 2nd-kernel.
>   6. Create a filtered dump file.
>      # makedumpfile -cd31 /proc/vmcore dumpfile
>      (User doesn't need to specify the mkdfinfo file, because the
>       contents of the mkdfinfo file is included into /proc/vmcore.)
> 

Overall proposal looks interesting. But it still requires a debug compiled
vmlinux for one to use filtering. For distros it is probably easy as they
can extract the debug info at build time and ship separate file with kernel
package (/boot/mkdfinfo-2.6.xxx). For people building their custom kernel,
they still need to build vmlinux with debuginfo. Personally, I wished
we could get rid of this requirement. I think may be down the line we can
start exporting it from kenrel once contents of ELF note are well defined.

Thanks
Vivek



