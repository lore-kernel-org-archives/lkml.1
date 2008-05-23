Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYEWItv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYEWItv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 04:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYEWIto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 04:49:44 -0400
Received: from vigor.karmaclothing.net ([217.169.26.28]:57073 "EHLO
	vigor.karmaclothing.net." rhost-flags-OK-OK-FAIL-FAIL)
	by vger.kernel.org with ESMTP id S1752189AbYEWItn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 04:49:43 -0400
Date: Fri, 23 May 2008 09:45:07 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: [PATCH 5/7] gcov: add gcov profiling infrastructure
Message-ID: <20080523084506.GB719@linux-mips.org>
References: <48313DE6.30802@de.ibm.com> <20080523001136.59ec8b34.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523001136.59ec8b34.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 12:11:36AM -0700, Andrew Morton wrote:

> On Mon, 19 May 2008 10:44:22 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> 
> > +	Note that a kernel compiled with profiling flags will be significantly
> > +        larger and run slower. Also be sure to exclude files from profiling
> > +        which are not linked to the kernel image to prevent linker errors.
> 
> heh, it was all too much for mips.
> 
> {standard input}: Assembler messages:
> {standard input}:2716: Error: Branch out of range
> {standard input}:2819: Error: Branch out of range
> {standard input}:2884: Error: Branch out of range
> {standard input}:3032: Error: Branch out of range
> {standard input}:3097: Error: Branch out of range
> {standard input}:3151: Error: Branch out of range
> {standard input}:3216: Error: Branch out of range
> make[1]: *** [drivers/telephony/ixj.o] Error 1
> make: *** [drivers/telephony/ixj.o] Error 2

A known problem which I had decieded to ignore until it begins to actually
bite.  It's triggered by something like this

                __asm__ __volatile__(
                "       .set    mips3                                   \n"
                "1:     ll      %0, %1          # atomic_add            \n"
                "       addu    %0, %2                                  \n"
                "       sc      %0, %1                                  \n"
                "       beqz    %0, 2f                                  \n"
                "       .subsection 2                                   \n"
                "2:     b       1b                                      \n"
                "       .previous                                       \n"
                "       .set    mips0                                   \n"
                : "=&r" (temp), "=m" (v->counter)
                : "Ir" (i), "m" (v->counter));

when compiled into a large compilation unit.

  Ralf
