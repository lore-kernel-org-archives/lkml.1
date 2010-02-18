Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab0BRECd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 23:02:33 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56452 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0BRECc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 23:02:32 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
	<1266014143-29444-27-git-send-email-jason.wessel@windriver.com>
	<20100212150027.f875bbde.akpm@linux-foundation.org>
	<4B75E7AB.4060102@windriver.com>
	<20100212204141.cc42f298.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Feb 2010 20:02:20 -0800
In-Reply-To: <20100212204141.cc42f298.akpm@linux-foundation.org> (Andrew Morton's message of "Fri\, 12 Feb 2010 20\:41\:41 -0800")
Message-ID: <m1zl37yywj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 26/28] kdb,panic,debug_core: Allow the debug core to receive a panic before smp_send_stop()
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 12 Feb 2010 17:43:39 -0600 Jason Wessel <jason.wessel@windriver.com> wrote:
>
>> >>  	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
>> >>  #ifdef CONFIG_DEBUG_BUGVERBOSE
>> >>  	dump_stack();
>> >> @@ -91,8 +94,6 @@ NORET_TYPE void panic(const char * fmt, ...)
>> >>  	 */
>> >>  	smp_send_stop();
>> >>  
>> >> -	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>> >> -
>> >>  	bust_spinlocks(0);
>> >>  
>> >>  	if (!panic_blink)
>> >>     
>> >
>> > So the notifier call now happens before all the printks and the kexec
>> > and kmsg_dump handling.  What effect does this have upon the code which
>> > implements kexec and kmsg_dump?
>> >
>> >   
>> 
>> I certainly don't want to break kexec or alter any behavior, does that
>> mean kgdb / kdb should hook the kexec for notification?
>> 
>> I think ideally it is a end user's preference as to if they want in via
>> kexec or the kernel debugger.  Calling the smp_send_stop() prior to the
>> notifier was a death sentence for the kernel debugger. 
>> 
>> Perhaps I can move the notifier before smp_send_stop()?
>
> Well.  My question can be simplified to "does this break existing code"?

Yes.  Removing the bust_spinlocks(1) and moving the panic notification up
will measurably decrease the reliability of crash dump capture.  I expect
it will even result in dead_locks where we fail to print the panic message
for people who are trying to debug via the console.

Eric
