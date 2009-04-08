Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZDHDmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZDHDmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 23:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZDHDm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 23:42:29 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:54248 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbZDHDm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 23:42:28 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 1/2] Avoid putting a bad page back on the LRU
Date: Wed, 8 Apr 2009 05:43:15 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>
References: <20090408001133.GB27170@sgi.com>
In-Reply-To: <20090408001133.GB27170@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904080543.16454.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russ,

On Wednesday 08 April 2009, Russ Anderson wrote:
> --- linux-next.orig/mm/migrate.c	2009-04-07 18:32:12.781949840 -0500
> +++ linux-next/mm/migrate.c	2009-04-07 18:34:19.169736260 -0500
> @@ -693,6 +696,26 @@ unlock:
>   		 * restored.
>   		 */
>   		list_del(&page->lru);
> +#ifdef CONFIG_MEMORY_FAILURE
> +		if (PagePoison(page)) {
> +			if (rc == 0)
> +				/*
> +				 * A page with a memory error that has
> +				 * been migrated will not be moved to
> +				 * the LRU.
> +				 */
> +				goto move_newpage;
> +			else
> +				/*
> +				 * The page failed to migrate and will not
> +				 * be added to the bad page list.  Clearing
> +				 * the error bit will allow another attempt
> +				 * to migrate if it gets another correctable
> +				 * error.
> +				 */
> +				ClearPagePoison(page);

Clearing the flag doesn't change the fact, that this page is representing 
permanently bad RAM.

What about removing it from the LRU and adding it to a bad RAM list in every case?
After hot swapping the physical RAM banks it could be moved back, not before.


Best Regards

Ingo Oeser
