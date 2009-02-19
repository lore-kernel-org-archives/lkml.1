Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbZBSUd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbZBSUd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZBSUdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:33:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43357 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbZBSUdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:33:16 -0500
Message-ID: <499DC13C.2000401@zytor.com>
Date: Thu, 19 Feb 2009 12:29:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Petr Tesarik <ptesarik@suse.cz>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove unneeded endless loop in BUG()
References: <1235068713.15053.99.camel@nathan.suse.cz> <20090219185935.GA21820@elte.hu>
In-Reply-To: <20090219185935.GA21820@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> the problem is that the DO_BUG() will generate the u2d 
> instruction into a random place where GCC puts it. It certainly 
> wont be in the place where the __bug_table logic above expects 
> it.
> 
> The result will be cryptic crashes instead of a clean BUG 
> message assert.
> 

I went and talked to H.J. Lu about this.

He said __builtin_trap(); is functionally treated as an asm volatile, 
and that it is most likely impossible that gcc could do anything wrong 
here (he did specifically state that nothing can move across the asm 
volatile, and there are no data dependencies between the asm volatile 
and the __builtin_trap).

He also agreed that the right way to do this is __builtin_not_reached(), 
and I promised to submit a feature request for this for a future version 
of gcc.

Given that, I would suggest we back out the patch, and that when 
__builtin_not_reached(); is supported, we can simply do:

#if __GNUC__ is recent enough
# define not_reached() __builtin_not_reached()
#else
# define not_reached() for(;;)
#endif

OK?

	-hpa

