Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbYENC46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbYENC46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 22:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbYENC4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 22:56:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757854AbYENC4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 22:56:47 -0400
Date: Tue, 13 May 2008 22:56:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec
	multi-stage load
Message-ID: <20080514025607.GA19944@redhat.com>
References: <1210574441.30365.8.camel@caritas-dev.intel.com> <20080513053408.GA5870@redhat.com> <1210730266.23707.50.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210730266.23707.50.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 09:57:46AM +0800, Huang, Ying wrote:
> Hi, Vivek,
> 
> On Tue, 2008-05-13 at 01:34 -0400, Vivek Goyal wrote:
> > On Mon, May 12, 2008 at 02:40:41PM +0800, Huang, Ying wrote:
> > > This patch implements a prototype of kexec multi-stage load. With this
> > > patch, the "backup pages map" can be passed to kexeced kernel via
> > > /sbin/kexec; and the sys_kexec_load can be used to load large
> > > hibernated image with huge number of segments.
> > > 
> > > 
> > 
> > Hi Huang,
> > 
> > Had a quick look at the patch. Will review in detail soon. Had few
> > thoughts.
> > 
> > In general, these patches are on top of previous kexec jump patches.
> > It would be good if you could repost your updated patches so that
> > I can apply the patches and and get some testing going.
> 
> The kexec jump patch v9 is sufficient for this patch to work. I have no
> new version of kexec jump patch so far.
> 
> > Last time I tried the patches (V9) and kexec jump did not work for me. I
> > was not getting timer interrupts in second kernel. Then I had to put 
> > LAPIC and IOAPIC in legacy mode and then at one way jump started working.
> > I am not sure how the next kernel boots for you without putting APICs
> > in legacy mode. (Yet to make returning back to original kernel work
> > using V9). 
> 
> Can normal kexec (without kexec jump) works without putting LAPIC and
> IOAPIC in legacy mode? Does this mean we should put LAPIC and IOAPIC
> into legacy mode before kexec and restore them after?
> 

We do put LAPIC and IOAPIC in legacy mode in normal kexec. Look at 
disable_IO_APIC() in native_machine_shutdown(). So I think we shall
have to do the same thing in kexec jump code too.

> The kexec jump patch works well on my IBM T42. But it seems that the
> IOAPIC is disabled in BIOS, so I can only use i8259 and LAPIC on this
> machine.
> 
> > > In kexec based hibernation, resuming from disk is implemented as
> > > loading the hibernated disk image with sys_kexec_load(). But unlike
> > > the normal kexec load, the hibernated image may have huge number of
> > > segments. So multi-stage loading is necessary for kexec load based
> > > resuming from disk implementation.
> > 
> > I understand that hibernated images are huge. But why do we require
> > multi stage loading? I knew there was a maximum segment limit in kexec.
> > But I think we can change that limit. Anything else prevents us from
> > loading large images in one go?
> 
> There are two reason for multi-stage loading:
> 
> - Pass backup pages map from original kernel (A) to kexeced kernel (B),
> because it is not known before loading. We have discussed this before
> in:
> 	http://lkml.org/lkml/2008/3/12/308
> 	http://lkml.org/lkml/2008/3/14/59
> 	http://lkml.org/lkml/2008/3/21/299
> 

See my response below....

> - Load large hibernated image. The hibernated image can be not only
> large but also discontinuous. For example, the physical memory size is
> 4G, and there is one free page every 2 pages, that is, there will be
> nearly 2G segments. Loading these segments in one go is impossible. So
> multi-stage load is necessary. And if the hibernated image is
> compressed, it is also very difficult to load it in one go because the
> anonymous pages needed.
> 
> > > And, multi-stage loading is also
> > > necessary for parameter passing from original kernel to kexeced kernel
> > > because some information such as "backup pages map" is not available
> > > before loading.
> > > 
> > > 
> > > Four stages are defined:
> > > 
> > > - KS_start: start stage; begin a new kexec loading; there must be only
> > >   one KS_start stage in one kexec loading.
> > > 
> > > - KS_mid: middle stage; continue load some segments; there may be many
> > >   or zero KS_mid stages in one kexec loading; follows a KS_start or
> > >   KS_mid stage.
> > > 
> > > - KS_final: final stage; finish a kexec loading; there must be only
> > >   one KS_final stage in one kexec loading; follows a KS_start or
> > >   KS_mid stage.
> > > 
> > > - KS_full: back compatible with original loading semantics, finish all
> > >   work of a kexec loading in one KS_full stage.
> > > 
> > > 
> > > Overlapping between pages of different segments is allowed to support
> > > "parameter passing".
> > > 
> > > 
> > > During loading, a hash table mapped from destination page to source
> > > page is used instead of original linear mapping
> > > implementation. Because the hibernated image may be very large (up to
> > > near the size of physical memory), it is very time-consuming to search
> > > a source page given the destination page, which is used to check
> > > whether an newly allocated page is in the range of allocated
> > > destination pages.
> > 
> > This seems to be an optimization of kexec so that it becomes efficient
> > in loading large images (containing large number of segments). Probably
> > this can be a separate patch.
> 
> If it is desired, I can separate it into another patch.
> 
> > IMHO, we can just first write a minimal patch where one can just switch
> > between kernels. Once that patch is upstream, we can enhance
> > it to do the hibernation and saving core functionality. Incremental
> > review becomes easier. Your last patch (v9) was a good attempt at that and
> > I thought very soon we shall have something mergable.
> 
> Agreed. We can first focus on kexec jump patch. But as in last thread of
> kexec jump (v9), we need a protocol for parameter passing between kernel
> A and kernel B. So, we can use this patch as a prototype for the
> communication protocol.

I went through above mail thread again where we were discussing what all
information need to be passed between kernels.

Last time we enumerated three things.

- kernel entry/re-entry point for switch between kernels.
- backup pages map for core filtering
- Probably ELF core notes for saving hibernated image.

I think if we just implement the functionality so that one can switch
back and forth between kernels (no hibernated image saving),then we probably
need to pass around only kernel entry/re-entry point and nothing else and in
your patches I think you are already doing using %edi.

So, IMHO, for first simple implementation, we don't have to pass around
any data between kernels except entry point. (Please correct me if I am 
wrong). Lets get that implementation in first and then we can get rest
of the pieces in place.

> 
> > > The original mapping is only used by assembly code
> > > to swap the page contents. This map is also exported to user space via
> > > /proc/kexec_pgmap, so that /sbin/kexec can use it to construct the
> > > "backup pages map" parameter for kexeced kernel.
> > > 
> > > 
> > > This patch is based on Linux kernel 2.6.25 and kexec_jump patch, and
> > > has been tested on an IBM T42.
> > > 
> > 
> > Is kexec_jump v9 patch good enough or you have anohter internal version
> > of patch on top of this patch applies?
> 
> v9 is the latest kexec jump patch, no other internal version so far.

Great. I got busy in other stuff last time. Will download the v9 again
and give it a try.

Thanks
Vivek
