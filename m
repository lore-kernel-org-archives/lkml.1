Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXB1WTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXB1WTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbXB1WTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:19:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:40871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbXB1WTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:19:19 -0500
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] bonding: replace system timer with work queue
Date: Wed, 28 Feb 2007 14:18:01 -0800
Organization: OSDL
Message-ID: <20070228141801.065d0acb@freekitty>
References: <Pine.LNX.4.61.0702281000050.9439@tm8103-a.perex-int.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1172701081 30088 10.8.0.54 (28 Feb 2007 22:18:01 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Wed, 28 Feb 2007 22:18:01 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 10:12:01 +0100 (CET)
Jaroslav Kysela <perex@suse.cz> wrote:

> Hi,
> 
> 	please, review and apply to mm tree for further testing. The patch 
> is also available at 
> ftp://ftp.alsa-project.org/pub/kernel-patches/bonding-workqueue.patch .
> 
> 					Thank you,
> 						Jaroslav
> 

You should submit network patches to the entry in the MAINTAINERS file.

BONDING DRIVER
P:	Chad Tindel
M:	ctindel@users.sourceforge.net
P:	Jay Vosburgh
M:	fubar@us.ibm.com
L:	bonding-devel@lists.sourceforge.net
W:	http://sourceforge.net/projects/bonding/
S:	Supported


> @@ -3569,20 +3552,20 @@ static int bond_close(struct net_device 
>  	 */
>  
>  	if (bond->params.miimon) {  /* link check interval, in milliseconds. */
> -		del_timer_sync(&bond->mii_timer);
> +		cancel_rearming_delayed_workqueue(bond_wq, &bond->mii_work);
>  	}
>  
>  	if (bond->params.arp_interval) {  /* arp interval, in milliseconds. */
> -		del_timer_sync(&bond->arp_timer);
> +		cancel_rearming_delayed_workqueue(bond_wq, &bond->arp_work);
>  	}
>  
>  	switch (bond->params.mode) {
>  	case BOND_MODE_8023AD:
> -		del_timer_sync(&(BOND_AD_INFO(bond).ad_timer));
> +		cancel_rearming_delayed_workqueue(bond_wq, &(BOND_AD_INFO(bond).ad_work));
>  		break;
>  	case BOND_MODE_TLB:
>  	case BOND_MODE_ALB:
> -		del_timer_sync(&(BOND_ALB_INFO(bond).alb_timer));
> +		cancel_rearming_delayed_workqueue(bond_wq, &(BOND_ALB_INFO(bond).alb_work));
>  		break;
>  	default:
>  		break;


This part will deadlock since it is not safe to cancel a workqueue
entry with RTNL mutex held. The cancel operation has to wait for the workqueue
to run, and the entry being run maybe stuck waiting for the RTNL.



-- 
Stephen Hemminger <shemminger@linux-foundation.org>
