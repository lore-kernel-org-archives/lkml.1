Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbXDBHM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbXDBHM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXDBHM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:12:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:45161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbXDBHM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:12:56 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 12/17] Consistently wrap paravirt ops callsites to make them patchable
Date: Mon, 2 Apr 2007 09:11:50 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Anthony Liguori <anthony@codemonkey.ws>
References: <20070402055652.610711908@goop.org> <20070402055705.090656820@goop.org>
In-Reply-To: <20070402055705.090656820@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020911.50623.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 07:57, Jeremy Fitzhardinge wrote:
> Wrap a set of interesting paravirt_ops calls in a wrapper which makes
> the callsites available for patching.  Unfortunately this is pretty
> ugly because there's no way to get gcc to generate a function call,
> but also wrap just the callsite itself with the necessary labels.
> 
> This patch supports functions with 0-4 arguments, and either void or
> returning a value.  64-bit arguments must be split into a pair of
> 32-bit arguments (lower word first).  Small structures are returned in
> registers.

Can you please add some comments to the code explaining this a little?
Best would be perhaps a overview document in Documentation too.

> +#define PVOP_CALL0(__rettype, __op)					\

The __s shouldn't be needed for the macro arguments because
there is no shared name space with the caller.

> +	({								\
> +		__rettype __ret;					\
> +		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
> +			unsigned long long __tmp;			\
> +			unsigned long __ecx;				\
> +			asm volatile(paravirt_alt(PARAVIRT_CALL)	\

Not having the volatile would probably generate better code, but it 
seems much safer for now.

> +				     : "=A" (__tmp), "=c" (__ecx)	\
> +				     : paravirt_type(__op),		\
> +				       paravirt_clobber(CLBR_ANY)	\
> +				     : "memory", "cc");			\

And the cc clobber is also not needed

-Andi
