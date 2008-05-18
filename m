Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbYERCKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbYERCKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 22:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbYERCKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 22:10:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42921 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbYERCKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 22:10:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <20080513053408.GA5870@redhat.com>
	<1210730266.23707.50.camel@caritas-dev.intel.com>
	<20080514025607.GA19944@redhat.com>
	<1210736275.23707.62.camel@caritas-dev.intel.com>
	<m1lk2c4l4i.fsf@frodo.ebiederm.org>
	<1210827473.23707.133.camel@caritas-dev.intel.com>
	<m1lk2bs970.fsf@frodo.ebiederm.org>
	<1210902114.23707.156.camel@caritas-dev.intel.com>
	<m14p8zgf43.fsf@frodo.ebiederm.org>
	<1210906575.23707.189.camel@caritas-dev.intel.com>
	<20080516032758.GD6926@redhat.com>
Date: Sat, 17 May 2008 18:59:58 -0700
In-Reply-To: <20080516032758.GD6926@redhat.com> (Vivek Goyal's message of
	"Thu, 15 May 2008 23:27:58 -0400")
Message-ID: <m1skwg8j8h.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0539]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec multi-stage load
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:
>
> To me this idea also looks good. So control flow will look something
> as follows?
>
> relocate_new kernel:
> 	
> 	if (!preserve_context)
> 		set registers to known state.
> 		jump to purgatory.
> 	else
> 		goto jump-back-setup:
>
> jump-back-setup:
> - Color the stack.
>   move $0xffffffff 0(%esp)
>
> - call %edx
>
> kexec_jump_back_entry:
>
> - If 0 (%esp) is not -1
> 	image->start = 0(%esp)  //Re entry point of kernel B. Store it.
>   else
> 	We returned from BIOS call. Re-entry point has not changed
>         Do nothing.
>
> - Continue to resume kernel A


That logic has more conditionals then I like but it may in
fact be reasonable.  I don't have any fundamental objections
into making this a co-routine interface.

That said.  I think immediately implementing a coroutine interface
is a premature optimization.  Please let's work on call/return.
Then prototype the coroutine method of suspend to swap and see
how much time it saves us.

Honestly I will be surprised if time will be saved, as historically
at least the bottleneck in kernel startup time is initializing
hardware, and we need to essentially redo all of that initialization.

Eric

