Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbYKCRjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbYKCRjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYKCRjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:39:33 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:57434 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYKCRjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:39:32 -0500
X-IronPort-AV: E=Sophos;i="4.33,537,1220227200"; 
   d="scan'208";a="101082720"
From: Roland Dreier <rdreier@cisco.com>
To: Constantine Gavrilov <constantine.gavrilov@gmail.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: patch: support long (above 14 bytes) HW addresses in arp_ioctl
References: <490EDBDD.1030104@gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 03 Nov 2008 09:39:30 -0800
In-Reply-To: <490EDBDD.1030104@gmail.com> (Constantine Gavrilov's message of
	"Mon, 03 Nov 2008 13:09:17 +0200")
Message-ID: <ada63n4wvxp.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Nov 2008 17:39:30.0879 (UTC) FILETIME=[207A54F0:01C93DDB]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > * arp_ioctl will corrupt the kernel and user memory when this ioctl is
 > used on the adapters that have HW addresses longer that 14 bytes.
 > This is because when copying the HW address, the arp_ioctl code copies
 > dev->addr_len bytes without checking that addr_len is not above 14
 > bytes. This is done both for copy_to_user() and memcpy() calls on
 > kernel data structures allocated on stack. The memcpy() call in
 > particular, will corrupt kernel stack.

It's not obvious to me after a quick glance where this kernel memory
corruption occurs, but clearly we should at least fix this bug.

 > The patch does not change the existing ABI but extends it.  The kernel
 > structure used in arp_ioctl calls is changed to support larger
 > addresses, while the user-space structure is extended by appending
 > extra-space to the end of the structure if ATF_NEWARPCTL -- a new flag
 > -- is set in arp_flags of existing user-space structure. This allows
 > avoiding big changes to the existing code while preserving the ABI
 > compatibility.

However, given that applications need to be changed to use this,
wouldn't it make more sense just to change those applications to use
rtnetlink, which already supports large hardware addresses?  ie is there
much point to extending a legacy ABI to add a feature that the preferred
modern interface already has?

 - R.
