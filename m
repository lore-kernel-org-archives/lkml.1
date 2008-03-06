Return-Path: <linux-kernel-owner+w=401wt.eu-S1763250AbYCFUQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763250AbYCFUQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYCFUQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:16:34 -0500
Received: from lain.randombit.net ([66.179.181.40]:43419 "EHLO
	mail.randombit.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYCFUQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:16:33 -0500
Date: Thu, 6 Mar 2008 15:16:33 -0500
From: Jack Lloyd <lloyd@randombit.net>
To: gcc@gcc.gnu.org, linux-kernel@vger.kernel.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction     flag
Message-ID: <20080306201633.GM27983@randombit.net>
Mail-Followup-To: gcc@gcc.gnu.org, linux-kernel@vger.kernel.org
References: <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org> <47CFF9A3.30309@gnu.org> <20080306141221.GC5236@dspnet.fr.eu.org> <20080306175841.GI17267@synopsys.com> <20080306181029.GA42904@dspnet.fr.eu.org> <47D03440.6090503@gnu.org> <20080306183146.GL27983@randombit.net> <47D0495F.2090109@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D0495F.2090109@gnu.org>
X-PGP-Fingerprint: 3F69 2E64 6D92 3BBE E7AE 9258 5C0F 96E8 4EC1 6D6B
X-PGP-Key: http://www.randombit.net/pgpkey.html
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 08:43:27PM +0100, Paolo Bonzini wrote:
> Jack Lloyd wrote:
> >On Thu, Mar 06, 2008 at 07:13:20PM +0100, Paolo Bonzini wrote:
> >>A process can send a signal via kill.  IOW, a malicious process can 
> >>*control when the process would be interrupted* in order to get it into 
> >>the signal handler with DF=1.
> >
> >If the malicious process can send a signal to another process, it
> >could also ptrace() it. Which is more useful, if you wanted to be
> >malicious?
> 
> 1) capabilities(7)

Ah you are right, I misinterpreted something from the man page
("non-root processes cannot trace processes that they cannot send
signals to") to mean something it did not (basically, that CAP_KILL
implied CAP_SYS_PTRACE, which from reading the kernel source is
clearly not the case...)

But still: so the threat here is of a malicious process with the
ability to send arbitrary signals to any process using CAP_KILL (since
in any other case when a process can send a signal, it can do much
more damage in other ways), which could leverage that into
(potentially) uid==0 using misexecuted code in a signal handler.

As a correctness issue, obviously this should be fixed/patched around,
if feasible. But as a security flaw? I'm not seeing much that is
compelling.

> 2) sometimes setuid programs send signals (e.g. SIGHUP or SIGUSR1)

I don't understand how this is a problem - unless these setuid
programs, while not malicious, can be tricked into signalling a
process they did not intend to. (In which case they already have a
major bug, df bit being cleared or not).

-Jack
