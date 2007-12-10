Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbXLJTjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbXLJTjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbXLJTiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:38:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbXLJTiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:38:54 -0500
Date: Mon, 10 Dec 2007 14:32:50 -0500 (EST)
Message-Id: <20071210.143250.39153367.k-ueda@ct.jp.nec.com>
To: bharrosh@panasas.com
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 27/28] blk_end_request: changing scsi mid-layer for
 bidi (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <475BB8C3.9040700@panasas.com>
References: <4757BFDC.6090502@panasas.com>
	<20071206.144417.41628995.k-ueda@ct.jp.nec.com>
	<475BB8C3.9040700@panasas.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boaz,

On Sun, 09 Dec 2007 11:43:31 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>> Index: 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
> <snip>
> >> No I don't like it. The only client left for blk_end_request_callback()
> >> is bidi,
> > 
> > ide-cd (cdrom_newpc_intr) is another client.
> > So I can't drop blk_end_request_callback() even if bidi doesn't use it.
>
> It looks like all is needed for the ide-cd case is a flag that says
> "don't complete the request". And the call-back is not actually used.
> (Inspecting the last: [PATCH 26/28] blk_end_request: changing ide-cd (take 3))
> The same exact flag could also help the bidi case. Perhaps have an API
> for that?

Thank you for looking at the ide-cd part, too.

But, no, I don't want to add the "don't complete" flag to the API.
It could be an alternative, but having such a flag explicitly may blur
the purpose of the blk_end_reuqest interfaces, which drivers give over
the ownership of the request to the block-layer when calling
blk_end_request interfaces.
(With such a flag, the API looks like explicitly allowing drivers
 to have the ownership of the request even after the API is called,
 and it is like end_that_request_chunk().)
And the API also looks easy to use for drivers and it might help
to make other tricky drivers in the future.

I would like to go with the callback API, since the usege in ide-cd
shows that the driver is very tricky and the API can be used for
other requirements like "a driver wants to do something after data
completion and before request completion."


> > Index: 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
> > ===================================================================
> > --- 2.6.24-rc3-mm2.orig/drivers/scsi/scsi_lib.c
> > +++ 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
> > @@ -629,28 +629,6 @@ void scsi_run_host_queues(struct Scsi_Ho
> >  		scsi_run_queue(sdev->request_queue);
> >  }
> >  
snip
> > +int blk_end_request(struct request *rq, int uptodate, int nr_bytes)
> > +{
> > +	return blk_end_io(rq, uptodate, nr_bytes, 0, NULL);
> > +}
> >  EXPORT_SYMBOL_GPL(blk_end_request);
> >  
> 
> All above looks fine, thanks.

OK, I'll update the patch-set using the bidi API and blk_end_io().
I'm currently updating the patch-set based on 2.6.24-rc4, not -mm.
So the new patch-set will include the blk_end_bidi_request() API
but not the scsi bidi changes.

Thanks,
Kiyoshi Ueda
