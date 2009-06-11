Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbZFKGFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbZFKGFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZFKGFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:05:25 -0400
Received: from mga05.intel.com ([192.55.52.89]:28961 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751628AbZFKGFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:05:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,200,1243839600"; 
   d="scan'208";a="698387178"
Subject: Re: Bug: fio traps into kernel without exiting because futex has a
	deadloop
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4A309D16.4040505@us.ibm.com>
References: <1244689688.2560.268.camel@ymzhang>
	 <4A309D16.4040505@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 11 Jun 2009 14:05:31 +0800
Message-Id: <1244700331.2560.271.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-10 at 22:58 -0700, Darren Hart wrote:
> Zhang, Yanmin wrote:
> 
> Hi Zhang,
> 
> > I investigate a fio hang issue. When I run fio multi-process
> > testing on many disks, fio traps into kernel and doesn't exit
> > (mostly hit once after runing sub test cases for ﻿hundreds of times).
> > 
> > Oprofile data shows kernel consumes time with some futex functions.
> > Command kill couldn't kill the process and machine reboot also hangs.
> > 
> > Eventually, I locate the root cause as a bug of futex. Kernel enters
> > a deadloop between 'retry' and 'goto retry' in function futex_wake_op.
> > By unknown reason (might be an issue of fio or glibc), parameter uaddr2
> > points to an area which is READONLY. So futex_atomic_op_inuser returns
> > -EFAULT when trying to changing the data at uaddr2, but later get_user
> > still succeeds becasue the area is READONLY. Then go back to retry.
> > 
> > I create a simple test case to trigger it, which just shmat an READONLY
> > area for address uaddr2.
> > 
> > It could be used as a DOS attack.
> 
> Nice work on the diagnosis.  I recall discussing something like this a 
> couple weeks back.  I thought this was fixed with a patch to ensure the 
> pages were writable.  Cc'ing Thomas G. to confirm.  

> I didn't see a 
> kernel version in your report, what are you running?
2.6.30-rc1~rc8.


