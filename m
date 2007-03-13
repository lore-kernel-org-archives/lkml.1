Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbXCMIMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbXCMIMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 04:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXCMIMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 04:12:21 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41360 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbXCMIMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 04:12:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
References: <20070313040828.GA17893@redhat.com>
Date: Tue, 13 Mar 2007 02:11:37 -0600
In-Reply-To: <20070313040828.GA17893@redhat.com> (Dave Jones's message of
	"Tue, 13 Mar 2007 00:08:28 -0400")
Message-ID: <m1wt1ltveu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> I spent considerable time over the last day or so bisecting to
> find out why an X60 stopped resuming somewhen between 2.6.20 and current -git.
> (Total lockup, black screen of death).
>
> The bisect log looked like this.
>
> git-bisect start
> # bad: [c8f71b01a50597e298dc3214a2f2be7b8d31170c] Linux 2.6.21-rc1
> git-bisect bad c8f71b01a50597e298dc3214a2f2be7b8d31170c
> # good: [fa285a3d7924a0e3782926e51f16865c5129a2f7] Linux 2.6.20
> git-bisect good fa285a3d7924a0e3782926e51f16865c5129a2f7
> # bad: [574009c1a895aeeb85eaab29c235d75852b09eb8] Merge branch 'upstream' of
> git://ftp.linux-mips.org/pub/scm/upstream-linus
> git-bisect bad 574009c1a895aeeb85eaab29c235d75852b09eb8
> # bad: [43187902cbfafe73ede0144166b741fb0f7d04e1] Merge
> master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6
> git-bisect bad 43187902cbfafe73ede0144166b741fb0f7d04e1
> # good: [1545085a28f226b59c243f88b82ea25393b0d63f] drm: Allow for 44 bit
> user-tokens (or drm_file offsets)
> git-bisect good 1545085a28f226b59c243f88b82ea25393b0d63f
> # good: [c96e2c92072d3e78954c961f53d8c7352f7abbd7] Merge
> master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6
> git-bisect good c96e2c92072d3e78954c961f53d8c7352f7abbd7
> # good: [31c56d820e03a2fd47f81d6c826f92caf511f9ee] [POWERPC] pasemi: iommu
> support
> git-bisect good 31c56d820e03a2fd47f81d6c826f92caf511f9ee
> # bad: [78149df6d565c36675463352d0bfe0000b02b7a7] Merge
> master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6
> git-bisect bad 78149df6d565c36675463352d0bfe0000b02b7a7
> # good: [3d9c18872fa1db5c43ab97d8cbca43775998e49c] shpchp: remove
> CONFIG_HOTPLUG_PCI_SHPC_POLL_EVENT_MODE
> git-bisect good 3d9c18872fa1db5c43ab97d8cbca43775998e49c
> # good: [88187dfa4d8bb565df762f272511d2c91e427e0d] MSI: Replace pci_msi_quirk
> with calls to pci_no_msi()
> git-bisect good 88187dfa4d8bb565df762f272511d2c91e427e0d
> # good: [866a8c87c4e51046602387953bbef76992107bcb] msi: Fix
> msi_remove_pci_irq_vectors.
> git-bisect good 866a8c87c4e51046602387953bbef76992107bcb
> # good: [f7feaca77d6ad6bcfcc88ac54e3188970448d6fe] msi: Make MSI useable more
> architectures
> git-bisect good f7feaca77d6ad6bcfcc88ac54e3188970448d6fe
> # good: [14719f325e1cd4ff757587e9a221ebaf394563ee] Revert "PCI: remove duplicate
> device id from ata_piix"
> git-bisect good 14719f325e1cd4ff757587e9a221ebaf394563ee
>
> which led me to a final 'bad' commit of 78149df6d565c36675463352d0bfe0000b02b7a7
> which is a merge changeset of lots of PCI bits.

Ok.  This is weird.  It looks like you marked the merge bad but
it's individual commits as good....

Which would indicate a problem on one of the branches it was merged
with, or a problem that only shows up when both groups of changes
are present.

> Seeing a couple of MSI changes in there, on a hunch I booted latest tree with
> pci=nomsi, and it resumed again.
>
> Any ideas how to further debug this?
> I'll try backing out individual changes from that merge tomorrow.

Thanks.  

Of those msi patches you have identified I don't see anything really
obvious.  And you actually marked them as good in your bisect so
I don't expect it is core problem.

We do have a known e1000 regression, with msi and suspend/resume.
So it is possible the nomsi avoided a driver problem.  Especially
as we have a number of driver changes on the on Linus's side of
that merge.

I also know we have some known issues with pci_save_state and
pci_restore_state that require them to be paired for correct
operation.  For suspend and resume that is not generally a problem.

I have fixes for the pci_save_state and pci_restore_state in the -mm
and gregkh tree's.  Since they also happen to fix the e1000 driver as
a side effect they are worth looking at, at least if you have an
e1000.

I don't have a clue which hardware the x60 has so I don't know which
drivers it would be using.

Eric
