Return-Path: <linux-kernel-owner+w=401wt.eu-S1764046AbYEOSu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764046AbYEOSu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbYEOSuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:50:23 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52290 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYEOSuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:50:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1210574441.30365.8.camel@caritas-dev.intel.com>
	<20080513053408.GA5870@redhat.com>
	<1210730266.23707.50.camel@caritas-dev.intel.com>
	<20080514025607.GA19944@redhat.com>
	<1210736275.23707.62.camel@caritas-dev.intel.com>
	<m1lk2c4l4i.fsf@frodo.ebiederm.org>
	<1210827473.23707.133.camel@caritas-dev.intel.com>
Date: Thu, 15 May 2008 11:39:47 -0700
In-Reply-To: <1210827473.23707.133.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Thu, 15 May 2008 12:57:53 +0800")
Message-ID: <m1lk2bs970.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;_HEADER(TO)
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0038]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec multi-stage load
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> On Wed, 2008-05-14 at 14:43 -0700, Eric W. Biederman wrote:
> [...]
>> Then as a preliminary design let's plan on this.
>> 
>> - Pass the rentry point as the return address (using the C ABI).
>>   We may want to load the stack pointer etc so we can act as
>>   a direct entry point for new code.
>
> There are some issues about passing entry point as return address. The
> kexec jump (or kexec with return) is used for
>
> - Switching between original kernel (A) and kexeced kernel (B)
> - Call some code (such as BIOS code) in physical mode
>
> 1) When call some code in physical mode, the called code can use a
> simple return to return to kernel A. So there is no return address on
> stack after return to kernel A. Instead, argument 1 is on stack top.
>
> 2) When switch back from kernel B to kernel A, kernel B will call the
> jump back entry of kernel A with C ABI. So, the return address is on
> stack top. And kernel A get jump back entry of kernel B via the return
> address.
>
> Because the stack state is different between 1) and 2), the jump back
> entry of kernel A should distinguish them.

Yes.  Because the stack state is different we need to be careful.

However I don't see that we care how we got to the proper piece of
code.  If we don't care we don't need to distinguish them.

Therefore I see two possible solutions.
1) Write a tiny trampoline that goes in the core file to keep
   the calling conventions sane.

2) After we figure out our address read the stack pointer from
   a fixed location and simply set it.  (This is my preference)

Eric
