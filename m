Return-Path: <linux-kernel-owner+w=401wt.eu-S965276AbXAYXlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965276AbXAYXlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965284AbXAYXlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:41:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965276AbXAYXlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:41:03 -0500
Date: Thu, 25 Jan 2007 15:38:24 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Kristian =?UTF-8?B?SMO4Z3NiZXJn?= <krh@redhat.com>
Cc: linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: Juju
Message-Id: <20070125153824.8d7f50c5.zaitcev@redhat.com>
In-Reply-To: <45B91EAB.9080004@redhat.com>
References: <20070124223745.33278eb4.zaitcev@redhat.com>
	<45B91EAB.9080004@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 16:18:35 -0500, Kristian Høgsberg <krh@redhat.com> wrote:

> > I see that ORBs are always allocated with a call (like SKB) and not
> > embedded into drivers (like URBs). It's great, keep it up. Also,
> > never allow drivers to pass DMA-mapped buffers into fw_send_request
> > and friends. We made both of these mistakes in USB, and it hurts.
> 
> Oh, the ORBs are SBP-2 specific data structures, struct fw_transaction is 
> probably what corresponds to USB URBs.  This struct is defined in 
> fw-transaction.h and is available for embedding into other structs, such as 
> struct sbp2_orb in fw-sbp2.  Is that what you're suggesting against, and what 
> are the problems with this approach?

Fortunately we do not care about out-of-tree drivers, which are most
affected, you may even call it a feature ^_^. My main problem is,
we can't refcount URBs, so usbmon can't tap them and must copy.

I understand that fw_transaction points to an external buffer while
SKB does not, so any jujumon code won't be able to refcount data.
So maybe it's not important.

> As for passing DMA-mapped buffers, do you mean that fw_send_request (or code 
> below that function) should map the payload as it currently does as opposed to 
> callers pre-mapping DMA buffers?

Yes, this is what I mean. It serves well for our networking stack,
which is pretty fast. For some reason someone decided that USB users
should be let mapping their buffers. This led to big trouble with
usbmon, extra fields in URB (although already fat...), tying up precious
IOMMU resources (not so precious on x86, fortunately).

> >  	orb->rcode = rcode;
> > -	if (rcode != RCODE_COMPLETE) {
> > +	if (rcode != RCODE_COMPLETE) {		/* Huh? */
> >  		spin_lock_irqsave(&card->lock, flags);
> >  		list_del(&orb->link);
> >  		spin_unlock_irqrestore(&card->lock, flags);
> > 
> > This looks like an inverted test. Who does remove ORB from the list
> > if it's completed normally?

>[...]
> The rest of the SBP-2 transaction continues with the SBP-2 device issuing a 
> FireWire read transaction to read out the ORB from host memory and then carry 
> out the instructions in the ORB.  Once the device has completed the ORB it 
> will do a status write to the status address specified in the ORB, at which 
> point the SBP-2 transaction is complete.

You know, I wanted to use this picture for a long time:
 http://www.flickr.com/photos/zaitcev/369269557/
I hope it's all right.

I guess my problem is that I don't see just why the ORB transaction callback
is being delivered before the whole I/O was done.

Now that you drew my attention to sbp2_status_write(), this looks wrong:

        /* Lookup the orb corresponding to this status write. */
        spin_lock_irqsave(&card->lock, flags);
        list_for_each_entry(orb, &sd->orb_list, link) {
                if (status_get_orb_high(status) == 0 &&
                    status_get_orb_low(status) == orb->request_bus) {
                        list_del(&orb->link);
                        break;
                }
        }
        spin_unlock_irqrestore(&card->lock, flags);

Why is it that fw_request can't carry a pointer?

> >  	orb->request.response.high    = 0;
> >  	orb->request.response.low     = orb->response_bus;
> > +	/*
> > +	 * XXX Kristian, what exactly makes you think that DMA address
> > +	 * is 32 bits wide above? This is only guaranteed if device->
> > +	 * card->device has mask 0xffffffff. Where is that set?
> > +	 */
> 
> I guess that should be in pci_probe in fw-ohci.c, but it isn't. If the 
> allocation is in physical memory above the 4G limit, will dma_map_single set 
> up a trampoline buffer below 4G if the device DMA mask is 0xffffffff?

If an IOMMU (or SWIOTLB) is not available, dma_map_single will fail.
If IOMMU is available, it will allocate a mapping so that DMA address
is constrained, failing if tables are full. At least this was my
understanding. However, I implemented that many years ago.

>  I have 
> a similar problem when mapping the buffer passed down from the SCSI stack, in 
> that I don't know for sure that these buffers are accessible within the first 4G.

Please ask James, I do not remember that either.

For block layer, Jens guarantees it for you (it's controlled by
blk_queue_bounce_limit), but I am not sure about SCSI. I don't expect
it to have bounce buffers though.

> > Obvious.
> 
> Huh? What do you mean?

I meant the replacement of the tests for zero with dma_mapping_error().

> > @@ -450,16 +458,18 @@ sbp2_send_management_orb(struct fw_unit *unit, int node_id, int generation,
> >  
> >  	retval = 0;
> >   out:
> > -	dma_unmap_single(device->card->device, orb->base.request_bus,
> > -			 sizeof orb->request, DMA_TO_DEVICE);
> >  	dma_unmap_single(device->card->device, orb->response_bus,
> >  			 sizeof orb->response, DMA_FROM_DEVICE);
> > + out_orbresp:
> > +	dma_unmap_single(device->card->device, orb->base.request_bus,
> > +			 sizeof orb->request, DMA_TO_DEVICE);
> > + out_orbreq:
> >  
> >  	if (response)
> >  		fw_memcpy_from_be32(response,
> >  				    orb->response, sizeof orb->response);
> >  	kfree(orb);
> > -
> > + out_orballoc:
> >  	return retval;
> >  }
> >  
> > 
> > This is how to use "out" labels properly, kernel style.
> 
> Yeah, I guess... I did actually track down every function call in the destroy 
> path to make sure that they're safe to call on the values that kzalloc sets 
> them to.

I challenge this claim. I am pretty sure that dma_unmap_single on a buffer
that wasn't mapped in the first place can cause havoc, primarily because
zero bus address can be valid.

> > @@ -917,28 +930,32 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
> >  	orb->base.request_bus =
> >  		dma_map_single(device->card->device, &orb->request,
> >  			       sizeof orb->request, DMA_TO_DEVICE);
> > +	if (dma_mapping_error(orb->base.request_bus)) {
> > +		kfree(orb);
> > +		cmd->result = DID_ERROR << 16;	/* XXX Better error? */
> > +		done(cmd);
> > +		return 0;
> > +	}
> 
> Yikes, I thought I had most of the dma_map_single error cases handled.

Well, on SPARC we lived for years with a panic when IOMMU ran out and
nothing happened, so no biggie. It never happens. And when it does
you're dead anyway. Testing this is important in network drivers,
where the host can recover from running out of IOMMU.

> None of the wire structs have any 16-bit fields, though, 
> I've intentionally made them all 32 bit values.

I figured as much, but I don't know 1394 enough to be sure.

> Indeed, I've just moved to an in-tree development model now.  I still think 
> the out-off-tree model is a good way to prototype, get started and reach 
> "critical mass" with your driver.

Yeah, repo is far smaller. Maybe I'm just so used to building
throwaway kernels for every test driver.

-- Pete
