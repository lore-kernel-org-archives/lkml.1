Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbXCMPbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbXCMPbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXCMPbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:31:55 -0400
Received: from gw.goop.org ([64.81.55.164]:56094 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbXCMPby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:31:54 -0400
Message-ID: <45F6C3E9.5020207@goop.org>
Date: Tue, 13 Mar 2007 08:31:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: _proxy_pda still makes linking modules fail
References: <1173315479.12472.9.camel@qrnik>	<p73lki39s3a.fsf@bingen.suse.de>	<45F49E0A.3090607@goop.org>	<20070312094805.GA11644@one.firstfloor.org>	<1173736726.10618.1.camel@localhost.localdomain>	<1173767032.10618.43.camel@localhost.localdomain> <17910.26926.138067.731855@cargo.ozlabs.ibm.com>
In-Reply-To: <17910.26926.138067.731855@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> There is a fundamental problem with using __thread, which is that gcc
> assumes that the addresses of __thread variables are constant within
> one thread, and that therefore it can cache the result of address
> calculations.  However, with preempt, threads in the kernel can't rely
> on staying on one cpu, and therefore the addresses of per-cpu
> variables can change.  There appears to be no way to tell gcc to drop
> all cached __thread variable address calculations at a given point
> (e.g. when enabling or disabling preemption).  That is basically why I
> gave up on using __thread for per-cpu variables on powerpc.
>   

Doesn't that fall under the general class of "you have to be pinned to a
particular cpu in order to meaningfully use per-cpu variables"?

Or do you mean that if you have:

	preempt_disable();
	use_my_percpu++;
	preempt_enable();
	// switch cpus
	preempt_disable();
	use_my_percpu++;
	preempt_enable();

then it will still use the old pointer to use_my_percpu?

In principle gcc could CSE the value of smp_processor_id() across a cpu
change in the same way.

    J
