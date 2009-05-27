Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbZE0I2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbZE0I2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759368AbZE0I1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:27:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:48619 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759013AbZE0I1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:27:52 -0400
Date: Wed, 27 May 2009 17:26:09 +0900
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com,
       jens.axboe@oracle.com, rdreier@cisco.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A1CF1C1.2000607@panasas.com>
References: <4A1C1331.8060304@panasas.com>
	<20090527103637W.fujita.tomonori@lab.ntt.co.jp>
	<4A1CF1C1.2000607@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090527172616R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 27 May 2009 17:26:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 10:54:41 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 05/27/2009 04:36 AM, FUJITA Tomonori wrote:
> > On Tue, 26 May 2009 19:05:05 +0300
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> On 05/26/2009 06:31 PM, FUJITA Tomonori wrote:
> >>> Can we just fix some drivers not to do the DMA with the sense buffer in
> >>> scsi_cmnd? IIRC, there are only five or six drivers that do such.
> >> This is not so.
> >> All drivers that go through scsi_eh_prep_cmnd() will eventually DMA through
> >> the regular read path. Including all the drivers that do nothing and let
> >> scsi-ml do the REQUEST_SENSE
> >>
> >> Actually I have exact numbers, from the last time I did all that
> > 
> > Hmm, we discussed this before, I think.
> > 
> 
> Sure we did I sent these patches. to summarize, 3 types of drivers:
> 1. Only memcpy into sense_buffer				- 60%
> 2. Use scsi_eh_prep_cmnd and DMA read into sense.
> 2.1 Do nothing and scsi-ml does scsi_eh_prep_cmnd		- 30%
> 3. Prepare DMA descriptors for sense_buffer before execution	- 10%
> 
> > scsi-ml uses scsi_eh_prep_cmnd only via scsi_send_eh_cmnd(). There are
> > some users of scsi_send_eh_cmnd in scsi-ml but only scsi_request_sense
> > does the DMA in the sense_buffer of scsi_cmnd.
> > 
> 
> Also drivers use scsi_eh_prep_cmnd at interrupt time and proceed to
> DMA into the sense_buffer.
> 
> > Only scsi_error_handler() uses scsi_request_sense() and
> > scsi_send_eh_cmnd() works synchronously. So scsi-ml can easily avoid
> > the the DMA in the sense_buffer of scsi_cmnd if we have one sense
> > buffer per scsi_host.
> 
> Not so. As James explained then, once you have a CHECK_CONDITION return, the
> Q-per-host is frozen, yes. But as soon as you send the REQUEST_SENSE the 
> target Q is unfrozen again and all in-flight commands can error, much before
> the REQUEST_SENSE returns.

Hmm, I'm not sure what you mean.

Why is 'all in-flight commands can error' a problem? The sense_buffer
per host is used by only scsi_eh kernel thread.
