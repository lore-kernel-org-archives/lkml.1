Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936066Ab0BZMkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:40:22 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53403 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935863Ab0BZMkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:40:18 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 07:40:18 EST
X-SpamScore: -15
X-BigFish: VPS-15(zz1432R98dNab9bhzz1202hzzz32i6bh87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYG7TR-01-8R6-02
X-M-MSG: 
Date: Fri, 26 Feb 2010 13:25:02 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: SVM: Optimize nested svm msrpm merging
Message-ID: <20100226122502.GC12689@amd.com>
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
 <1267118149-15737-3-git-send-email-joerg.roedel@amd.com>
 <4B87A248.1050300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B87A248.1050300@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Feb 2010 12:25:03.0080 (UTC) FILETIME=[B8ACAE80:01CAB6DE]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 12:28:24PM +0200, Avi Kivity wrote:
> >+static void add_msr_offset(u32 offset)
> >+{
> >+	u32 old;
> >+	int i;
> >+
> >+again:
> >+	for (i = 0; i<  MSRPM_OFFSETS; ++i) {
> >+		old = msrpm_offsets[i];
> >+
> >+		if (old == offset)
> >+			return;
> >+
> >+		if (old != MSR_INVALID)
> >+			continue;
> >+
> >+		if (cmpxchg(&msrpm_offsets[i], old, offset) != old)
> >+			goto again;
> >+
> >+		return;
> >+	}
> >+
> >+	/*
> >+	 * If this BUG triggers the msrpm_offsets table has an overflow. Just
> >+	 * increase MSRPM_OFFSETS in this case.
> >+	 */
> >+	BUG();
> >+}
> 
> Why all this atomic cleverness?  The possible offsets are all
> determined statically.  Even if you do them dynamically (makes sense
> when considering pmu passthrough), it's per-vcpu and therefore
> single threaded (just move msrpm_offsets into vcpu context).

The msr_offset table is the same for all guests. It doesn't make sense
to keep it per vcpu because it will currently look the same for all
vcpus. For standard guests this array contains 3 entrys. It is marked
with __read_mostly for the same reason.

> >@@ -1846,20 +1882,33 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
> >
> >  static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
> >  {
> >-	u32 *nested_msrpm;
> >-	struct page *page;
> >+	/*
> >+	 * This function merges the msr permission bitmaps of kvm and the
> >+	 * nested vmcb. It is omptimized in that it only merges the parts where
> >+	 * the kvm msr permission bitmap may contain zero bits
> >+	 */
> 
> A comment that describes the entire function can be moved above the
> function, freeing a whole tab stop for contents.

Ok, will move it out of the function.

	Joerg


