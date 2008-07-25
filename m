Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbYGYTNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbYGYTNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 15:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbYGYTMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 15:12:50 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:41643 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756166AbYGYTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 15:12:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Vz+SFmwi6murSSj9RHBi2/VXol8YFliGg87AFzB5h4CsLMc3XJIum6jeNBBp7pe0udCGaFnt2yH20x9jMUUVBBPRuDxjuVMmbELfdkHczm1jv61lTe+8LQBSUz8FthjQ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: PCI: MSI interrupts masked using prohibited method
Date: Fri, 25 Jul 2008 12:12:41 -0700
User-Agent: KMail/1.9.9
Cc: David Vrabel <david.vrabel@csr.com>, Michal Schmidt <mschmidt@redhat.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4860D09D.4060801@csr.com> <488A015D.4040107@csr.com> <20080725165655.GC17093@parisc-linux.org>
In-Reply-To: <20080725165655.GC17093@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251212.41980.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 25, 2008 9:56 am Matthew Wilcox wrote:
> On Fri, Jul 25, 2008 at 05:37:49PM +0100, David Vrabel wrote:
> > The spec says that system software should enable MSI before setting
> > message address and data (PCI 3.0 section 6.8.3.1 MSI configuration).
> > The kernel doesn't do this.
>
> I think you meant "disable"?  I can't find anything in 6.8.3.1 of 3.0
> that refers to this.
>
> > I really don't think we should be enabling/disabling MSI while
> > interrupts might be being generated.  There are cases where interrupts
> > will be lost.  Consider PCIe where we might end up with a situation
> > where MSI is disabled and then enabled sufficiently quickly that no
> > periodic line interrupt message is sent by the device.
>
> I don't think there's a difference here between PCIe and conventional
> PCI.  A device raising a line based interrupt is perfectly equivalent to
> a device sending an INTx message.
>
> > The message address and data should only be modified while the vector is
> > masked (to avoid the aforementioned 'tearing').  This means that setting
> > IRQ affinity cannot be done on devices without per-vector mask bits.  I
> > don't think this is a problem.
>
> I agree.  I think it's fine to have this limitation.
>
> > In vague psuedo-code, set_affinity() should be something like this:
> >
> > int did_mask = msi_mask_vector();
> > if (!did_mask) {
> >     return -ENOTSUPP;
> > }
> > /* fiddle with address and mask now */
> > msi_unmask_vector();
>
> Yes, something like that.

Yeah, that reflects what we actually support...

David, can you resend your "don't mask MSIs using the MSI enable bit" patch 
against the latest bits so I can apply it?  Did you also want to hack up the 
above for the affinity code?

Thanks,
Jesse
