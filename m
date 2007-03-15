Return-Path: <linux-kernel-owner+w=401wt.eu-S1422758AbXCOADO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422758AbXCOADO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 20:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422760AbXCOADN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 20:03:13 -0400
Received: from science.horizon.com ([192.35.100.1]:19296 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422758AbXCOADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 20:03:12 -0400
Date: 14 Mar 2007 20:03:10 -0400
Message-ID: <20070315000310.15266.qmail@science.horizon.com>
From: linux@horizon.com
To: linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [patch] change futex_wait() to hrtimers
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW. my futex man page says timeout's contents "describe the maximum duration
> of the wait". Surely that should be *minimum*? Michael cc'ed.

Er, the intent of the wording is to say "futex will wait until uaddr
no longer contains val, or the timeout expires, whichever happens first".


One option for selecting different clock resolutions is to use the
clockid_t from the POSIX clock_gettime() family.  That is, specify the
clock that a wait uses, and then have a separate mechanism for turning
a resolution requirement into a clockid_t.

(And there can be default clocks for interfaces that don't specify one
explicitly.)

Although clockid_t is pretty generic, it's biased toward an enumerated
list of clocks rather than a continuous resolution.  Fortunately,
that seems to match the implementation ideas.  The question is how
much the timeout gets rounded, and the choices are currently jiffies
or microseconds.

A related option may be whether rounding down is acceptable.  For some
applications (periodic polling for events), it's fine.  For others,
it's not.  Thus, while it's okay to specify such clocks explicitly,
it'd probably be a good idea to forbid selecting them as the default
for interfaces that don't specify a clock explicitly.

I had some code that suffered 1 ms buzz-loops on Solaris because poll(2)
would round the timeout interval down, but the loop calling it would
explicitly check whether the timeout had expired using gettimeofday()
and would keep re-invoking poll(pollfds, npollfds, 1) until the timeout
really did expire.
