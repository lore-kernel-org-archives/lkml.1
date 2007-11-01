Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbXKAFA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbXKAFA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 01:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbXKAFAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 01:00:18 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:32361 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751756AbXKAFAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 01:00:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KE9ydvlw7UPppvv9j94zVjXPCcnauE8FGYJCzjc560RMn4P51yUZKseehF4XIOwTWL9yUev4jRMrvXV92sgziZtazOus4bP0mVvNKqegrlAlwbd6zxjf9oGwlFGHN62mE1pyknqC1cDSpESr2xl2daz7yaA2EZiIium2RsNZ/Js=  ;
X-YMail-OSG: 1QwOMBwVM1n87q28Dfw03agtPBs9jkfV1ZbpxQIMs7X6bZA3ljxTCzbJ5WV_GAURYLBToNgRlQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-core: enforce write order when updating fw_device.generation
Date: Thu, 1 Nov 2007 14:53:35 +1100
User-Agent: KMail/1.9.5
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@redhat.com>
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
In-Reply-To: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711011453.35268.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007 12:49, Stefan Richter wrote:
> fw_device.node_id and fw_device.generation are accessed without mutexes.
> We have to ensure that all readers will get to see node_id updates
> before generation updates.
>

Hi, a few points:

- can change it to use spinlocks instead? This would be most
  preferable.

- if not, you need comments.

- you also seem to be missing rmb()s now. I see a couple in the
  firewire directory, but nothing that seems to be ordering loads
  of these particular fields.

- use smp_*mb() if you are just ordering regular cacheable RAM
  accesses.

Also, diffstat is a bit wrong... maybe you posted the wrong version?

> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/fw-device.c   |    6 ++++++
>  drivers/firewire/fw-topology.c |    1 +
>  2 files changed, 7 insertions(+)
>
> Index: linux/drivers/firewire/fw-device.c
> ===================================================================
> --- linux.orig/drivers/firewire/fw-device.c
> +++ linux/drivers/firewire/fw-device.c
> @@ -808,6 +813,7 @@ void fw_node_event(struct fw_card *card,
>
>  		device = node->data;
>  		device->node_id = node->node_id;
> +		wmb();
>  		device->generation = card->generation;
>  		if (atomic_read(&device->state) == FW_DEVICE_RUNNING) {
>  			PREPARE_DELAYED_WORK(&device->work, fw_device_update);
> Index: linux/drivers/firewire/fw-topology.c
> ===================================================================
> --- linux.orig/drivers/firewire/fw-topology.c
> +++ linux/drivers/firewire/fw-topology.c
> @@ -518,6 +518,7 @@ fw_core_handle_bus_reset(struct fw_card
>  		card->bm_retries = 0;
>
>  	card->node_id = node_id;
> +	wmb();
>  	card->generation = generation;
>  	card->reset_jiffies = jiffies;
>  	schedule_delayed_work(&card->work, 0);
