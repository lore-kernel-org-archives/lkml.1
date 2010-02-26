Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936055Ab0BZNEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:04:16 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37823 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935891Ab0BZNEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:04:14 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R98dN936eMzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYG9MQ-01-A2M-02
X-M-MSG: 
Date: Fri, 26 Feb 2010 14:04:01 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: SVM: Optimize nested svm msrpm merging
Message-ID: <20100226130401.GD12689@amd.com>
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
 <1267118149-15737-3-git-send-email-joerg.roedel@amd.com>
 <4B87A248.1050300@redhat.com>
 <20100226122502.GC12689@amd.com>
 <4E7D93ED-E5FC-4A64-B9B0-E2F644CD2B68@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E7D93ED-E5FC-4A64-B9B0-E2F644CD2B68@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Feb 2010 13:04:02.0054 (UTC) FILETIME=[2ACFCA60:01CAB6E4]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 01:28:29PM +0100, Alexander Graf wrote:
> 
> On 26.02.2010, at 13:25, Joerg Roedel wrote:
> 
> > On Fri, Feb 26, 2010 at 12:28:24PM +0200, Avi Kivity wrote:
> >>> +static void add_msr_offset(u32 offset)
> >>> +{
> >>> +	u32 old;
> >>> +	int i;
> >>> +
> >>> +again:
> >>> +	for (i = 0; i<  MSRPM_OFFSETS; ++i) {
> >>> +		old = msrpm_offsets[i];
> >>> +
> >>> +		if (old == offset)
> >>> +			return;
> >>> +
> >>> +		if (old != MSR_INVALID)
> >>> +			continue;
> >>> +
> >>> +		if (cmpxchg(&msrpm_offsets[i], old, offset) != old)
> >>> +			goto again;
> >>> +
> >>> +		return;
> >>> +	}
> >>> +
> >>> +	/*
> >>> +	 * If this BUG triggers the msrpm_offsets table has an overflow. Just
> >>> +	 * increase MSRPM_OFFSETS in this case.
> >>> +	 */
> >>> +	BUG();
> >>> +}
> >> 
> >> Why all this atomic cleverness?  The possible offsets are all
> >> determined statically.  Even if you do them dynamically (makes sense
> >> when considering pmu passthrough), it's per-vcpu and therefore
> >> single threaded (just move msrpm_offsets into vcpu context).
> > 
> > The msr_offset table is the same for all guests. It doesn't make sense
> > to keep it per vcpu because it will currently look the same for all
> > vcpus. For standard guests this array contains 3 entrys. It is marked
> > with __read_mostly for the same reason.
> 
> I'm still not convinced on this way of doing things. If it's static,
> make it static. If it's dynamic, make it dynamic. Dynamically
> generating a static list just sounds plain wrong to me.

Stop. I had a static list in the first version of the patch. This list
was fine except the fact that a developer needs to remember to update
this list if the list of non-intercepted msrs is expanded. The whole
reason for a dynamically built list is to take the task of maintaining
the list away from the developer and remove a possible source of hard to
find bugs. This is what the current approach does.

	Joerg


