Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYGQGIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYGQGIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYGQGIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:08:07 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:31752 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbYGQGIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:08:05 -0400
X-IronPort-AV: E=Sophos;i="4.31,201,1215388800"; 
   d="scan'208";a="87844943"
From: Roland Dreier <rdreier@cisco.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori \[imap\]" <aliguori@us.ibm.com>
Subject: Re: KVM overflows the stack
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	<47EA1C63.8010202@qumranet.com>
	<1206550329.7883.5.camel@nimitz.home.sr71.net>
	<47EA80AC.4070204@qumranet.com>
	<1206551794.7883.7.camel@nimitz.home.sr71.net>
	<47EB6AAC.3040607@qumranet.com> <47EB7281.6070300@qumranet.com>
	<1206629709.7883.30.camel@nimitz.home.sr71.net>
	<47EBB63E.2060306@qumranet.com>
	<1212445810.8211.9.camel@nimitz.home.sr71.net>
	<48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>
	<48512028.3070104@qumranet.com> <1216148242.25942.6.camel@nimitz>
	<1216244660.8711.6.camel@nimitz> <1216248527.11664.9.camel@nimitz>
	<487EDE26.8040201@qumranet.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Jul 2008 23:08:01 -0700
In-Reply-To: <487EDE26.8040201@qumranet.com> (Avi Kivity's message of "Thu, 17
	Jul 2008 08:52:38 +0300")
Message-ID: <ada4p6p9h6m.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jul 2008 06:08:01.0702 (UTC) FILETIME=[77F99460:01C8E7D3]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Yes, things like kvm_lapic_state are way too big to be on the stack.

I had a quick look at the code, and my worry about dynamic allocation
would be that handling allocation failure seems like it might get
tricky.  Eg for handling struct kvm_pv_mmu_op_buffer (which is 528 bytes
on the stack in kvm_pv_mmu_op()) can you deal with an mmu op failing?
(maybe in that case you can easily by just setting *ret to 0?)

 > There's an additional problem here, that apparently your gcc (which
 > version?) doesn't fold objects in a switch statement into the same
 > stack slot:
 > 
 > switch (...) {
 >    case x: {
 >         struct medium a;
 >         ...
 >    }
 >    case y:
 >          struct medium b;
 >          ...
 >    }
 > };

A trick for this is to do:

	union {
		struct medium1 a;
		struct medium2 b;
	} u;

	switch (...) {
	case x:
		use u.a;
		...

	case y:
		use u.b;
		...
	}
