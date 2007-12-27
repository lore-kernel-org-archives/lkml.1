Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbXL0C7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbXL0C7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 21:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbXL0C7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 21:59:07 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:39225 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXL0C7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 21:59:01 -0500
To: dillowda@ornl.gov
Cc: tomof@acm.org, linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       pw@osc.edu, fujita.tomonori@lab.ntt.co.jp
Subject: Re: list corruption on ib_srp load in v2.6.24-rc5
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1198689251.25003.2.camel@lap75545.ornl.gov>
References: <1198275532.9979.43.camel@lap75545.ornl.gov>
	<20071223014407L.tomof@acm.org>
	<1198689251.25003.2.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071227115817I.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 27 Dec 2007 11:58:17 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2007 12:14:11 -0500
David Dillow <dillowda@ornl.gov> wrote:

> 
> On Sun, 2007-12-23 at 01:41 +0900, FUJITA Tomonori wrote:
> > transport_container_unregister(&i->rport_attr_cont) should not fail here.
> > 
> > It fails because there is still a srp rport.
> > 
> > I think that as Pete pointed out, srp_remove_one needs to call
> > srp_remove_host.
> > 
> > Can you try this?
> 
> That patched oopsed in scsi_remove_host(), but reversing the order has
> survived over 500 insert/probe/remove cycles.

Thanks,

Can you post the oops message? The srp class might have bugs related
to it.


> Tested-by: David Dillow <dillowda@ornl.gov>
> ---
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 950228f..77e8b90 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2054,6 +2054,7 @@ static void srp_remove_one(struct ib_device *device)
>  		list_for_each_entry_safe(target, tmp_target,
>  					 &host->target_list, list) {
>  			scsi_remove_host(target->scsi_host);
> +			srp_remove_host(target->scsi_host);
>  			srp_disconnect_target(target);
>  			ib_destroy_cm_id(target->cm_id);
>  			srp_free_target_ib(target);
> 
> 
