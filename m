Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbYACIbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbYACIbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYACIa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:30:58 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50825 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbYACIa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:30:58 -0500
Date: Thu, 3 Jan 2008 17:30:20 +0900
To: rdreier@cisco.com
Cc: tomof@acm.org, dillowda@ornl.gov, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, pw@osc.edu,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: list corruption on ib_srp load in v2.6.24-rc5
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <adaprwkundh.fsf@cisco.com>
References: <20071223014407L.tomof@acm.org>
	<1198689251.25003.2.camel@lap75545.ornl.gov>
	<adaprwkundh.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080103173330T.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jan 2008 09:51:38 -0800
Roland Dreier <rdreier@cisco.com> wrote:

>  > > Can you try this?
>  > 
>  > That patched oopsed in scsi_remove_host(), but reversing the order has
>  > survived over 500 insert/probe/remove cycles.
>  > 
>  > Tested-by: David Dillow <dillowda@ornl.gov>
>  > ---
>  > diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
>  > index 950228f..77e8b90 100644
>  > --- a/drivers/infiniband/ulp/srp/ib_srp.c
>  > +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>  > @@ -2054,6 +2054,7 @@ static void srp_remove_one(struct ib_device *device)
>  >  		list_for_each_entry_safe(target, tmp_target,
>  >  					 &host->target_list, list) {
>  >  			scsi_remove_host(target->scsi_host);
>  > +			srp_remove_host(target->scsi_host);
>  >  			srp_disconnect_target(target);
> 
> Where do we stand on this?  What is the right place to put the
> srp_remove_host?  Is there a bug somewhere else?

{sas|fc}_remove_host is called before scsi_remove_host. And in
srp_remove_work(), we call srp_remove_host and then
scsi_remove_host. ibmvscsi also calls them in that order.

I thought that I messed up something in srp_transport_class. But I
can't figure out what's wrong. The above patch works and is unlikely
to lead to critical problems so I'm fine with it for now.


> I'd like to get this fixed before 2.6.24 final comes out...

Yeah, it should be fixed.
