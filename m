Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbZJHQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbZJHQdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932769AbZJHQde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:33:34 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:38666
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932577AbZJHQdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:33:32 -0400
X-SpamScore: -26
X-BigFish: VPS-26(z34a4jz1432R98dN936eM9371Pzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KR7FAC-01-0UJ-02
X-M-MSG: 
Date: Thu, 8 Oct 2009 18:32:34 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] KVM: SVM: Notify nested hypervisor of lost event
 injections
Message-ID: <20091008163234.GJ14073@amd.com>
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
 <1254996199-17667-2-git-send-email-joerg.roedel@amd.com>
 <4ACE0F6C.3060103@redhat.com>
 <20091008162222.GG14073@amd.com>
 <4ACE127A.6040304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4ACE127A.6040304@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Oct 2009 16:32:35.0198 (UTC) FILETIME=[F0FB49E0:01CA4834]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 06:25:30PM +0200, Avi Kivity wrote:
> On 10/08/2009 06:22 PM, Joerg Roedel wrote:
> >On Thu, Oct 08, 2009 at 06:12:28PM +0200, Avi Kivity wrote:
> >>On 10/08/2009 12:03 PM, Joerg Roedel wrote:
> >>>From: Alexander Graf<agraf@suse.de>
> >>>
> >>>If event_inj is valid on a #vmexit the host CPU would write
> >>>the contents to exit_int_info, so the hypervisor knows that
> >>>the event wasn't injected.
> >>>
> >>>We don't do this in nested SVM by now which is a bug and
> >>>fixed by this patch.
> >>We need to start thinking about regression tests for these bugs.  It
> >>would be relatively easy to set up something with save->cr3 == cr3
> >>(i.e. no isolation, mmu virtualization, etc.).
> >Should be doable with a in-kernel regression test-suite module, I think.
> >Triggering such (race-condition like) test cases from userspace is
> >somewhat hard.
> >
> 
> Isn't it sufficient, for this case, to inject a nested interrupt
> when the nested idt is not mapped?

No. The L1 guest needs to execute VMRUN with an interrupt to inject to
the L2 guest with event_inj. On that VMRUN instruction emulation an
interrupt becomes pending which causes an immediate #vmexit from L2 to
L2 again without even entering the L2 guest. The bug was that in this
case the event which the L1 tried to inject in the L2 was lost because
it was not copied to exit_int_info.

	Joerg


