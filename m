Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbXBEMFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbXBEMFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 07:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932157AbXBEMFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 07:05:24 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:38185 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbXBEMFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 07:05:23 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: remove_proc_entry and read_proc
Date: Mon, 5 Feb 2007 13:05:05 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
References: <20070201160904.GC6023@localhost.sw.ru> <200702020831.58229.duncan.sands@math.u-psud.fr> <20070205113932.GA5968@localhost.sw.ru>
In-Reply-To: <20070205113932.GA5968@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702051305.06201.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Gee, thanks. I sat and wrote code side-by-side, and it looks like, even barriers
> won't fix anything, because they don't affect other CPUs.

?! The whole point of memory barriers is that they affect other CPUs.
Maybe you are thinking of compiler barriers?

> 	->proc_fops is valid			->proc_fops is valid
> 	->pde_users is 0			->pde_users is 0
> 	------------------------------------------------------------
> 
> 
> 						if (!pde->proc_fops)
> 							goto out;
> 
> 	->proc_fops = NULL;
> 	if (atomic_read(->pde_users) > 0)
> 		goto again;
> 
> 		|
> 		|				atomic_inc(->pde_users);
> 		|
> 		|
> 		|
> 		V

The proc_fops check *before* the atomic_inc is indeed pointless (notice
how I removed it in the patch I sent?).  It's the one after the atomic_inc
that prevents this race, but only if there is a memory barrier between the
atomic_inc and the check... because otherwise they could be reordered (i.e.
seen in reverse order by another CPU) giving the race.

> Modules forget to set ->owner sometimes. Also, it's still racy, because
> of the typical
> 
> 	pde = create_proc_entry();
> 	/*
> 	 *
> 	 * ->owner is NULL here, effectively, PDE without ->owner.
> 	 *
> 	 */
> 	if (pde)
> 		pde->owner = THIS_MODULE;

As long as the module calls remove_proc_entry before being unloaded,
this should be ok.

Best wishes,

Duncan.
