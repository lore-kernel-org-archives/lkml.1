Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbZIBJAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbZIBJAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 05:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbZIBJAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 05:00:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZIBJAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 05:00:45 -0400
Date: Wed, 2 Sep 2009 11:00:46 +0200
From: Jiri Bohac <jbohac@suse.cz>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, "'Jiri Bohac'" <jbohac@suse.cz>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>
Subject: Re: [RFC][PATCH] ia64: fix csum_ipv6_magic()
Message-ID: <20090902090046.GA27547@midget.suse.cz>
References: <20090827211113.GA22793@midget.suse.cz>
 <A6AD88C3F2289247BE726C37303E1EB8B954B4A6@orsmsx505.amr.corp.intel.com>
 <57C9024A16AD2D4C97DC78E552063EA3E038D4AE@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E038D4AE@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 04:20:34PM -0700, Luck, Tony wrote:
> >--- a/arch/ia64/lib/ip_fast_csum.S
> >+++ b/arch/ia64/lib/ip_fast_csum.S
> >@@ -96,20 +96,22 @@ END(ip_fast_csum)
> > GLOBAL_ENTRY(csum_ipv6_magic)
> > 	ld4	r20=[in0],4
> > 	ld4	r21=[in1],4
> >-	dep	r15=in3,in2,32,16
> >+	zxt4	in3=in3
> 
> I think this zxt4 instruction have a typo.  You really want to zap the
> high part on "in2" here (the "len") parameter.  "in3" contains the "proto"
> argument, which is only 16-bits.  But any garbage in the high part on in3
> will be dropped by the "dep" instruction later which only pulls out the low
> 16 bits from it.
> 
> So I think you meant to type:
> 
> 	zxt4	in2=in2
> 
> Does this make sense?

Yes, exactly, you are right. Thanks for spotting it. The fixed patch
follows:


[IA64] fix csum_ipv6_magic()

The 32-bit parameters (len and csum) of csum_ipv6_magic() are passed in 64-bit
registers in3 and in4. The high order 32 bits of the registers were never
cleared, and garbage was sometimes calculated into the checksum.

Fix this by clearing the high order 32 bits of the registers.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

diff --git a/arch/ia64/lib/ip_fast_csum.S b/arch/ia64/lib/ip_fast_csum.S
index 1f86aeb..9a8d23f 100644
--- a/arch/ia64/lib/ip_fast_csum.S
+++ b/arch/ia64/lib/ip_fast_csum.S
@@ -96,20 +96,22 @@ END(ip_fast_csum)
 GLOBAL_ENTRY(csum_ipv6_magic)
 	ld4	r20=[in0],4
 	ld4	r21=[in1],4
-	dep	r15=in3,in2,32,16
+	zxt4	in2=in2
 	;;
 	ld4	r22=[in0],4
 	ld4	r23=[in1],4
-	mux1	r15=r15,@rev
+	dep	r15=in3,in2,32,16
 	;;
 	ld4	r24=[in0],4
 	ld4	r25=[in1],4
-	shr.u	r15=r15,16
+	mux1	r15=r15,@rev
 	add	r16=r20,r21
 	add	r17=r22,r23
+	zxt4	in4=in4
 	;;
 	ld4	r26=[in0],4
 	ld4	r27=[in1],4
+	shr.u	r15=r15,16
 	add	r18=r24,r25
 	add	r8=r16,r17
 	;;


-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

