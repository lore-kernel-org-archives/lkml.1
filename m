Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYADCzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYADCzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYADCzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:55:08 -0500
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:59533 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYADCzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:55:05 -0500
To: dillowda@ornl.gov
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [2.6.24-rc BUGFIX] IB/srp: release transport when removing host
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1199414359.3636.13.camel@obelisk.thedillows.org>
References: <1199393485.7561.51.camel@lap75545.ornl.gov>
	<20080104094722F.fujita.tomonori@lab.ntt.co.jp>
	<1199414359.3636.13.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080104115427F.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 04 Jan 2008 11:54:27 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jan 2008 21:39:19 -0500
Dave Dillow <dillowda@ornl.gov> wrote:

> When removing the ib_srp module, srp_remove_one() does not release the
> SRP transport class when it is releasing the SCSI host. This leads to
> dangling references to kfree()'d memory, and an eventual oops.
> 
> Signed-off-by: David Dillow <dillowda@ornl.gov>

Thanks again!

Linus has already merged your previous patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b0e47c8b79154772a436f25bf7646733e1d6194c

So please resend a patch to move srp_remove_host before
scsi_remove_host instead of adding srp_remove_host.


> ---
> On Fri, 2008-01-04 at 09:47 +0900, FUJITA Tomonori wrote:
> > I think that this is the root problem and the patch fixes it in the
> > right way. Please send this patch to linux-scsi@vger.kernel.org and a
> > patch to move srp_remove_host before scsi_remove_host in
> > srp_remove_one to Roland.
> > 
> > Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Not sure if your Acked-by was for this one as well, so I left it off.

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 950228f..bdb6f85 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2053,6 +2053,7 @@ static void srp_remove_one(struct ib_device *device)
>  
>  		list_for_each_entry_safe(target, tmp_target,
>  					 &host->target_list, list) {
> +			srp_remove_host(target->scsi_host);
>  			scsi_remove_host(target->scsi_host);
>  			srp_disconnect_target(target);
>  			ib_destroy_cm_id(target->cm_id);
> 
