Return-Path: <linux-kernel-owner+w=401wt.eu-S936488AbXHMS5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936488AbXHMS5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1033448AbXHMSqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:46:24 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51369 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934345AbXHMSqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:46:18 -0400
Date: Mon, 13 Aug 2007 19:44:48 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Len Brown <len.brown@intel.com>,
       Henrique de Moraes Holshuh <hmh@hmh.eng.br>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: 2.6.23-rc3 regression and bisection query
Message-ID: <Pine.LNX.4.64.0708131905280.13982@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Two issues in this mail, sorry if I'd have done better to separate them.

One: Thinkpad T43p suspend-to-RAM regression.

Verily, what Len giveth with one hand, he taketh away with the other.
Henrique's fix to CONFIG_THINKPAD_ACPI_INPUT_ENABLED default is now in,
thanks, so Fn-F4 ought now to Suspend to RAM on the Thinkpad T43p.
Except that it doesn't.

Git bisection (with manual fixups to i386 mmiocfg horror, thanks
for drawing attention to that in your changelog) accuses Alexey's
ACPI: EC: If ECDT is not found, look up EC in DSDT
cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
and if I revert that along with Len's subsequent
ACPI: EC: fix build warning
52fe4bdf40bc07498c5f7935551774e8f8458190
then I have Fn-F4 suspending to RAM again.

It's not obvious to me how Alexey's patch might be interfering with
Thinkpad STR, but of course I can try any patches suggested.  Hmm,
does "echo mem >/sys/power/state" work instead?  Apparently, except
then we cannot resume after, the screen remains blank - though I'm
not in the habit of using /sys/power/state, maybe that's unrelated.

Two: oddity noticed in doing that git bisection.

I'd told it v2.6.23-rc2 good and v2.6.23-rc3 bad.  Happily rebooting
various versions of 2.6.23-rc2-git (CONFIG_LOCALVERSION="-git").
Caught by surprise when I realized that actually the last few kernels
it had built were actually 2.6.23-rc1-git.  Bisection log below from
a correct second attempt: git --version 1.5.2.4.

Is that right?  I realize that git is not linear (and "git bisect
visualize" had shown me James steaming up a branch line past Gordon
and Thomas and Trevor); but I had imagined that tags set barriers
past which commits might not move later (and if tags don't do that,
then I'm unclear what purpose tags do serve).

Or was Len's tree lacking something when you pulled from it?

Thanks,
Hugh

# bad: [39d3520c92cf7a28c07229ca00cc35a1e8026c77] Linux 2.6.23-rc3
# good: [d4ac2477fad0f2680e84ec12e387ce67682c5c13] Linux 2.6.23-rc2
git-bisect start 'v2.6.23-rc3' 'v2.6.23-rc2'
# good: [660ca5317d229ca27dec6a3159423bc0c5291c2d] Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
git-bisect good 660ca5317d229ca27dec6a3159423bc0c5291c2d
# good: [dc8a7b11aa68d6795a46e0a42ce92220d1a6f0cd] Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block
git-bisect good dc8a7b11aa68d6795a46e0a42ce92220d1a6f0cd
# good: [dc8a7b11aa68d6795a46e0a42ce92220d1a6f0cd] Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block
git-bisect good dc8a7b11aa68d6795a46e0a42ce92220d1a6f0cd
# good: [3b6919e536865703a0d5c823f5a34c86cedd07cf] pull asus sony thinkpad into release branch
git-bisect good 3b6919e536865703a0d5c823f5a34c86cedd07cf
# bad: [d88da66f9397f06f3a7b4e5148bd5e71cb9d7952] Pull ec into release branch
git-bisect bad d88da66f9397f06f3a7b4e5148bd5e71cb9d7952
# good: [d8dd3cbcf1b30c315a28f65cb719bb2d7105a317] Pull bugzilla-8842 into release branch
git-bisect good d8dd3cbcf1b30c315a28f65cb719bb2d7105a317
# bad: [07ddf768d860bee7bd6581b7af3ce1009dbd05d0] ACPI: EC: acpi_ec_remove(): fix use-after-free
git-bisect bad 07ddf768d860bee7bd6581b7af3ce1009dbd05d0
# bad: [cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b] ACPI: EC: If ECDT is not found, look up EC in DSDT.
git-bisect bad cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
# good: [f1cd1fe61b96e4312312d42c0a9784dfab12e007] ACPI: EC: Remove noisy debug printk fron EC driver.
git-bisect good f1cd1fe61b96e4312312d42c0a9784dfab12e007
