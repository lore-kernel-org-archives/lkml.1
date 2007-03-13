Return-Path: <linux-kernel-owner+w=401wt.eu-S965524AbXCMJEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524AbXCMJEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965560AbXCMJEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:04:54 -0400
Received: from ozlabs.org ([203.10.76.45]:37002 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965524AbXCMJEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:04:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17910.26926.138067.731855@cargo.ozlabs.ibm.com>
Date: Tue, 13 Mar 2007 20:04:46 +1100
From: Paul Mackerras <paulus@samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: _proxy_pda still makes linking modules fail
In-Reply-To: <1173767032.10618.43.camel@localhost.localdomain>
References: <1173315479.12472.9.camel@qrnik>
	<p73lki39s3a.fsf@bingen.suse.de>
	<45F49E0A.3090607@goop.org>
	<20070312094805.GA11644@one.firstfloor.org>
	<1173736726.10618.1.camel@localhost.localdomain>
	<1173767032.10618.43.camel@localhost.localdomain>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell writes:

> The ideal solution has always been to use __thread, but no architecture
> has yet managed it (I tried for i386, and it quickly caused unbearable
> pain).  On x86-64 that uses "%fs" on x86-64, not "%gs" as the kernel
> does, but I might try that if I feel particularly masochistic soon...

There is a fundamental problem with using __thread, which is that gcc
assumes that the addresses of __thread variables are constant within
one thread, and that therefore it can cache the result of address
calculations.  However, with preempt, threads in the kernel can't rely
on staying on one cpu, and therefore the addresses of per-cpu
variables can change.  There appears to be no way to tell gcc to drop
all cached __thread variable address calculations at a given point
(e.g. when enabling or disabling preemption).  That is basically why I
gave up on using __thread for per-cpu variables on powerpc.

We could use __thread for per-task variables quite naturally.  There
doesn't seem to be much point, though, since we already have a way to
do per-task variables - it's called struct task_struct. :-/

Paul.
