Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0BRByk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:54:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753797Ab0BRByi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:54:38 -0500
Date: Wed, 17 Feb 2010 17:53:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Zachary Amsden <zamsden@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 rwsem optimization extreme
In-Reply-To: <4B7C7BE4.9050908@zytor.com>
Message-ID: <alpine.LFD.2.00.1002171743200.4141@localhost.localdomain>
References: <1266443901-3646-1-git-send-email-zamsden@redhat.com> <alpine.LFD.2.00.1002171403160.4141@localhost.localdomain> <4B7C7BE4.9050908@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Feb 2010, H. Peter Anvin wrote:
> 
> FWIW, I don't know of any microarchitecture where adc is slower than
> add, *as long as* the setup time for the CF flag is already used up.

Oh, I think there are lots.

Look at just about any x86 latency/throughput table, and you'll see:

 - adc latencies are typically much higher than a single cycle

   But you are right that this is likel not an issue on any out-of-order 
   chip, since the 'stc' will schedule perfectly.

 - but adc _throughput_ is also typically much higher, which indicates 
   that even if you do flag renaming, the 'adc' quite likely only 
   schedules in a single ALU unit.

For example, on a Pentium, adc/sbb can only go in the U pipe, and I think 
the same is true of 'stc'. Now, nobody likely cares about Pentiums any 
more, but the point is, 'adc' does often have constraints that a regular 
'add' does not, and there's an example of a 'stc+adc' pair would at the 
very least have to be scheduled with an instruction in between.

		Linus
