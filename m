Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbZHFRWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbZHFRWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZHFRWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:22:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57656 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZHFRWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:22:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: Re: [PATCH] Address Sparse Static Warning inside kernel/fork.c
Date: Thu, 6 Aug 2009 19:22:34 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20090806170600.32631.77680.sendpatchset@subratamodak.linux.ibm.com>
In-Reply-To: <20090806170600.32631.77680.sendpatchset@subratamodak.linux.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908061922.34515.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/n9uClOBML9aHZHMBdLUqgSkLcTKaEFMv+h+/
 6Z5XmB3aOnuGyNmvUjzjVlaIVnZW2WKgpvX5VsA7kjU1EwG+Ri
 3KdnKjje7iWGX6ofJiMEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009, Subrata Modak wrote:
> --- a/kernel/fork.c	2009-08-05 12:00:51.000000000 +0530
> +++ b/kernel/fork.c	2009-08-06 22:26:30.000000000 +0530
> @@ -78,7 +78,7 @@
>  unsigned long total_forks;	/* Handle normal Linux uptimes. */
>  int nr_threads; 		/* The idle threads do not count.. */
>  
> -int max_threads;		/* tunable limit on nr_threads */
> +static int max_threads;		/* tunable limit on nr_threads */
>  
>  DEFINE_PER_CPU(unsigned long, process_counts) = 0;
>  
> @@ -168,7 +168,7 @@ void __put_task_struct(struct task_struc
>  #define arch_task_cache_init()
>  #endif
>  
> -void __init fork_init(unsigned long mempages)
> +static void __init fork_init(unsigned long mempages)
>  {
>  #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
>  #ifndef ARCH_MIN_TASKALIGN

These are both wrong (you didn't try compiling the kernel with
that patch, did you?):
fork_init() is called from init/main.c, max_threads is accessed
in kernel/sysctl.c.

If you had tried building this, you would have seen a warning about
unused symbols in the compile stage, followed by a linker error.

I would still be good to address these two though. Please do a
patch that moves the extern declarations for these two symbols
to an appropriate header file that is included in fork.c.

	Arnd <><
