Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYJJGfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYJJGfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 02:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYJJGfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 02:35:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:54584 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbYJJGfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 02:35:03 -0400
Message-ID: <48EEF713.6050502@kernel.org>
Date: Thu, 09 Oct 2008 23:32:51 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: grundler@parisc-linux.org, matthew@wil.cx, jbarnes@virtuousgeek.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
References: <48EE8E55.4000009@kernel.org>	<20081010114003X.fujita.tomonori@lab.ntt.co.jp>	<86802c440810092156i18bb7699vb8e90d52accad781@mail.gmail.com> <20081010150815B.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081010150815B.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Thu, 9 Oct 2008 21:56:33 -0700
> "Yinghai Lu" <yinghai@kernel.org> wrote:
> 
>> On Thu, Oct 9, 2008 at 7:40 PM, FUJITA Tomonori
>> <fujita.tomonori@lab.ntt.co.jp> wrote:
>>> On Thu, 09 Oct 2008 16:05:57 -0700
>>> Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> Grant Grundler wrote:
>>>>> On Thu, Oct 09, 2008 at 02:51:32PM -0700, Yinghai Lu wrote:
>>>>>> On Thu, Oct 9, 2008 at 2:35 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>>>>>>> Why's that interesting to the sysadmin of the machine?  To the driver
>>>>>>> writer, certainly.  But what's the use of it to the people using the
>>>>>>> machine?
>>>>> ...
>>>>>> make linux kernel act like black box as other os?
>>>>> I don't understand your reply.
>>>>> If someone thinks linux is a black box, printing this message won't help them.
>>>>>
>>>> could find out easily why some driver doesn't set dma mask correctly.
>>>> like why
>>>>       qlogic qla2xxx only set consistent to 64bit,
>>>>       emulex lpfc not set consistent to 64bit
>>> IIRC, except for one SGI architecture, coherent_dma_mask is
>>> meaningless, dma_mask is always equal to coherent_dma_mask. Lots of
>>> IOMMU implementations ignore coherent_dma_mask and use dma_mask for
>>> alloc_coherent(). Some drivers doesn't set up coherent_dma_mask.
>> ehci_hcd 0000:00:02.1: using 31bit consistent DMA mask
>> ==> ck804 ehci, is using 31bit for consistent dma mask, at still use
>> 32 bit for dma mask.
> 
> ehci_hcd needs to set 31bit to dma_mask, I guess.

in ehci_pci_setup() 

        switch (pdev->vendor) {
        case PCI_VENDOR_ID_NVIDIA:
                /* NVidia reports that certain chips don't handle
                 * QH, ITD, or SITD addresses above 2GB.  (But TD,
                 * data buffer, and periodic schedule are normal.)
                 */
                switch (pdev->device) {
                case 0x003c:    /* MCP04 */
                case 0x005b:    /* CK804 */
                case 0x00d8:    /* CK8 */
                case 0x00e8:    /* CK8S */
                        if (pci_set_consistent_dma_mask(pdev,
                                                DMA_31BIT_MASK) < 0)
                                ehci_warn(ehci, "can't enable NVidia "
                                        "workaround for >2GB RAM\n");
                        break;
                }
                break;
        }

so that is strange silicon bug for old ck804 and before. dma_mask could be 32bit. but consistent_dma_mask is 31bit
mcp55 is ok.


> 
> 
>> qlogic qla2xxx  and emulex lpfc dma mask and consistent_dma_mask is different...
>> could have some story for them
> 
> Check out qla2xxx again. I think that it uses dma_set_mask() to set
> dma_mask. qla2xxx uses the same value for both dma_mask and
> consistent_dma_mask.
> 
> lpfc had better set 64bit to consistent_dma_mask but as I said in the
> previous mail, not setting consistent_dma_mask doesn't cause any
> problem. It means that some IOMMUs (uses consistent_dma_mask properly)
> allocates an address < 4GB in alloc_coherent() and some IOMMUs alloc
> address > 4GB. lpfc can handle both anyway.
> 
> 
>> at least gart iommu is honoring the consistent dma mask.
>> by calling dma_alloc_coherent_mask(dev, flag)
> 
> Well, that's because I wrote gart's alloc_coherent and introduced
> dma_alloc_coherent_mask. ;)

oh. it is in tip

> 
> 
>> if device could use 64 bit coherent dma mask, that is driver problem...
> 
> Can you be more specific? As I wrote above, if 64bit-dma-capable
> devices don't set consistent_dma_mask, we don't have any problem.

then can we remove consistent_dma_mask? just use dma_mask instead for all.

> 
> Yes, drivers that have dma_mask < 32bit need to set up
> consistent_dma_mask. But few devices have dma_mask < 32bit and we can
> fix them without the information at boot time, I think.

YH
