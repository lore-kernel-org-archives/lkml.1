Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbZFXMa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbZFXMa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbZFXMaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:30:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:59006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbZFXMav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:30:51 -0400
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090624122209.GC20564@elte.hu>
References: <4A418254.9050607@lwfinger.net>
	 <1245845787.3093.3.camel@localhost.localdomain>
	 <20090624122209.GC20564@elte.hu>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 18:00:16 +0530
Message-Id: <1245846616.3093.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 14:22 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Tue, 2009-06-23 at 20:33 -0500, Larry Finger wrote:
> > > My latest pull from Linus's tree fails to boot. Bisection leads to the
> > > commit entitled "x86/ACPI: Correct maximum allowed _CRS returned
> > > resources and warn if exceeded" with hash
> > > f9cde5ffed17bf74f6bef042d99edb0622f58576. I have been unable to
> > > capture the first error message as it scrolls off the screen, but the
> > > second hits the WARN_ON at drivers/ata/ahci.c:695 in routine
> > > ahci_enable_ahci() because HOST_AHCI_EN is not set.
> > > 
> > 
> > This patch fixes boot failure on my AMD 64 laptop, can you please test
> > this patch:
> > 
> > [PATCH] x86: fix _CRS resources return handling
> > 
> > We need to check for info->res_num and only handle for < PCI_BUS_NUM_RESOURCES
> > 
> > Also set info->bus->resource[info->res_num] for _CRS resources return handling
> > 
> > Fixed boot failure on some machine.
> > 
> > Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/pci/acpi.c |   16 ++++++++++------
> >  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> Ah, nice! I suspect it was this upstream commit causing it:
> 
> f9cde5f: x86/ACPI: Correct maximum allowed _CRS returned resources and warn if exceeded
> 
> right?

Yes :

git-bisect start
[jaswinder@hpdv5 linux-2.6-tip]$ git-bisect bad
[jaswinder@hpdv5 linux-2.6-tip]$ git-bisect good d06063cc221fdef
Bisecting: 612 revisions left to test after this
[59835e6e10a76865be52da556e76d77afb7c6bb6] Merge branch 'sched/urgent'


git-bisect good
Bisecting: 334 revisions left to test after this
[df36b439c5fedefe013d4449cb6a50d15e2f4d70] Merge branch 'for-2.6.31' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6

git-bisect bad
Bisecting: 167 revisions left to test after this
[59ef7a83f1127038a433464597df02e2dc9540e7] Merge branch 'linux-next' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6

git-bisect bad
Bisecting: 92 revisions left to test after this
[5165aece0efac6574fc3e32b6f1c2a964820d1c6] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6

git-bisect good
Bisecting: 37 revisions left to test after this
[1eb3948716f68bdb71509d0175765295f1aca23d] PCI: use pci_is_root_bus() in pci_common_swizzle()

git-bisect good
Bisecting: 18 revisions left to test after this
[7d9a73f6dcf4390d256bf19330c81e91523a26d5] PCI PM: consistently use type bool for wake enable variable

git-bisect bad
Bisecting: 9 revisions left to test after this
[70298c6e6c1ba68346336b4ea54bd5c0abbf73c8] PCI AER: support Multiple Error Received and no error source id

git-bisect good
Bisecting: 4 revisions left to test after this
[f85876ba82281f15bc4da11e41b94243a8b2b5b4] PCI: support PM D0hot->D3 transition reset

git-bisect good
Bisecting: 2 revisions left to test after this
[d2abdf62882d982c58e7a6b09ecdcfcc28075e2e] PCI PM: Fix handling of devices without PM support by pci_target_state()

git-bisect good
Bisecting: 1 revisions left to test after this
[f9cde5ffed17bf74f6bef042d99edb0622f58576] x86/ACPI: Correct maximum allowed _CRS returned resources and warn if exceeded

git-bisect bad
Bisecting: 0 revisions left to test after this
[ab7de999a2c771482698efa6fe7c7b7fcb1d482a] PCI: remove invalid comment of msi_mask_irq()

 git-bisect good
f9cde5ffed17bf74f6bef042d99edb0622f58576 is first bad commit
commit f9cde5ffed17bf74f6bef042d99edb0622f58576
Author: Gary Hade <garyhade@us.ibm.com>
Date:   Wed May 27 12:41:44 2009 -0700

    x86/ACPI: Correct maximum allowed _CRS returned resources and warn if exceeded
    
    Issue a warning if _CRS returns too many resource descriptors to be
    accommodated by the fixed size resource array instances.  If there is no
    transparent bridge on the root bus "too many" is the
    PCI_BUS_NUM_RESOURCES size of the resource array.  Otherwise, the last 3
    slots of the resource array must be excluded making the maximum
    (PCI_BUS_NUM_RESOURCES - 3).
    
    The current code:
     - is silent when _CRS returns too many resource descriptors and
     - incorrectly allows use of the last 3 slots of the resource array
       for a root bus with a transparent bridge
    
    Signed-off-by: Gary Hade <garyhade@us.ibm.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

:040000 040000 b1b02b4085b3ebd774ed5bcbf166b2957312bdf5 b7e4d2681c8e2615378df21a6489c5dde22a1954 M	arch

Thanks,
--
JSR

