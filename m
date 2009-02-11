Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbZBKRiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbZBKRiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZBKRik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:38:40 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:58508 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbZBKRik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:38:40 -0500
Date: Wed, 11 Feb 2009 10:38:38 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, dwmw2@infradead.org, linux-pci@vger.kernel.org,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] PCI: support the ATS capability
Message-ID: <20090211173838.GC3624@parisc-linux.org>
References: <1232252254-7614-1-git-send-email-yu.zhao@intel.com> <1232252254-7614-2-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232252254-7614-2-git-send-email-yu.zhao@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 12:17:29PM +0800, Yu Zhao wrote:
> +/**
> + * pci_ats_qdep - query ATS invalidate queue depth
> + * @dev: the PCI device
> + *
> + * Returns the queue depth on success, or 0 on error.
> + */
> +int pci_ats_qdep(struct pci_dev *dev)
> +{
> +	int pos;
> +	u16 cap;
> +
> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS);
> +	if (!pos)
> +		return 0;
> +
> +	pci_read_config_word(dev, pos + PCI_ATS_CAP, &cap);
> +
> +	return PCI_ATS_CAP_QDEP(cap) ? : PCI_ATS_MAX_QDEP;
> +}

The only concern I have with this patch is that every time we enable,
disable or call qdep (ok, maybe I have a second problem with 'qdep'
instead of spelling out 'queue_depth'), we call
pci_find_ext_capability() which is not necessarily cheap.  I can't tell
from this series of patches whether this is a real performance problem
or whether we ask for the qdep once per device per boot.

There was a performance problem with the MSI code when it would try to
pci_find_capability() the MSI cap in the interrupt handler.  This was
fixed long ago by caching the pos of the cap, so I want to be sure we're
not making the same mistake again here.

Hm, a third problem is that the empty ? : is really confusing and
generally to be avoided.  GCC should be able to figure out that it's a
pure/const function anyway and avoid recalculating it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
