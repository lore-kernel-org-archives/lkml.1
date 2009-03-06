Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZCFUUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZCFUUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbZCFUU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:20:26 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:54484 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZCFUU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:20:26 -0500
Date: Fri, 6 Mar 2009 13:20:24 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 3/7] PCI: reserve bus range for SR-IOV device
Message-ID: <20090306202024.GF25995@parisc-linux.org>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-4-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235112888-9524-4-git-send-email-yu.zhao@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 02:54:44PM +0800, Yu Zhao wrote:
> +static inline void virtfn_bdf(struct pci_dev *dev, int id, u8 *busnr, u8 *devfn)
> +{
> +	u16 bdf;
> +
> +	bdf = (dev->bus->number << 8) + dev->devfn +
> +	      dev->sriov->offset + dev->sriov->stride * id;
> +	*busnr = bdf >> 8;
> +	*devfn = bdf & 0xff;
> +}

I find the interface here a bit clunky -- a function returning void
while having two OUT parameters.  How about this variation on the theme
(viewers are encouraged to come up with their own preferred
implementations and interfaces):

static inline __pure u16 virtfn_bdf(struct pci_dev *dev, int id)
{
	return (dev->bus->number << 8) + dev->devfn + dev->sriov->offset +
		dev->sriov->stride * id;
}

#define VIRT_BUS(dev, id)	(virtfn_bdf(dev, id) >> 8)
#define VIRT_DEVFN(dev, id)	(virtfn_bdf(dev, id) & 0xff)

We rely on GCC to do CSE and not actually invoke virtfn_bdf more than
once.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
