Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZFCLq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZFCLq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZFCLqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:46:21 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:34664 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbZFCLqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:46:20 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: LOCK prefix on uni processor has its use
Date: Wed, 3 Jun 2009 06:46:17 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <200906020826.09355.lkml@morethan.org> <20090602134225.GN1065@one.firstfloor.org>
In-Reply-To: <20090602134225.GN1065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906030646.19493.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue June 2 2009, Andi Kleen wrote:
> > After another week of chasing this - -
> 
> Did you use the "compile part of the kernel with LOCK and others without"
> technique I described earlier?
> 

That would only help if it where a single point failure.

Although there are some assembly language things that can
be done to help in finding what to examine, like:

#define LOCK_PREFIX     "\n### Lock pre-fix removed:\n\t"

Or whatever might help your favorite text search program.

Which yields asm expansion in your *.s file (gcc -S) as:

#APP
# 33 "test_bytelock.c" 1

1:      xchgb %ah, %al
        test %al,%al
        jz 3f

### Lock pre-fix removed:
        incb splock+1
2:      xchgw %ax, %ax
        cmpb $1, splock
        je 2b

### Lock pre-fix removed:
        decb splock+1
        jmp 1b
3:
# 0 "" 2
#NO_APP

Note: For the readers not familar with (g)as;
#APP -> Assembler Pre-Process (gcc generated)
<ragged whitespace and comments allowed>
#NO_APP -> No Assembler Pre-Process (gcc generated)

If ambitious, you can add a comment to each asm-macro
to note the line and source filename of where it is
defined. (the line number and name gcc put there is
where it was expanded, not where it was defined).

Not really too ambitious - there are only 140 files
of interest (with asm-macros) in a x86, uni-processor build.

Mike

> -Andi


