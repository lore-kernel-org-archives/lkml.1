Return-Path: <linux-kernel-owner+w=401wt.eu-S1767768AbXDFPeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767768AbXDFPeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767771AbXDFPef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:34:35 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:50663 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767768AbXDFPee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:34:34 -0400
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Burgess <aab@cichlid.com>
Cc: cebbert@redhat.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, adam radford <aradford@gmail.com>
In-Reply-To: <200704061512.l36FCFjl031431@cichlid.com>
References: <200704061512.l36FCFjl031431@cichlid.com>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 10:27:57 -0500
Message-Id: <1175873277.3677.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 08:12 -0700, Andrew Burgess wrote:
> Yes. The 3w-xxxx.c driver changed between 2.6.18 and 2.6.20 but
> nothing jumps out to my untrained eyes. Here's the diff:
> Also, I should mention that the working kernel is a fedora
> rpm (2.6.18-1.2798.fc6) so I don't know what patches are in it.
> The vmlinuz is dated Oct 6 2006.

It's actually a long standing bug in the 3w-xxxx driver.  Apparently it
assumes request sense is always the use_sg == 0 case.  This is what it
does on a request sense:

static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
{
        dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");

        /* For now we just zero the request buffer */
        memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
        tw_dev->state[request_id] = TW_S_COMPLETED;
        tw_state_request_finish(tw_dev, request_id);
....

Note that it's clearing the request buffer, which is actually zeroing the scatterlist, hence the problem.

James


