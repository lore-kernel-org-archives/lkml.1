Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbZATTFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbZATTFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 14:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZATTFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 14:05:04 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:46946 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753149AbZATTFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 14:05:02 -0500
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
From: Zachary Amsden <zach@vmware.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "jeremy@xensource.com" <jeremy@xensource.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
In-Reply-To: <20090120112634.GA20858@elte.hu>
References: <20090120110542.GE19505@wotan.suse.de>
	 <20090120112634.GA20858@elte.hu>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 11:05:18 -0800
Message-Id: <1232478318.16317.160.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 03:26 -0800, Ingo Molnar wrote:

> Jeremy, any ideas where this slowdown comes from and how it could be 
> fixed?

Well I'm early responding to this thread before reading on, but I looked
at the generated assembly for some common mm paths and it looked awful.
The biggest loser was probably having functions to convert pte_t back
and forth to pteval_t, which makes most potential mask / shift
optimizations impossible - indeed, because the compiler doesn't even
understand pte_val(X) = Y is static over the lifetime of the function,
it often calls these same conversions back and forth several times, and
because this is often done inside hidden macros, it's not even possible
to save a cached value in most places.

The bulk of state required to keep this extra conversion around ties up
a lot of registers and as a result heavily limits potential further
optimizations.

The code did not look more branchy to me, however, and gcc seemed to do
a good job with lining up a nice branch structure in the few paths I
looked at.

Zach

