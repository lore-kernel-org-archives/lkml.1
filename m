Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab0BDFBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 00:01:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:45100 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab0BDFBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 00:01:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,402,1262592000"; 
   d="scan'208";a="769989958"
From: "Lu, Hongjiu" <hongjiu.lu@intel.com>
To: Roland McGrath <roland@redhat.com>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lachner, Peter" <peter.lachner@intel.com>
Date: Wed, 3 Feb 2010 21:01:32 -0800
Subject: RE: [patch] x86: ptrace and core-dump extensions for xstate
Thread-Topic: [patch] x86: ptrace and core-dump extensions for xstate
Thread-Index: AcqlVj/SSUJ+dhgmQMG8JO5H2heSeQAABWvw
Message-ID: <8EA2C2C4116BF44AB370468FBF85A7770123AAB3A1@orsmsx504.amr.corp.intel.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	<20100203230817.E6529AA@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB0AE@orsmsx504.amr.corp.intel.com>
	<20100204020224.45379725@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB2E8@orsmsx504.amr.corp.intel.com>
	<20100204021659.AB348C880@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB303@orsmsx504.amr.corp.intel.com>
 <20100204045458.5AA2F7290@magilla.sf.frob.com>
In-Reply-To: <20100204045458.5AA2F7290@magilla.sf.frob.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > To support XSAVE, gdb needs to know XCR0 as well as XSTATE size.
> > We can get those info from kernel via system call or cpuid. I
> > prefer cpuid over system call.
> 
> Suresh's patch puts this value in the xsave block, in what Suresh calls
> "sw_usable_bytes".  See the asm/ptrace-abi.h comment in the patch you
> signed off on.
>
> How is that not sufficient?  If it is indeed not sufficient to usefully
> interpret the xsave block, then how could an xsave block in a core dump
> file ever possibly be examined if it might not have been generated on the
> same system and kernel where the debugger is doing the examination?  If
> the NT_X86_XSTATE note as implemented in Suresh's patch is indeed not
> entirely self-contained in this way, then NAK on that new note format.
> 

I use it when reading core dump, which doesn't involve a system call.
I can analyze it on a totally different machine.

FWIW, there is the header file I have in gdb

---
/* XSAVE extended state information.  */

/* The extended state status.  */
enum xstate_status
{
  XSTATE_UNKNOWN = 0,
  XSTATE_UNSUPPORTED,
  XSTATE_INITIALIZED
};

/* The extended state feature bits.  */
#define bit_XSTATE_X87          (1ULL << 0)
#define bit_XSTATE_SSE          (1ULL << 1)
#define bit_XSTATE_AVX          (1ULL << 2)

/* Supported mask and size of the extended state.  Used for qSupport.  */
#define XSTATE_SSE_MASK         0x3
#define XSTATE_AVX_MASK         0x7
#define XSTATE_MAX_MASK         0x7

#define XSTATE_SSE_MASK_STRING  "0x3"
#define XSTATE_AVX_MASK_STRING  "0x7"
#define XSTATE_MAX_MASK_STRING  "0x7"

#define XSTATE_SSE_SIZE         576
#define XSTATE_AVX_SIZE         832
#define XSTATE_MAX_SIZE         832

#define XSTATE_SSE_SIZE_STRING  "576"
#define XSTATE_AVX_SIZE_STRING  "832"
#define XSTATE_MAX_SIZE_STRING  "832"

struct i386_xstate_type
  {
    /* The extended state status.  */
    enum xstate_status status;
    /* The extended control register 0 (the XFEATURE_ENABLED_MASK
       register).  */
    unsigned long long xcr0;
    /* The extended state size in bytes.  */
    unsigned int size;
    /* The extended state size in unit of int64.  We use array of
       int64 for better alignment.  */
    unsigned int n_of_int64;
  };

extern struct i386_xstate_type i386_xstate;

extern void i386_xstate_init (void);
---

I don't need a system call to tell me xcr0 and size. If you
really want, you can put it in glibc and doesn't involve kernel.
We can use __cpu_features for it.


H.J.
