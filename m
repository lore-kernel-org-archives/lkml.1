Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYIPRsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYIPRsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbYIPRs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:48:29 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:16933 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYIPRs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:48:28 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Don't use NOPL on 32-bit cpu's because not all systems support it.
Date: Tue, 16 Sep 2008 13:48:23 -0400
User-Agent: KMail/1.9.5
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200809161159.15870.linux@sandersweb.net> <48CFDF82.3000704@zytor.com>
In-Reply-To: <48CFDF82.3000704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809161348.24130.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 September 2008 12:32, H. Peter Anvin wrote:
> Oh good grief.
>
> VPC is apparently so broken that these instructions work *some* of the
> time, which may include the first time, but not later.  That is an
> impressive level of cockup.
>
> Given that, we should either just rip this code out, or detect VPC
> (how?).  The latter option can be done post-.27, of course; if so, we
> should just force the bit off for now rather than doing it in the
> alternatives code.  The only reason for doing the latter at all would be
> to mitigate the overhead of paravirt_ops and other dynamic patch sites.
>
> It would also be the least impact for .27, I believe.

I think you still want the nopl enabled for 64-bits.

This is how I detect virtual pc.  I based it on a google search.  Microsoft 
itself provides no info:

#include <stdio.h>
#include <signal.h>
#include <stdlib.h>

void except(int e)
{
	printf("Not in Virtual PC\n");
	exit(1);
}

int main()
{
	signal(SIGILL, except);
	asm("\n"
		"mov $0x01, %eax\n" /* function number */
		".byte 0x0f, 0x3f, 0x07, 0x0b\n" /* call VPC */
	   );
	printf("Inside Virtual PC\n");
	return 0;
}


