Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbXK2ALq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbXK2ALq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbXK2ALi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:11:38 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54096 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750787AbXK2ALh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:11:37 -0500
Date: Wed, 28 Nov 2007 16:11:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
In-Reply-To: <474DFD7E.907@goop.org>
Message-ID: <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com>
 <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Jeremy Fitzhardinge wrote:

 > Yes, I would like to convert x86_64 to match i386's percpu, and drop the
> pda altogether.  The only thing preventing this is the stack canary, and
> I'm wondering how much value there is in keeping it, given the
> disadvantages of having this divergence between 32 and 64 bit.

I think most of the PDA could be gotten rid of. The problems are

1. The stack canary

2. The PDA is used to store per cpu data before the per cpu areas
   are setup.

The i386 way of referring to per cpu data is not optimal because it is 
always offset by __per_cpu_start. per cpu data offsets need to be relative 
to the beginning of the per cpu area. per cpu data is less than 64k so 2 
byte offsets would be enough.

That way the __per_cpu_offset array and the registers that are used on 
various platforms are pointing to the actual data and can be loaded
directly into a register and then a load with a small offset to that 
register can be performed. On x86_64 this is gs, on i386 fs, on sparc g5, 
on ia64 a fixed address stands in for the register. In loops over all per 
cpu variables this will also simplify the code.

And ultimately we can get rid of the ugly RELOC_HIDE macro. It simply 
becomes the adding of the base address in a register to a per cpu offset.






