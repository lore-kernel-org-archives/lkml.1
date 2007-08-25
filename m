Return-Path: <linux-kernel-owner+w=401wt.eu-S934080AbXHYKPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080AbXHYKPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 06:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760124AbXHYKPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 06:15:36 -0400
Received: from aun.it.uu.se ([130.238.12.36]:41905 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbXHYKPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 06:15:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18128.322.59087.367556@alkaid.it.uu.se>
Date: Sat, 25 Aug 2007 12:15:30 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Clark Cooper" <clark.cooper@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Caught SIGFPE exceptions aren't reset
In-Reply-To: <e21d91280708242140i2e6223a4v51ba016837b74be8@mail.gmail.com>
References: <e21d91280708242140i2e6223a4v51ba016837b74be8@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clark Cooper writes:
 > [1] Caught SIGFPE exceptions aren't reset
 > 
 > [2]
 >     On an i386, you can set a handler for a SIGFPE signal, and after enabling FP
 >     exceptions with feenableexceptions(), an FP exception will cause
 > your handler
 >     to be called.  However after the handler returns, it is called
 > again with the
 >     same FP error.  Control never returns to the point after the
 > instruction that
 >     caused the exception.

User error.

You cannot write working SIGFPE handlers without understanding the
underlying FP instruction set and its exception model, and being
prepared to write CPU- and OS-specific code.

In particular, on modern x86, an SSE2 FP instruction that raises
an exception will be set to restart in the resumption state.
It's up to your handler to either bypass the restart (longjmp),
or to update the resumption state so that it can be resumed without
triggering an infinite loop. Your handler can do this by masking
exceptions, changing the operands of the failed FP instruction,
or by changing the PC so that the failed instruction is skipped
(your handler may want to emulate the instruction in this case).

This is not a kernel problem.

/Mikael
