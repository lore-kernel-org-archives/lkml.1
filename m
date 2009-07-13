Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZGMOZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZGMOZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 10:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbZGMOZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 10:25:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57768 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbZGMOZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 10:25:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH V2] score: add regset support
Date: Mon, 13 Jul 2009 16:24:28 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.96; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, linux-arch@vger.kernel.org,
       linux-arch-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <OF43365008.5559F266-ON482575F2.001F17EE-482575F2.00212259@sunplusct.com>
In-Reply-To: <OF43365008.5559F266-ON482575F2.001F17EE-482575F2.00212259@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?gb2312?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2E?=
 =?gb2312?q?a=5E3zb?=)
 =?gb2312?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?gb2312?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <200907131624.28286.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+STbBD8IzRaH3qS458loGcvKS6eLkzg5zT+bI
 WCJqQ80Wq1YvFVhpdbMMD0237iTgfjXPK01uJ8Unq0Lgy5Jbpt
 rlCt2ZUCOBbv4tLjIhQYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 July 2009, liqin.chen@sunplusct.com wrote:
> 
> unsigned long pad0[6];
> 
> was place at the start of pt_regs use 
> to hold the arguments from userland.
> caller(exception handler) not need to
> change stack pointer.
>
> unsigned long orig_r4;
> unsigned long orig_r7;
> move to end of the pt_regs haven't 
> problem.

Ok, I see.

Maybe to get a nicer layout, you can define separate
structures then:

struct user_regs_struct {
        unsigned long regs[32];

        unsigned long cel;
        unsigned long ceh;
 
        unsigned long sr0;      /* cnt */
        unsigned long sr1;      /* lcr */
        unsigned long sr2;      /* scr */
 
        unsigned long cp0_epc;
        unsigned long cp0_ema;
        unsigned long cp0_psr;
        unsigned long cp0_ecr;
        unsigned long cp0_condition;

	unsigned long reserved[6]; /* future extensions */
};

#ifdef __KERNEL__
struct pt_regs {
	/* stack arguments */
        unsigned long pad0[6];

	/* internal use */
        unsigned long orig_r4;
        unsigned long orig_r7;
        long is_syscall;

	/* saved registers */
	struct user_regs_struct uregs;
};
#endif

That would keep the user struct relatively clean.

	Arnd <><
