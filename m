Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYDWRbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYDWRbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYDWRbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:31:32 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:57171 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYDWRba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r2aNnqTrL0DYCVgkOBBAtemRacgdlMTUAkWcckkCpUy5tdq3zaYWIuZ4JXm+F332LR2k7/5+92+zuPaErusKZvCchUJGru3+jS19xcMmG8DEx99J5qlK8p9t/r8RBdiEE2u37qjPu71C6gGxJtg1uZjt00+mVSSJZCY49fR18HI=
Message-ID: <86802c440804231031w4edc0caeoa1c7e3c4b550df9f@mail.gmail.com>
Date: Wed, 23 Apr 2008 10:31:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pci: let pci_device_shutdown to call pci_disable_msi
Cc: michael@ellerman.id.au, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Greg KH" <greg@kroah.com>,
       "David Miller" <davem@davemloft.net>, "Jeff Garzik" <jeff@garzik.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Sathya Prakash" <sathya.prakash@lsi.com>
In-Reply-To: <m1hcdsoh1i.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804222148.17530.yhlu.kernel@gmail.com>
	 <1208928277.9212.1.camel@concordia.ozlabs.ibm.com>
	 <m1hcdsoh1i.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 6:08 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>
>  > On Tue, 2008-04-22 at 21:48 -0700, Yinghai Lu wrote:
>  >> this change
>  >>
>  >> | commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
>  >> | Author: Prakash, Sathya <sathya.prakash@lsi.com>
>  >> | Date:   Fri Mar 7 15:53:21 2008 +0530
>  >> |
>  >> |     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
>  >> |
>  >> | This patch modifies the driver to enable MSI by default for all SAS chips.
>  >> |
>  >> |     Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
>  >> |     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>  >> |
>  >> cause kexec RHEL 5.1 kernel fail.
>  >>
>  >> root casue: the rhel 5.1 kernel still use INTx emulation.
>  >> and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec
>  > path
>  >>
>  >> so try to call pci_disable_msi in shutdown patch
>  >
>  > How is kdump going to work? Your shutdown routine won't be called and
>  > you'll have the same problem in the 2nd kernel, won't you?
>
>  Taking a quick look our current msi initialization appears robust in
>  not assuming the state of the msi config bits.
>
>  So the only remaining problem is running older software that
>  assumes the msi config bits are in the state they should be in
>  out of reset.
>
>  YH on that score it appears I goofed a little when I gave you
>  my suggestion on how to fix this in pci_disable_msi.
>
>  If we have crazy hardware that supports multi irqs in with
>  a plain msi capability.  During initialization we mask
>  all of the irqs.
>
>  from msi_capability_init:
>         if (entry->msi_attrib.maskbit) {
>                 unsigned int maskbits, temp;
>                 /* All MSIs are unmasked by default, Mask them all */
>                 pci_read_config_dword(dev,
>                         msi_mask_bits_reg(pos, is_64bit_address(control)),
>                         &maskbits);
>                 temp = (1 << multi_msi_capable(control));
>                 temp = ((temp - 1) & ~temp);
>                 maskbits |= temp;
>                 pci_write_config_dword(dev,
>                         msi_mask_bits_reg(pos, is_64bit_address(control)),
>                         maskbits);
>         }
>
>  So it appears to truly return to the reset state we should unmask
>  them all, instead of just that one.  Not that it matters in practice,
>  but handling that corner case would be polite.

will extend that a little bit.

YH
