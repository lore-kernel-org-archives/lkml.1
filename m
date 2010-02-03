Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0BCSOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:14:18 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42072 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab0BCSOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:14:16 -0500
Date: Wed, 3 Feb 2010 19:14:25 +0100
From: Borislav Petkov <bp@amd64.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100203181425.GB1367@aftab>
References: <20100130094515.475881280@intel.com>
 <20100130094957.692671259@intel.com>
 <20100201124825.cc024f2a.akpm@linux-foundation.org>
 <20100203133951.GA24357@localhost>
 <20100203070825.e36b3932.akpm@linux-foundation.org>
 <1265210157.24455.646.camel@laptop>
 <20100203074251.e2caa3f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203074251.e2caa3f3.akpm@linux-foundation.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 07:42:51AM -0800, Andrew Morton wrote:
> We didn't deal with it on every architecture, which is something which
> the compiler extension takes care of.
> 
> In fact I can't find anywhere where we dealt with it on x86.

Yeah, we talked briefly about using hardware popcnt, see thread
beginning at

http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-06/msg00245.html

for example. I did an ftrace of the cpumask_weight() calls in sched.c to
see whether there would be a measurable performance gain but it didn't
seem so at the time. My numbers said something like ca. 170 hweight
calls per second and since the <lib/hweight.c> implementations roughly
translate to something like ~20 isns (hweight64 to about ~30), the whole
thing wasn't worth the trouble considering checking binutils versions
and slapping opcodes or using gcc intrinsics which involves gcc version
checking.

An alternatives solution which is based on CPUID flag could add the
popcnt opcode without checking any toolchain versions but how is the
replaced instruction going to look like? Something like

alternative("call hweightXX", "popcnt", X86_FEATURE_POPCNT)

by making sure the arg is in some register first?

Hmm..

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
