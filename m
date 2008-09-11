Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYIKMx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYIKMx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 08:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYIKMxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 08:53:48 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:46181 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYIKMxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 08:53:48 -0400
Message-ID: <48C914D8.6080806@skyrush.com>
Date: Thu, 11 Sep 2008 06:53:44 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Fix loss of echoed characters (2nd follow-on PATCH
 attached)
References: <200807252257.m6PMvieO003213@imap1.linux-foundation.org>	<48AC3A16.4080209@skyrush.com>	<48B3F9F7.2050503@skyrush.com>	<48C54EC2.4060901@skyrush.com>	<20080908173250.2452c5b8.akpm@linux-foundation.org>	<20080909115536.1664d57a@lxorguk.ukuu.org.uk>	<20080909104325.4653190b.akpm@linux-foundation.org>	<48C6DFA4.5040406@skyrush.com> <20080910163902.2b7ac22b.akpm@linux-foundation.org>
In-Reply-To: <20080910163902.2b7ac22b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 09 Sep 2008 14:42:12 -0600
> Joe Peterson <joe@skyrush.com> wrote:
> 
>> 1) Fix tab erasure handling
>> 2) Improve locking when working with the echo buffer
>> 3) Remove the big kernel lock (BKL) from n_tty
>>
>> Tab erasure handling is now more robust and able to handle non-zero
>> canon column cases more correctly.  This is done by making correct use
>> of what is known in the eraser function (read buffer contents) and what
>> is known at the time of processing the tab erasure (column state).
>>
>> Also, better locking of the echo buffer will now prevent any attempts to
>> process partial multi-byte echo operations.  And since the echo buffer
>> code now isolates the tty column state code to the process_out* and
>> process_echoes functions, we can remove the big kernel lock (BKL)
>> and replace it with more modern mutex locks.
> 
> Boy.  Has this been carefully tested with lockdep enabled?

Yes, I have the following in my kernel config:

CONFIG_KALLSYMS_ALL=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y

I have run the various tests that I used to find/investigate the echo
loss problem to begin with (i.e. that make output compete with echo).
Also some manual tests that fill the echo buffer during a stopped tty,
test the eraser interaction, etc.  Things look fine so far.

						-Joe
