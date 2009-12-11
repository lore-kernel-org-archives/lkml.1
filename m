Return-Path: <linux-kernel-owner+w=401wt.eu-S1762231AbZLKBuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762231AbZLKBuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762201AbZLKBuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:50:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54055 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762102AbZLKBuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:50:08 -0500
Message-ID: <4B21A50E.5090801@zytor.com>
Date: Thu, 10 Dec 2009 17:49:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Aristeu Rozanski <aris@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org,
       x86 <x86@kernel.org>
Subject: Re: [PATCH] x86, msr: add support for non-contiguous cpumasks
References: <20091207122133.GA24877@aftab>
In-Reply-To: <20091207122133.GA24877@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2009 04:21 AM, Borislav Petkov wrote:
>  
>  struct msr {
> +	int cpu;
>  	union {
>  		struct {
>  			u32 l;

I really don't like this patch, for multiple reasons.  One of them is
the above: this has no business being part of struct msr, which reflects
an MSR value (and ideally should replace at least the use of two
pointers in other places over time).  Having a CPU field and not an MSR
number field particular doesn't make any sense.

The second is a linear(!!) search executed on every CPU... at the same
time, over the same data structure.

The ideal probably would be to use a percpu variable.  Now, this would
either have to be a dynamic percpu allocation (which would have to be
the responsibility of the caller, and reused, lest this would be a
*very* expensive proposition), or we would have to make these functions
run under a mutex.  However, as long as the expected callers of this are
things that get set up once and then pretty much stick around, a percpu
variable might just work.

The slightly less radical version would be to simply require an array
that spans the extremes of the CPU numbers in the mask.  Even on a
4096-CPU system, we're only talking about 32K worth of memory here.
This is basically the original solution, just accounting for the fact
that the bitmap may be sparse when allocating it.

The third option would be to at least require that the struct msr
contents are at least serial in the order of the bitmask, not by adding
another field.

	-hpa
