Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbXK1XgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbXK1XgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbXK1XgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:36:11 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48722 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755692AbXK1XgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:36:08 -0500
Date: Wed, 28 Nov 2007 15:36:06 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
In-Reply-To: <200711291017.52727.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0711281528130.17481@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com>
 <200711291017.52727.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Rusty Russell wrote:

> But the PDA itself is silly (Jeremy ported it to i386 and I balked).  We have 
> a generic one: it's called the per-cpu data.  Having a completely separate 
> per-cpu structure for x86-64 is a mistake.

Yes ultimately the pda can be dissolved. However, the stack canary 
probably has to be kept for backward compatibility.
 
> Setting up gs as the per-cpu offset has lovely properties and avoids YA 
> arch-specific concept; see the i386 code.  Introducing a generic 
> read_percpu()/write_percpu() would even make it optimal.

The code becomes much simpler if gs would point to the beginning of the 
per cpu area and if the __per_cpu_offset[i] would do the same. No weird 
__per_cpu_start offsetting anymore.

The offsets are smaller if they are relative to the per cpu areas which 
will make more compact instructions possible.

The generic write/readpercpu functionality introduced by the cpu_alloc 
patchset works best with offsets relative to an arch dependent 
register. All per cpu data (pda, percpu and allocpercpu) is handles as an 
offset relative to the start of the per cpu data.

If the current offset by __per_cpu_start is kept then a per cpu allocator 
may have to dish out addresses that go beyond __per_cpu_end.

I think dealing with a per cpu variable as if it would be an offset 
relative to a base is natural for the typical addressing of cpus based on 
an offset relative to some register.

