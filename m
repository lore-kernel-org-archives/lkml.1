Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0BBPml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:42:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50958 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab0BBPmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:42:39 -0500
Date: Tue, 2 Feb 2010 16:42:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off
 switch out of staging."
Message-ID: <20100202154221.GA27314@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
 <20100202115611.GA10289@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100202115611.GA10289@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jerome Glisse <glisse@freedesktop.org> wrote:

> On Tue, Feb 02, 2010 at 09:17:27AM +0100, Ingo Molnar wrote:
> > 
> > * Dave Airlie <airlied@linux.ie> wrote:
> > 
> > > > Hi Linus,
> > > > 
> > > > Please pull the 'drm-linus' branch from
> > > > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> > > > 
> > > 
> > > I've also added an oops fix I seem to lose off my radar to this tree.
> > > 
> > > commit 17aafccab4352b422aa01fa6ebf82daff693a5b3
> > > Author: Michel D??nzer <daenzer@vmware.com>
> > > Date:   Fri Jan 22 09:20:00 2010 +0100
> > > 
> > >     drm/radeon/kms: Fix oops after radeon_cs_parser_init() failure.
> > 
> > FYI, this drm pull into mainline has triggered quick boot crashes in -tip 
> > testing (even with the above fix applied), on an Athlon64 whitebox PC with:
> > 
> >  01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)]
> >  01:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
> > 
> > the crash is:
> > 
> > [    7.111003] radeon 0000:01:00.0: Disabling GPU acceleration
> > [    7.273547] Failed to wait GUI idle while programming pipes. Bad things might happen.
> > [    7.436296] [drm:r100_cp_fini] *ERROR* Wait for CP idle timeout, shutting down CP.
> > [    7.598755] Failed to wait GUI idle while programming pipes. Bad things might happen.
> > [    7.599306] BUG: unable to handle kernel paging request at f8380000
> > [    7.599999] IP: [<c149f0de>] rv370_pcie_gart_set_page+0x2d/0x3c
> > [    7.599999] *pde = 36d44067 *pte = 00000000
> > [    7.599999] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> > [    7.599999] last sysfs file:
> > 
> > i have bisected it back to:
> > 
> >  | 97b94ccb9aa1b82ed7a9a045d0ae5b32c99b84a0 is the first bad commit
> >  | commit 97b94ccb9aa1b82ed7a9a045d0ae5b32c99b84a0
> >  | Author: Dave Airlie <airlied@redhat.com>
> >  | Date:   Fri Jan 29 15:31:47 2010 +1000
> >  |
> >  |     drm/radeon/kms: fix incorrect logic in DP vs eDP connector checking.
> >  |    
> >  |     This makes displayport work again here.
> > 
> > Unfortunately even with that patch reverted it still crashes. Config and 
> > bootlog attached.
> > 
> > It's the moving of radeom KMS out of staging after -rc6 that causes it, 
> > because it brought it into the scope of my testing:
> > 
> >  f71d018: drm/radeon/kms: move radeon KMS on/off switch out of staging.
> > 
> > So at least on this box it's clearly not ready for mainline enablement yet. 
> > I've attached the revert patch further below.
> > 
> > 	Ingo
> > 
> 
> Attached is a patch which will fix the oops, still it's strange that CP 
> fails to init on your config. [...]

Thanks, that fixes the crash here!

Tested-by: Ingo Molnar <mingo@elte.hu>

> [...] Do you have IOMMU enabled ? I haven't played with iommu stuff thus i 
> wonder if we are missing somethings in this area.

No IOMMU here - this is a 5 years old box. (beyond GART that is)

Your patch fixes a bona-fide illegal-access bug in the DRM code, that's more 
than enough to crash the box ;-)

Btw., there's a new warning in the DRM code

 drivers/gpu/drm/ati_pcigart.c: In function ‘drm_ati_pcigart_init’:
 drivers/gpu/drm/ati_pcigart.c:115: warning: format ‘%Lx’ expects type ‘long long unsigned int’, but argument 3 has type ‘dma_addr_t’

Please fix that too, the kernel build is noisy enough as-is.

Thanks,

	Ingo
