Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbYCQUSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbYCQUSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbYCQUSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:18:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:35880 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbYCQUSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:18:22 -0400
Message-ID: <fa686aa40803171318w37b7a97coa483fad518bb642b@mail.gmail.com>
Date: Mon, 17 Mar 2008 14:18:20 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
Subject: Re: [PATCH 2/3] Xilinx: hwicap: Verify sync before reading idcode.
Cc: git-dev@xilinx.com, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080317173645.7A21D9A8069@mail131-sin.bigfish.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1205775392-32222-1-git-send-email-stephen.neuendorffer@xilinx.com>
	 <1205775392-32222-2-git-send-email-stephen.neuendorffer@xilinx.com>
	 <20080317173645.7A21D9A8069@mail131-sin.bigfish.com>
X-Google-Sender-Auth: b93c6d781b38b51c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 11:36 AM, Stephen Neuendorffer
<stephen.neuendorffer@xilinx.com> wrote:
> It appears that in some cases, the sync word might not be recognized
>  by the hardware correctly.  If this happens, then attempting to read
>  from the port results in an unrecoverable error because of the design
>  of the FPGA core.  This patch updates the code to check the status of
>  the device before reading the IDCODE, in order to avoid entering this
>  unrecoverable state.  This patch also adds additional NOOP commands
>  into the sychronization sequence, which appears to be necessary to
>  avoid the condition on some hardware.
>
>  Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>

>  ---
>   drivers/char/xilinx_hwicap/xilinx_hwicap.c |   18 ++++++++++++++++++
>   1 files changed, 18 insertions(+), 0 deletions(-)
>
>  diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
>  index 304727d..5b8d646 100644
>  --- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
>  +++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
>  @@ -250,8 +250,26 @@ static int hwicap_get_configuration_register(struct hwicap_drvdata *drvdata,
>          * Create the data to be written to the ICAP.
>          */
>         buffer[index++] = XHI_DUMMY_PACKET;
>  +       buffer[index++] = XHI_NOOP_PACKET;
>         buffer[index++] = XHI_SYNC_PACKET;
>         buffer[index++] = XHI_NOOP_PACKET;
>  +       buffer[index++] = XHI_NOOP_PACKET;
>  +
>  +       /*
>  +        * Write the data to the FIFO and initiate the transfer of data present
>  +        * in the FIFO to the ICAP device.
>  +        */
>  +       status = drvdata->config->set_configuration(drvdata,
>  +                                                   &buffer[0], index);
>  +       if (status)
>  +               return status;
>  +
>  +       /* If the syncword was not found, then we need to start over. */
>  +       status = drvdata->config->get_status(drvdata);
>  +       if ((status & XHI_SR_DALIGN_MASK) != XHI_SR_DALIGN_MASK)
>  +               return -EIO;
>  +
>  +       index = 0;
>         buffer[index++] = hwicap_type_1_read(reg) | 1;
>         buffer[index++] = XHI_NOOP_PACKET;
>         buffer[index++] = XHI_NOOP_PACKET;
>  --
>  1.5.3.4-dirty
>
>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
