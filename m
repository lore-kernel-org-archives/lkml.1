Return-Path: <linux-kernel-owner+w=401wt.eu-S1762282AbXKTVGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762282AbXKTVGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbXKTVGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:06:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbXKTVGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:06:31 -0500
Message-ID: <47434C46.5080301@zytor.com>
Date: Tue, 20 Nov 2007 13:06:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
References: <20071120011132.143632442@sgi.com> <200711201301.25373.ak@suse.de> <474346DE.5050305@zytor.com> <200711202151.58310.ak@suse.de> <Pine.LNX.4.64.0711201257580.27235@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711201257580.27235@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 20 Nov 2007, Andi Kleen wrote:
> 
>>> This limitation shouldn't apply to the percpu area, since gs_base can be 
>>> pointed anywhere in the address space -- in effect we're always indirect.
>> The initial reference copy of the percpu area has to be addressed by
>> the linker.
> 
> Right that is important for the percpu references that can be folded by 
> the linker in order to avoid address calculations.
> 
>> Hmm, in theory since it is not actually used by itself I suppose you could 
>> move it into positive space.
> 
> But the positive space is reserved for a processes memory.
> 

But you wouldn't actually *use* this address space.  It's just for the 
linker to know what address to tag the references with; it gets 
relocated by gs_base down into proper kernel space.  The linker can 
stash the initialized reference copy at any address (LMA) which can be 
different from what it will be used at (VMA); that is not an issue.

To use %rip references, though, which are more efficient, you probably 
want to use offsets that are just below .text (at -2 GB); presumably
-2 GB-[max size of percpu section].  Again, however, no CPU actually 
needs to have its data stashed in that particular location; it's just an 
offset.

	-hpa
