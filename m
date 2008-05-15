Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYEOEvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYEOEvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 00:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbYEOEve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 00:51:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:51467 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbYEOEvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 00:51:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,489,1204531200"; 
   d="scan'208";a="328453589"
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec
	multi-stage load
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m1lk2c4l4i.fsf@frodo.ebiederm.org>
References: <1210574441.30365.8.camel@caritas-dev.intel.com>
	 <20080513053408.GA5870@redhat.com>
	 <1210730266.23707.50.camel@caritas-dev.intel.com>
	 <20080514025607.GA19944@redhat.com>
	 <1210736275.23707.62.camel@caritas-dev.intel.com>
	 <m1lk2c4l4i.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 15 May 2008 12:57:53 +0800
Message-ID: <1210827473.23707.133.camel@caritas-dev.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 15 May 2008 04:51:27.0361 (UTC) FILETIME=[55828710:01C8B647]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-14 at 14:43 -0700, Eric W. Biederman wrote:
[...]
> Then as a preliminary design let's plan on this.
> 
> - Pass the rentry point as the return address (using the C ABI).
>   We may want to load the stack pointer etc so we can act as
>   a direct entry point for new code.

There are some issues about passing entry point as return address. The
kexec jump (or kexec with return) is used for

- Switching between original kernel (A) and kexeced kernel (B)
- Call some code (such as BIOS code) in physical mode

1) When call some code in physical mode, the called code can use a
simple return to return to kernel A. So there is no return address on
stack after return to kernel A. Instead, argument 1 is on stack top.

2) When switch back from kernel B to kernel A, kernel B will call the
jump back entry of kernel A with C ABI. So, the return address is on
stack top. And kernel A get jump back entry of kernel B via the return
address.

Because the stack state is different between 1) and 2), the jump back
entry of kernel A should distinguish them. Possible solution can be as
follow:

a) Before kernel A call some physical mode code or kernel B, it set
argument 1 to be a magic number that can not be return address (such as
-1). Jump back entry of kernel A can check whether the stack top is
argument 1 or return address.

b) Distinguish by return address. Such as, called physical mode code
must return 0, while kernel B must set %eax to some other number.

c) Use different entry point for 1) and 2). Two entry points are deduced
from return address. Such as:

entry1 = return_address;
entry2 = return_address & ~0xfff;	/* page aligned */

entry1 is used by physical mode code. entry2 is used by kernel B.


Which one is better? Or some other solution?

Best Regards,
Huang Ying

