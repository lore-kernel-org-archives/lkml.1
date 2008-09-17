Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYIQCp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYIQCp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 22:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYIQCpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 22:45:16 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50273 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYIQCpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 22:45:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Simon Horman <horms@verge.net.au>
Cc: Jonathan Steel <jon.steel@esentire.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
References: <48D0067F.3020007@esentire.com>
	<20080917005542.GD15750@verge.net.au>
Date: Tue, 16 Sep 2008 19:40:55 -0700
In-Reply-To: <20080917005542.GD15750@verge.net.au> (Simon Horman's message of
	"Wed, 17 Sep 2008 10:55:42 +1000")
Message-ID: <m1tzcfa408.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: horms@verge.net.au, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, jon.steel@esentire.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Simon Horman <horms@verge.net.au>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1271]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kexec, kernel 2.6.26.5, segmentation fault in kimage_add_entry
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman <horms@verge.net.au> writes:

> On Tue, Sep 16, 2008 at 03:18:23PM -0400, Jonathan Steel wrote:
>> A segmentation fault can occur in kimage_add_entry in kexec.c when 
>> loading a kernel image into memory. The fault occurs because a page is 
>> requested by calling kimage_alloc_page with gfp_mask GFP_KERNEL and the 
>> function may actually return a page with gfp_mask GFP_HIGHUSER. The high 
>> mem page is returned because it was swapped with the kernel page due to 
>> the kernel page being a page that will shortly be copied to.
>> 
>> This patch ensures that kimage_alloc_page returns a page that was 
>> created with the correct gfp flags.
>
> I wonder if this problem might also affect other users of
> kimage_alloc_pages(), and if so, perhaps it should guard
> against this?

No.  kimage_alloc_pages() is a light wrapper around alloc_pages that simply
marks the pages as reserved so they don't get used for other things while
we have a hold of them.

kimage_alloc_page() does a check to see if the page we have just allocated
is the a page we are going to copy to and if so it does the copy of the
data now, and frees the page that was holding the data.

As an optimization it returns the page holding the data.  The problem is that
we allocate control pages as GFP_KERNEL and data pages GFP_HIGHUSER.  And so
they are not completely interchangeable.

Since this check and swap only happens inside of kimage_alloc_page it only affects
kimage_alloc_page.

Eric
n
