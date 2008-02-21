Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbYBUOge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbYBUOge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 09:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYBUOgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 09:36:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:58223 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbYBUOgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 09:36:24 -0500
Message-ID: <47BD8C58.305@windriver.com>
Date: Thu, 21 Feb 2008 08:36:08 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] kgdb: fixes and ARCH=arm support
References: <1203536020-20102-1-git-send-email-jason.wessel@windriver.com> <20080221062215.GA10172@elte.hu>
In-Reply-To: <20080221062215.GA10172@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Feb 2008 14:36:07.0693 (UTC) FILETIME=[185163D0:01C87497]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> I think we should also try to do some self-tests, so that when one boots 
> a bzImage with the self-tests activated it can be said that all the 
> basic functionality works. Simulated via some loopback method, from 
> within the kernel - not via a real serial line - but it should have the 
> capability to do real single-stepping and inject real hw breakpoints and 
> test that they work. What do you think?
> 
> 	Ingo


I am in agreement that the kgdb core and arch level support can be
unit tested via a kgdb I/O module designed specifically for exercising
kgdb as if it were the debugger talking to the kernel.  It is more a
matter of taking the time to write the test cases as well as some code
to simulate the debugger.  All the API pieces needed to create a 
testing kgdb I/O module are already in the kgdb core.

There are several classes of tests that could be run with the possibility
to construct a kgdb test I/O module that performs them all:
- Early init tests
   * Pass in a kernel start argument to invoke the test
   * test kgdbwait
   * test SW/HW breakpoints
   * test single step
   * test several known bad memory read locations
   * test SMP concurrency

- Late init test
   * Same as the first test, but done at the late init point
     with a different kernel start argument
   * test NMI watch dog + recover

- Run time dynamic configuration
   * Connect the I/O module at run time by using an echo > /sys/...
   * Test the same pieces as the late init test

- Perhaps even allow the kgdb I/O test module to be built as 
  a kernel module. The only problem with this is that there will be some
  more exports required. It is marginally more challenging in that
  you have to look up the symbol address info dynamically as well vs
  allowing the linker to resolve the references when it is built as a
  built-in.  Also as a built-in you can call all the kgdb en-code
  de-code gdb serial packet logic directly with no exports.
  

Of course it is always best to start small and not all of the tests
are needed in a 1st pass.  It is something that is already on the KGDB
todo list, and if there is someone out there that would like to start
writing this code right now, please contact me.  Or, eventually the
this task will bubble to the top of the stack. :-)

Ultimately this type of I/O testing module will be important for
helping to validate future archs that have kgdb support added, as well
as a place to add other edge test cases if there are future defects
fixed in kgdb for which you can create a test case.

Jason.
