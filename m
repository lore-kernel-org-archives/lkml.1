Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbXA1VVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbXA1VVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932894AbXA1VVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:21:52 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50028 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbXA1VVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:21:52 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <greg@kroah.com>, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/6] MSI portability cleanups
References: <1169714047.65693.647693675533.qpush@cradle>
	<m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	<1170015805.26655.15.camel@localhost.localdomain>
	<45BD0BDC.40205@garzik.org>
Date: Sun, 28 Jan 2007 14:20:12 -0700
In-Reply-To: <45BD0BDC.40205@garzik.org> (Jeff Garzik's message of "Sun, 28
	Jan 2007 15:47:24 -0500")
Message-ID: <m1bqkiq25v.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Benjamin Herrenschmidt wrote:
>>> The only architecture problem that isn't solvable in this context is
>>> the problem of supporting the crazy hypervisor on the ppc RTAS, which
>>> asks us to drive the hardware but does not give us access to the
>>> hardware registers.
>>
>> So you are saying that we should use your model while admitting that it
>> can't solve our problems...
>>
>> I really don't understand why you seem so totally opposed to Michael's
>> approach which definitely looks to me like the sane thing to do. Note
>> that in the end, Michael's approach isn't -that- different from yours,
>> just a bit more abstracted.
>
>
> I think the high-level ops approach makes more sense.  It's more future proof,
> in addition to covering all existing implementations.

I'm not arguing against an operations based approach.  I'm arguing for simple
obviously correct steps, and not throwing the baby out with the bath
water.

My patches should be a precursor to an operations based approach
because they are simple step from where we are now.

Every keeps telling me the operations approach is the right thing to
do and I see code that doesn't work, and can't work without extreme
difficulty on the architectures currently supported.  That makes me
irritated, and unfortunately much less accepting.

I see people pushing ridiculous interfaces like the RTAS hypervisor
interface at me, and saying we must support running firmware drivers
in the msi code.

I just ask for simple evolutionary change as I presented, so we don't
break things or loose requirements along the way.

Please argue with me on the details of what the ops based approach does
better, which specific problems does it solve. 

The proposed ops base approach mixes different kinds of operations
in the same structure:

We have the hardware operations:
+	/* enable - Enable the MSIs on the given device.
+	 *
+	 * @pdev:	PCI device structure.
+	 * @num:	The number of MSIs being requested.
+	 * @entries:	An array of @num msix_entry structures.
+	 * @type:	The type, MSI or MSI-X.
+	 *
+	 * This routine enables the MSIs on the given PCI device.
+	 *
+	 * If the enable completes succesfully this routine must return 0.
+	 *
+	 * This callback is optional.
+	 */
+	int (*enable) (struct pci_dev *pdev, int num,
+				struct msix_entry *entries, int type);
+
+	/* disable - disable the MSI for the given device.
+	 *
+	 * @pdev:	PCI device structure.
+	 * @num:	The number of MSIs to disable.
+	 * @entries:	An array of @num msix_entry structures.
+	 * @type:	The type, MSI or MSI-X.
+	 *
+         * This routine should perform the inverse of enable.
+	 */
+	void (*disable) (struct pci_dev *pdev, int num,
+				struct msix_entry *entries, int type);
+

Which are either talking directly to the hardware, or are talking
to the hypervisor, which is using hardware isolation so it is safe to
talk directly to the hardware but isn't leting us?  If we could use
things to work around errata in card implementation details it would
make some sense to me (although we don't seem to have any cards with
that got the MSI registers wrong at this point).  Regardless these
operations clearly have a different granularity than the other
operations, and should have a different lookup method.


We have the irq operations.
+	/* check - Check that the requested MSI allocation is OK.
+	 *
+	 * @pdev:	PCI device structure.
+	 * @num:	The number of MSIs being requested.
+	 * @entries:	An array of @num msix_entry structures.
+	 * @type:	The type, MSI or MSI-X.
+	 *
+	 * This routine is responsible for checking that the given PCI device
+	 * can be allocated the requested type and number of MSIs.
+	 *
+	 * It is up to this routine to determine if the requested number of
+	 * MSIs is valid for the device in question. If the number of MSIs,
+	 * or the particular MSI entries, can not be supported for any
+	 * reason this routine must return non-zero.
+	 *
+	 * If the check is succesful this routine must return 0.
+	 */
+	int (*check) (struct pci_dev *pdev, int num,
+				struct msix_entry *entries, int type);
+
+	/* alloc - Allocate MSIs for the given device.
+	 *
+	 * @pdev:	PCI device structure.
+	 * @num:	The number of MSIs being requested.
+	 * @entries:	An array of @num msix_entry structures.
+	 * @type:	The type, MSI or MSI-X.
+	 *
+	 * This routine is responsible for allocating the number of
+	 * MSIs to the given PCI device.
+	 *
+	 * Upon completion there must be @num MSIs assigned to this device,
+	 * the "vector" member of each struct msix_entry must be filled in
+	 * with the Linux irq number allocated to it. The corresponding
+	 * irq_descs must also be setup with an appropriate handler if
+	 * required.
+	 *
+	 * If the allocation completes succesfully this routine must return 0.
+	 */
+	int (*alloc) (struct pci_dev *pdev, int num,
+				struct msix_entry *entries, int type);
+
+	/* free - free the MSIs assigned to the device.
+	 *
+	 * @pdev:	PCI device structure.
+	 * @num:	The number of MSIs.
+	 * @entries:	An array of @num msix_entry structures.
+	 * @type:	The type, MSI or MSI-X.
+	 *
+	 * Free all MSIs and associated resources for the device. If any
+	 * MSIs have been enabled they will have been disabled already by
+	 * the generic code.
+	 */
+	void (*free) (struct pci_dev *pdev, int num,
+				struct msix_entry *entries, int type);

These because they are per irq make sense as per bus operations unless
you have a good architecture definition like x86 has.  Roughly those
operations are what we currently have except the current operations
are a little simpler and easier to deal with for the architecture
code.

And then there are the operations that are going in the wrong
direction.
+	/* setup_msi_msg - Setup an MSI message for the given device.
+	 *
+	 * @pdev:	PCI device structure.
+	 * @entry:	The MSI entry to create a msi_msg for.
+	 * @msg:	Written with the magic address and data.
+	 * @type:	The type, MSI or MSI-X.
+	 *
+	 * Returns the "magic address and data" used to trigger the msi.
+	 * If the setup is succesful this routine must return 0.
+	 *
+	 * This callback is optional.
+	 */
+	int (*setup_msi_msg) (struct pci_dev *pdev, struct msix_entry *entry,
+				struct msi_msg *msg, int type);

Much to much of the operations base approach as proposed looks like
when you have a hammer every problem looks like a nail, given how much
confusion about what was put into the operations structure.

I don't mind taking a small step and making the alloc/free primitives
per bus in a generic fashion.

I don't mind supporting poorly designed hypervisor interfaces, if it
is easy.

I do strongly mind code that doesn't work, or we can't git-bisect
through to find where bugs were introduced.

Eric
