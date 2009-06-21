Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZFUE2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZFUE2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 00:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZFUE2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 00:28:34 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:60469 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbZFUE2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 00:28:34 -0400
From: Frans Pop <elendil@planet.nl>
To: Sean MacLennan <smaclennan@pikatech.com>
Subject: Re: Badness on the Warp
Date: Sun, 21 Jun 2009 06:28:33 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Gibson <david@gibson.dropbear.id.au>,
       Paul Mackerras <paulus@samba.org>
References: <20090620154824.72b5cd50@lappy.seanm.ca> <200906202256.46073.elendil@planet.nl> <20090620194250.5a3e826f@lappy.seanm.ca>
In-Reply-To: <20090620194250.5a3e826f@lappy.seanm.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906210628.35553.elendil@planet.nl>
X-OriginalArrivalTime: 21 Jun 2009 04:28:36.0474 (UTC) FILETIME=[BE7545A0:01C9F228]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 June 2009, Sean MacLennan wrote:
> I found the source of the badness. The backtrace is correct:
>
> uic_init_one

So that's in arch/powerpc/sysdev/uic.c.

> ___alloc_bootmem
> ___alloc_bootmem_nopanic
> alloc_arch_preferred_bootmem
>
> In alloc_arch_preferred_bootmem we have:
>
> 	if (WARN_ON_ONCE(slab_is_available()))
> 		return kzalloc(size, GFP_NOWAIT);
>
> Since the slab is available (it had better be or the call will return
> NULL), we get the badness message, then a successful return from
> kzalloc.
>
> I believe the author wants something like:
>
> 	if (slab_is_available())
> 		return kzalloc(size, GFP_NOWAIT);
> 	else
> 		WARN_ON_ONCE(1);

Well, I myself have no idea. It could also indicate a bug in the uic code.

But let's CC some people responsible for this code. Pekka recently added 
this WARN that triggers in your case; David and Paul look to be the 
people most involved in the uic code.

Start of the thread is at http://lkml.org/lkml/2009/6/20/165.

Cheers,
FJP
