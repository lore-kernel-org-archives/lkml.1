Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab0BZKZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:25:19 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:55317
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752929Ab0BZKZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:25:16 -0500
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dN936eM9371Pab9bhzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYG29V-01-3Z3-02
X-M-MSG: 
Date: Fri, 26 Feb 2010 11:25:07 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: SVM: Move msrpm offset calculation to
 seperate function
Message-ID: <20100226102506.GB12689@amd.com>
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
 <1267118149-15737-2-git-send-email-joerg.roedel@amd.com>
 <4B87A05A.3010600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B87A05A.3010600@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Feb 2010 10:25:07.0836 (UTC) FILETIME=[F7F993C0:01CAB6CD]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 12:20:10PM +0200, Avi Kivity wrote:
> On 02/25/2010 07:15 PM, Joerg Roedel wrote:
> >The algorithm to find the offset in the msrpm for a given
> >msr is needed at other places too. Move that logic to its
> >own function.
> >
> >  #define MAX_INST_SIZE 15
> >
> >@@ -417,23 +439,22 @@ err_1:
> >  static void set_msr_interception(u32 *msrpm, unsigned msr,
> >  				 int read, int write)
> >  {
> >-	int i;
> >+	u8 bit_read, bit_write;
> >+	unsigned long tmp;
> >+	u32 offset;
> >
> >-	for (i = 0; i<  NUM_MSR_MAPS; i++) {
> >-		if (msr>= msrpm_ranges[i]&&
> >-		    msr<  msrpm_ranges[i] + MSRS_IN_RANGE) {
> >-			u32 msr_offset = (i * MSRS_IN_RANGE + msr -
> >-					  msrpm_ranges[i]) * 2;
> >-
> >-			u32 *base = msrpm + (msr_offset / 32);
> >-			u32 msr_shift = msr_offset % 32;
> >-			u32 mask = ((write) ? 0 : 2) | ((read) ? 0 : 1);
> >-			*base = (*base&  ~(0x3<<  msr_shift)) |
> >-				(mask<<  msr_shift);
> >-			return;
> >-		}
> >-	}
> >-	BUG();
> >+	offset    = svm_msrpm_offset(msr);
> >+	bit_read  = 2 * (msr&  0x0f);
> >+	bit_write = 2 * (msr&  0x0f) + 1;
> >+
> >+	BUG_ON(offset == MSR_INVALID);
> >+
> >+	tmp = msrpm[offset];
> >+
> >+	read  ? clear_bit(bit_read,&tmp) : set_bit(bit_read,&tmp);
> >+	write ? clear_bit(bit_write,&tmp) : set_bit(bit_write,&tmp);
> >+
> >+	msrpm[offset] = tmp;
> >  }
> 
> This can fault - set_bit() accesses an unsigned long, which can be 8
> bytes, while offset can point into the last u32 of msrpm.  So this
> needs either to revert to u32 shift/mask ops or msrpm be changed to
> a ulong array (actually better, since bitmaps in general are defined
> as arrays of ulongs).

Ah true, I will fix that. Thanks.

> btw, the op-level ternary expression is terrible, relying solely on
> *_bit()'s side effects.  Please convert to an ordinary if.
> 
> btw2, use __set_bit() which atomic operation is not needed.

Right, will switch to __set_bit and __clear_bit.

	Joerg


