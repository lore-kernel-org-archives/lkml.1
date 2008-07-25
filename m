Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbYGYQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbYGYQ5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYGYQ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:57:12 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48501 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYGYQ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:57:11 -0400
Date: Fri, 25 Jul 2008 10:56:55 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: Michal Schmidt <mschmidt@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080725165655.GC17093@parisc-linux.org>
References: <4860D09D.4060801@csr.com> <48807166.9010006@csr.com> <20080722155629.1160635e@brian.englab.brq.redhat.com> <200807221052.26879.jbarnes@virtuousgeek.org> <20080725152918.43bf3100@brian.englab.brq.redhat.com> <20080725134252.GG6701@parisc-linux.org> <20080725155329.79821436@brian.englab.brq.redhat.com> <488A015D.4040107@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488A015D.4040107@csr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 05:37:49PM +0100, David Vrabel wrote:
> The spec says that system software should enable MSI before setting 
> message address and data (PCI 3.0 section 6.8.3.1 MSI configuration). 
> The kernel doesn't do this.

I think you meant "disable"?  I can't find anything in 6.8.3.1 of 3.0
that refers to this.

> I really don't think we should be enabling/disabling MSI while 
> interrupts might be being generated.  There are cases where interrupts 
> will be lost.  Consider PCIe where we might end up with a situation 
> where MSI is disabled and then enabled sufficiently quickly that no 
> periodic line interrupt message is sent by the device.

I don't think there's a difference here between PCIe and conventional
PCI.  A device raising a line based interrupt is perfectly equivalent to
a device sending an INTx message.

> The message address and data should only be modified while the vector is 
> masked (to avoid the aforementioned 'tearing').  This means that setting 
> IRQ affinity cannot be done on devices without per-vector mask bits.  I 
> don't think this is a problem.

I agree.  I think it's fine to have this limitation.

> In vague psuedo-code, set_affinity() should be something like this:
> 
> int did_mask = msi_mask_vector();
> if (!did_mask) {
>     return -ENOTSUPP;
> }
> /* fiddle with address and mask now */
> msi_unmask_vector();

Yes, something like that.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
