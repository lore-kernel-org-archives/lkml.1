Return-Path: <linux-kernel-owner+w=401wt.eu-S1763008AbXGMD6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763008AbXGMD6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXGMD6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:58:21 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49572 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850AbXGMD6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:58:17 -0400
Date: Fri, 13 Jul 2007 09:28:25 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: Dan Aloni <da-x@monatomic.org>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070713035825.GB4975@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070711073216.GA11757@localdomain> <20070711224304oomichi@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711224304oomichi@mail.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 10:43:04PM +0900, Ken'ichi Ohmichi wrote:
> 
> Hi Dan,
> 
> 2007/07/11 10:32:16 +0300, Dan Aloni <da-x@monatomic.org> wrote:
> >> This implementation looks interesting. No need of debug compiled
> >> vmlinux for dump filtering purposes. No run time vmlinux binary modifications
> >> as suggested by your previous mails. People can export kernel CONFIG info
> >> like PAGESIZE etc with the help of this ELF note and any tool which is
> >> processing kernel core file can benifit from this. No guesses required for
> >> determining the page size of crashed kernel.
> >> 
> >> All the info required by dump filtering tool, put it into an ELF note, 
> >> pass it to second kernel which appends it to final vmcore. The only concern
> >> here again is that type of ELF note is not standard. The contents of 
> >> ELF notes will keep on changing over a period of time. For example if a 
> >> new memory model evolves. Now everytime this note data changes one shall
> >> have to update mkdumpfile and user shall have to newer version. If there
> >> are any issues, user will not come to know about the issue during kdump
> >> service enablement time, instead it will be detected during dump 
> >> capture time. It is too late till then.
> >
> >I guess that dump filtering will needed to be tested at least once 
> >under various platforms for every major release of the kernel to see 
> >if the information exported by the kernel through this elf note is 
> >still sufficient. 
> >
> >Adding more info to this elf note as needed can be done through a simple 
> >patch to the kernel and it can be tested along with mkdumpfile changes 
> >even before a major version gets released.
> 
> As Vivek said, I think it is not a good idea that both kernel's code and
> makedumpfile's code should be changed when makedumpfile needs more debug
> information (ex. To extend the supported CPU architectures. To fix some
> machine-specific problems, etc.).
> Also it is difficult to change the list of necessary items in kernel,
> because we should be careful about CPU architecture, linux version, and
> memory model. makedumpfile needs the following items, and those existence
> depends on CPU architecture, linux version, and memory model. If we don't
> be careful about them, the kernel building may fail.
> I think it is not a good idea that each items are defined by ifdef, it
> is too complex.
> 

Hi Ken'ichi,

This approach seems to have advantages also. For example, now one will not
require a kernel debuginfo file to configure kdump with dump filtering.
I think having to have a debug info file is a big restriction.

Now vmcore ELF note contain all the data rquired to filter core dump and
there will be no need to parse DWARF debuginfo and makedumpfile code will be
smaller and simpler.

Given the fact that more and more architectures are supporting multiple
page sizes. Now one can also export relevant kernel CONFIG variables
through this ELF note. makedumpfile's job will be simpler. You don't have
to make any guesses about various config options like page size.

This approach will make second kernel truly independent of first kernel.
Currently, if first kernel changes one shall have to regenerate the 
initrd for second kenrel. Hence in a sense, second kernel is dependent on
first kernel. Now kernel will export all the required data for dump filtering
so one does not have to rebuild the seond kernel initrd even if first kernel
changes.

I think overall the approach of exporting right info from kernel should 
help. Only thing is that we shall have to manage the ELF note better in
terms of making it more generic.

Thanks
Vivek
