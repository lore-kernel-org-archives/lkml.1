Return-Path: <linux-kernel-owner+w=401wt.eu-S967612AbXG3R7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967612AbXG3R7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967323AbXG3R7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:59:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:54643 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967206AbXG3R7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RMqEkGYJP1/LlfZJ0ntWjQGkETJh5dzfvcRpZhCxO+tcpQa3hMXRzs8pjI07UVkLFkURn44Lnc+/Z9y09exzo2xauKDkIEwBjSLtRaI2ySnMmDR5qhZ3CoJ4gY680HPtQELbpMPAVZ8K0g9xWvl2D+6HWnoPsQVg1WRQW6j6HAU=
Message-ID: <1158166a0707301059w26aade27r6d6e7b7dec08559c@mail.gmail.com>
Date: Mon, 30 Jul 2007 18:59:33 +0100
From: "Denis Vlasenko" <vda.linux@googlemail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Patches for REALLY TINY 386 kernels
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Matt Mackall" <mpm@selenic.com>,
       "Jonathan Campbell" <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070718210452.GG3898@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de>
	 <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org>
	 <20070718201043.GF3898@one.firstfloor.org>
	 <469E7709.9070801@zytor.com>
	 <20070718210452.GG3898@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007 22:04, Andi Kleen wrote:
> Better just write less bloated code. Perhaps mandatory bloatometer
> runs during -rc*s for kernels with minimal config with public code pig shame lists
> similar to the regression lists are useful. Anyone volunteering?
>
> I suspect there is also much more low hanging fruit of this around.

Thousands "static int flag" variables taking 4 bytes where 1 byte
(actually 1 bit) would suffice. And when you do "flag = 1" -
store insns for bytes are also shorter by 3 bytes, _each_.

Unused code/data linked in
(-ffunction-sections -fdata-sections -Wl,--gc-sections may help)

int global_n; char global_c; int global_m;
and you lose 3 bytes to alignment.
(How to instruct linker to sort sections by alignment or at least for size?
Tried -ffunction-sections -fdata-sections -Wl,--sort-section,alignment
but it seems to only (try to) sort .data, not .data.var_name sections)

Massive inlining. Example: more than 80k of bloat in aic7*xx driver
because of gigantic inlined I/O access functions.

Sadistic alignment by gcc for structs/strings >= 32 bytes.
(gcc 4.2.1 is better, just don't forget -mpreferred-stack-boundary=2)
--
vda
