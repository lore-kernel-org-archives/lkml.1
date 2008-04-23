Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbYDWNIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbYDWNIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYDWNIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:08:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36989 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbYDWNIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:08:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
       Jeff Garzik <jeff@garzik.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sathya Prakash <sathya.prakash@lsi.com>
References: <200804222148.17530.yhlu.kernel@gmail.com>
	<1208928277.9212.1.camel@concordia.ozlabs.ibm.com>
Date: Wed, 23 Apr 2008 06:08:09 -0700
In-Reply-To: <1208928277.9212.1.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Wed, 23 Apr 2008 15:24:37 +1000")
Message-ID: <m1hcdsoh1i.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pci: let pci_device_shutdown to call pci_disable_msi
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> On Tue, 2008-04-22 at 21:48 -0700, Yinghai Lu wrote:
>> this change
>> 
>> | commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
>> | Author: Prakash, Sathya <sathya.prakash@lsi.com>
>> | Date:   Fri Mar 7 15:53:21 2008 +0530
>> |
>> |     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
>> |
>> | This patch modifies the driver to enable MSI by default for all SAS chips.
>> |
>> |     Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
>> |     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>> |
>> cause kexec RHEL 5.1 kernel fail.
>> 
>> root casue: the rhel 5.1 kernel still use INTx emulation.
>> and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec
> path
>> 
>> so try to call pci_disable_msi in shutdown patch
>
> How is kdump going to work? Your shutdown routine won't be called and
> you'll have the same problem in the 2nd kernel, won't you?

Taking a quick look our current msi initialization appears robust in
not assuming the state of the msi config bits.

So the only remaining problem is running older software that 
assumes the msi config bits are in the state they should be in
out of reset.

YH on that score it appears I goofed a little when I gave you
my suggestion on how to fix this in pci_disable_msi.

If we have crazy hardware that supports multi irqs in with
a plain msi capability.  During initialization we mask
all of the irqs.

from msi_capability_init:
        if (entry->msi_attrib.maskbit) {
                unsigned int maskbits, temp;
                /* All MSIs are unmasked by default, Mask them all */
                pci_read_config_dword(dev,
                        msi_mask_bits_reg(pos, is_64bit_address(control)),
                        &maskbits);
                temp = (1 << multi_msi_capable(control));
                temp = ((temp - 1) & ~temp);
                maskbits |= temp;
                pci_write_config_dword(dev,
                        msi_mask_bits_reg(pos, is_64bit_address(control)),
                        maskbits);
        }

So it appears to truly return to the reset state we should unmask
them all, instead of just that one.  Not that it matters in practice,
but handling that corner case would be polite.

Eric
