Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab0BRQRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:17:16 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:31729 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab0BRQRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:17:13 -0500
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dN936eM9371Pab9bhzz1202hzzz32i87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1P7S-01-9JK-02
X-M-MSG: 
Date: Thu, 18 Feb 2010 17:16:37 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 01/10] KVM: SVM: Don't use kmap_atomic in nested_svm_map
Message-ID: <20100218161637.GP22141@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
 <1266493115-28386-2-git-send-email-joerg.roedel@amd.com>
 <4B7D4368.6020903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B7D4368.6020903@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Feb 2010 16:16:37.0775 (UTC) FILETIME=[BF40E1F0:01CAB0B5]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 03:40:56PM +0200, Avi Kivity wrote:
> On 02/18/2010 01:38 PM, Joerg Roedel wrote:
> >Use of kmap_atomic disables preemption but if we run in
> >shadow-shadow mode the vmrun emulation executes kvm_set_cr3
> >which might sleep or fault. So use kmap instead for
> >nested_svm_map.
> >
> >
> >
> >-static void nested_svm_unmap(void *addr, enum km_type idx)
> >+static void nested_svm_unmap(void *addr)
> >  {
> >  	struct page *page;
> >
> >@@ -1443,7 +1443,7 @@ static void nested_svm_unmap(void *addr, enum km_type idx)
> >
> >  	page = kmap_atomic_to_page(addr);
> >
> >-	kunmap_atomic(addr, idx);
> >+	kunmap(addr);
> >  	kvm_release_page_dirty(page);
> >  }
> 
> kunmap() takes a struct page *, not the virtual address (a
> consistent source of bugs).

Ah true, thanks. I'll fix that.

> kmap() is generally an unloved interface, it is slow and possibly
> deadlock prone, but it's better than sleeping in atomic context.  If
> you can hack your way around it, that is preferred.

Best would be to use kvm_read_guest, but I fear that this will have an
performance impact. Maybe I'll try this and measure if it really has a
significant performance impact.

	Joerg


