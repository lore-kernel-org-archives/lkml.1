Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXGWQmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXGWQmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765373AbXGWQmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:42:25 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43405 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763805AbXGWQmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:42:24 -0400
Date: Mon, 23 Jul 2007 18:43:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch warnings for early memory allocations
Message-ID: <20070723164331.GA7825@uranus.ravnborg.org>
References: <617E1C2C70743745A92448908E030B2A01FEBFA2@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617E1C2C70743745A92448908E030B2A01FEBFA2@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 09:22:14AM -0700, Luck, Tony wrote:
> Checking for section mismatches across all of vmlinux is kicking
> out a bunch of new warnings.  Many of them real, but I have a
> few from routines like this:
> 
> foo(...)
> {
> 	static int first_time = 1;
> 
> 	if (first_time) {
> 		all_i_need = alloc_bootmem(NR_CPUS * xxx);
> 		first_time = 0;
> 	}
> 	... use smp_processor_id() to use pre-allocated memory ...
> }
> 
> 
> Now this is safe, since the first call to foo is made when alloc_bootmem
> is still available.  But it kicks out a "Section mismatch" warning since
> a non __init routine (foo) is calling an __init one.
> 
> Any suggestions on how to tell modpost that this is safe?
Best way is to use __init_refok like this:

/*
 * Call an __init function only first time as guarded by first_time.
 * Teach modpost that this is OK.
 */
void __init_refok foo()
{
	if (first_time) {
		all_i_need = alloc_bootmem(NR_CPUS * xxx);
		first_time = 0;
	}
}

	Sam
