Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYGIUnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYGIUnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbYGIUnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:43:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38348 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbYGIUnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:43:13 -0400
Message-ID: <48752121.3050208@zytor.com>
Date: Wed, 09 Jul 2008 16:35:45 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu> <48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>
In-Reply-To: <48751CF9.4020901@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> 
> Another reason to use a zero based per cpu area is to limit the offset range. Limiting the offset range allows in turn to limit the size of the generated instructions because it is part of the instruction. It also is easier to handle since __per_cpu_start does not figure
> in the calculation of the offsets.
> 

No, that makes no difference.  There is no short-offset form that 
doesn't involve a register (ignoring the 16-bit 67h form on 32 bits.)

For 64 bits, you want to keep the offsets within %rip±2 GB, or you will 
have relocation overflows for %rip-based forms; for absolute forms you 
have to be in the range 0-4 GB.  The %rip-based forms are shorter, and 
I'm pretty sure they're the ones we currently generate.  Since we base 
the kernel at 0xffffffff80000000 (-2 GB) this means a zero-based offset 
is actively wrong, and only work by accident (since the first 
CONFIG_PHYSICAL_START of that space is unused.)

	-hpa
