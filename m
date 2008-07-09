Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYGIXWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYGIXWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 19:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYGIXWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 19:22:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53836 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbYGIXV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 19:21:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org>
	<4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org>
	<487502FB.3090106@sgi.com> <487507A1.2020100@goop.org>
	<m1r6a2yfip.fsf@frodo.ebiederm.org>
	<20080709141044.60a0753e@infradead.org>
Date: Wed, 09 Jul 2008 16:20:11 -0700
In-Reply-To: <20080709141044.60a0753e@infradead.org> (Arjan van de Ven's
	message of "Wed, 9 Jul 2008 14:10:44 -0700")
Message-ID: <m1d4lmk5lg.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Arjan van de Ven <arjan@infradead.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4907]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

>> I think the unification is valid and useful, and that trying to keep
>> that stupid stack canary working is currently more trouble then it is
>> worth.
>
> I think that "unification over everything" is stupid, especially if it
> removes useful features.

After looking at this some more any solution that actually works will
enable us to make the stack canary work, as we have a 32bit offset to
deal with.  So there is no point in killing the feature.

That said I have no sympathy for a thread local variable that is
compiled as an absolute symbol instead of using the proper thread
local markup.  The implementation of -fstack-protector however useful
still appears to be a nasty hack, ignoring decades of best practice in
how to implement things.

Do you have a clue who we need to bug on the gcc team to get the
compiler to implement a proper TLS version of -fstack-protector?

- Unification over everything is stupid.  
- Interesting features that disregard decades implementation experience
  are also stupid.

Since we know that the code stack_canary is always a part of the
executable.  Being a fundamental part of glibc and libpthreads etc.
We can use the local exec model for tls storage.  The local exec model
means the compiler should be able to output code such as 
"movq %fs:stack_canary@tpoff, %rax" to read the stack canary in user space.
Instead it emits the much more stupid "movq "%fs:40, %rax".   Not even
letting the linker have a say in the placement of the variable.

So we either need to update the gcc code to do something proper or
someone needs to update the sysv tls abi spec so %fs:40 joins %fs:0 in
the ranks of magic address in thread local storage, so that other
compilers can reliably use offset 40, and no one will have an excuse
for changing it in the future.  Frankly I think updating the ABI is
the wrong solution but it at least it would document this stupidity.

Does -fstack-protector compiled code even fail to run with gcc that
does not implement a thread local variable at %fs:40?  Or does it
just silently break.

Eric
