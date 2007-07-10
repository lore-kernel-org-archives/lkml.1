Return-Path: <linux-kernel-owner+w=401wt.eu-S1761874AbXGJRSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874AbXGJRSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759415AbXGJRSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:18:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647AbXGJRSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:18:10 -0400
Date: Tue, 10 Jul 2007 13:17:40 -0400
From: Neil Horman <nhorman@redhat.com>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Dan Aloni <da-x@monatomic.org>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710171740.GA11130@hmsendeavour.rdu.redhat.com>
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070709092154.GA19705@suse.de> <20070709114131.GA18750@localdomain> <20070710150037.GB10216@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710150037.GB10216@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 08:30:37PM +0530, Vivek Goyal wrote:
> On Mon, Jul 09, 2007 at 02:41:31PM +0300, Dan Aloni wrote:
> > 
> > I don't think it would add much complexity to build process as it 
> > is now, just like the other tools that transparently do post-linking 
> > modifications. As far as the developer is concerned, there's just
> > the vmlinux and/or bzImage files that get emitted at the end.
> > 
> > > > Then inside initramfs of the first kernel, a small 
> > > > util will modify the vmlinux file of the kdump kernel before it
> > > > gets loaded so that another special file appearing as 
> > > > /proc/vmcore.info under the kdump kernel will present the same
> > > > info. 
> > > 
> > > Where do you get the info from? If you're in the kdump initrd,
> > > then the kdump kernel is already loaded. Do you want to attach the
> > > info from the crashed kernel to the initrd of the kdump kernel?
> > 
> > Not exactly. Let me describe the procedure in greater detail.
> > Basically, it would go like this:
> > 
> > 1. <normal bootloader boot>
> > 2. <normal initramfs>
> > 3. embed_configfile /proc/kcore.info /vmlinux-kdump
> > 4. kexec -l vmlinux-kdump <....>
> > 5. <boot continues>
> > 6. <crash>
> > 7. <kdump kernel boot>
> > 8. <kdump initramfs runs>
> > 9. makedumpfile -i /proc/vmcore.info <....>
> > 
> > NOTES:
> > ** in step 3 embed_configfile modifies vmlinux-kdump in place, 
> >    copying /proc/kcore.info into the data section of the vmlinux-kdump 
> >    at certain symbol (e.g. 'char core_info[0x1000]').
> > ** in step 9 that data section variable (e.g. core_info) which was 
> >    originally holds the content of /proc/kcore.info is being presented 
> >    as /proc/vmcore.info for the util to use.
> > 
> > To complete the picture, at the final build stage of vmlinux we 
> > would have this:
> > 
> > makedumpfile -g vmlinux.configfile -x vmlinuxx
> > embed_configfile vmlinux.configfile vmlinux
> > rm vmlinux.configfile
> > 
> 
> Are you planning to move makedumpfile utility in kernel source three then
> for this command to run? Output of "makedumpfile -g" is pretty non-standard
> and very customized for filtering. At the same time, this will only work
> if first kernel was compiled with debug info. (I think makedumpfile
> retrieves all the structure member offset info from .debuginfo seciton).
> 
I think that your step 3 doesn't make too much sense, unless you only run
kernels with dwarf debug information included, in which case you don't need to
embed any files, since the kdump kernel will expose all its needed symbol info
through /proc/kcore.  Currently the RHEL5 kdump service embeds the needed config
file into the kdump initramfs for use on kdump.  I don't see what added
advantage the above series of actions provides.

> I am still thinking that why can't we change initrd building process
> (Be it mkinitrd or mkdumprd depending on distriution). Whole idea is
> that while building an initrd/initramfs for the first kernel, one will
> ask user for kdump kernel (if user wishes to load kdump kenrel through
> initrd) and then it will generate kdump kenrel's initrd and pack into
> first kernel's initrd.
> 
> So steps would look something like this.
> 
> - mkinitrd takes second kernel's vmlinux as argument
> - mkinitrd runs "makedumpfile -g" on debug version of first kernel's vmlinux.
> - mkinitrd generates the initramfs for kdump kernel and packs output
>   of "makedumpfile -g" into that.
> - mkinitrd packs statically linked kexec, kdump kernel vmlinux/bzImage,
>   and kdump kernel initramfs into first kernel's initramfs.
> 
Agreed, this is exactly what happens right now.

> This will save us from doing any changes to kernel build process and
> also avoid any run time updation of vmlinux code. Exporting a particular
> non-standard output through proc interfaces does not seem to be a very good
> idea (/proc/kcore.info or /proc/vmcore.info)
> 
> Thanks
> Vivek

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
