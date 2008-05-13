Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbYEMFew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbYEMFew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 01:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYEMFeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 01:34:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbYEMFen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 01:34:43 -0400
Date: Tue, 13 May 2008 01:34:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec
	multi-stage load
Message-ID: <20080513053408.GA5870@redhat.com>
References: <1210574441.30365.8.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210574441.30365.8.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 02:40:41PM +0800, Huang, Ying wrote:
> This patch implements a prototype of kexec multi-stage load. With this
> patch, the "backup pages map" can be passed to kexeced kernel via
> /sbin/kexec; and the sys_kexec_load can be used to load large
> hibernated image with huge number of segments.
> 
> 

Hi Huang,

Had a quick look at the patch. Will review in detail soon. Had few
thoughts.

In general, these patches are on top of previous kexec jump patches.
It would be good if you could repost your updated patches so that
I can apply the patches and and get some testing going.

Last time I tried the patches (V9) and kexec jump did not work for me. I
was not getting timer interrupts in second kernel. Then I had to put 
LAPIC and IOAPIC in legacy mode and then at one way jump started working.
I am not sure how the next kernel boots for you without putting APICs
in legacy mode. (Yet to make returning back to original kernel work
using V9). 

> In kexec based hibernation, resuming from disk is implemented as
> loading the hibernated disk image with sys_kexec_load(). But unlike
> the normal kexec load, the hibernated image may have huge number of
> segments. So multi-stage loading is necessary for kexec load based
> resuming from disk implementation.

I understand that hibernated images are huge. But why do we require
multi stage loading? I knew there was a maximum segment limit in kexec.
But I think we can change that limit. Anything else prevents us from
loading large images in one go?

> And, multi-stage loading is also
> necessary for parameter passing from original kernel to kexeced kernel
> because some information such as "backup pages map" is not available
> before loading.
> 
> 
> Four stages are defined:
> 
> - KS_start: start stage; begin a new kexec loading; there must be only
>   one KS_start stage in one kexec loading.
> 
> - KS_mid: middle stage; continue load some segments; there may be many
>   or zero KS_mid stages in one kexec loading; follows a KS_start or
>   KS_mid stage.
> 
> - KS_final: final stage; finish a kexec loading; there must be only
>   one KS_final stage in one kexec loading; follows a KS_start or
>   KS_mid stage.
> 
> - KS_full: back compatible with original loading semantics, finish all
>   work of a kexec loading in one KS_full stage.
> 
> 
> Overlapping between pages of different segments is allowed to support
> "parameter passing".
> 
> 
> During loading, a hash table mapped from destination page to source
> page is used instead of original linear mapping
> implementation. Because the hibernated image may be very large (up to
> near the size of physical memory), it is very time-consuming to search
> a source page given the destination page, which is used to check
> whether an newly allocated page is in the range of allocated
> destination pages.

This seems to be an optimization of kexec so that it becomes efficient
in loading large images (containing large number of segments). Probably
this can be a separate patch.

IMHO, we can just first write a minimal patch where one can just switch
between kernels. Once that patch is upstream, we can enhance
it to do the hibernation and saving core functionality. Incremental
review becomes easier. Your last patch (v9) was a good attempt at that and
I thought very soon we shall have something mergable.

> The original mapping is only used by assembly code
> to swap the page contents. This map is also exported to user space via
> /proc/kexec_pgmap, so that /sbin/kexec can use it to construct the
> "backup pages map" parameter for kexeced kernel.
> 
> 
> This patch is based on Linux kernel 2.6.25 and kexec_jump patch, and
> has been tested on an IBM T42.
> 

Is kexec_jump v9 patch good enough or you have anohter internal version
of patch on top of this patch applies?

Thanks
Vivek
