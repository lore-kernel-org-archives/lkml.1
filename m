Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZAZS5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZAZS5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZAZS4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:56:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:37511 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZAZS4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:56:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TKs2ku5P6Gcssur5pLVhXCqVLIsjXgiPd+oWieLqnvdwX3a1Bpmi8Yg9l+iWqr+LDr
         Ls1u4JWAlqD7B1i9D2xGDrxtOnk+TTCd+6gOcHIYeKixde5/DIw32yAOB8UJ+LU1Gm+D
         dzZ30eFxduOhKPRlWBr5gz/hHKjraCOAT+jI0=
Date: Mon, 26 Jan 2009 21:56:48 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 -tip 3/3] x86: ia32_signal: use {get|put}_user_try and
	catch
Message-ID: <20090126185648.GD31918@localhost>
References: <4962CAAE.6090300@ct.jp.nec.com> <496476D0.5040607@zytor.com> <497A5737.8030408@ct.jp.nec.com> <497A57CE.3080602@ct.jp.nec.com> <20090124073638.GA8752@localhost> <497E0167.10604@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497E0167.10604@ct.jp.nec.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Hiroshi Shimamoto - Mon, Jan 26, 2009 at 10:31:03AM -0800]
| Cyrill Gorcunov wrote:
| > [Hiroshi Shimamoto - Fri, Jan 23, 2009 at 03:50:38PM -0800]
| > | From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
| > | 
| > | Impact: use new framework
| > | 
| > | Use {get|put}_user_try, catch, and _ex in arch/x86/ia32/ia32_signal.c.
| > | 
| > | Note: this patch contains "WARNING: line over 80 characters", because when
| > | introducing new block I insert an indent to avoid mistakes by edit.
| > | 
| > | Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
| > | ---
| > |  arch/x86/ia32/ia32_signal.c |  365 +++++++++++++++++++++++--------------------
| > |  1 files changed, 195 insertions(+), 170 deletions(-)
| > | 
| > | diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
| > | index 9dabd00..dd77ac0 100644
| > | --- a/arch/x86/ia32/ia32_signal.c
| > | +++ b/arch/x86/ia32/ia32_signal.c
| > | @@ -46,78 +46,83 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
| > |
| > ... 
| > | +	put_user_try {
| > | +		/* If you change siginfo_t structure, please make sure that
| > | +		   this code is fixed accordingly.
| > | +		   It should never copy any pad contained in the structure
| > | +		   to avoid security leaks, but must copy the generic
| > | +		   3 ints plus the relevant union member.  */
| > | +		put_user_ex(from->si_signo, &to->si_signo);
| > | +		put_user_ex(from->si_errno, &to->si_errno);
| > | +		put_user_ex((short)from->si_code, &to->si_code);
| > | +
| > | +		if (from->si_code < 0) {
| > | +			put_user_ex(from->si_pid, &to->si_pid);
| > | +			put_user_ex(from->si_uid, &to->si_uid);
| > | +			put_user_ex(ptr_to_compat(from->si_ptr), &to->si_ptr);
| > | +		} else {
| > | +			/*
| > | +			 * First 32bits of unions are always present:
| > | +			 * si_pid === si_band === si_tid === si_addr(LS half)
| > | +			 */
| > | +			put_user_ex(from->_sifields._pad[0],
| > | +					  &to->_sifields._pad[0]);
| > | +			switch (from->si_code >> 16) {
| > | +			case __SI_FAULT >> 16:
| > | +				break;
| > | +			case __SI_CHLD >> 16:
| > | +				put_user_ex(from->si_utime, &to->si_utime);
| > | +				put_user_ex(from->si_stime, &to->si_stime);
| > | +				put_user_ex(from->si_status, &to->si_status);
| > | +				/* FALL THROUGH */
| > | +			default:
| > 
| > Hi Hiroshi,
| 
| Hi Cyrill,
| 
| > 
| > may I ask why we use default here?
| 
| I don't know:) Hm, it looks old code.
| arch/i386/kernel/signal.c in 2.4 has similar code.
| 
| I guess this code didn't change when copy_siginfo_to_user() was moved
| from arch/i386/kernel/signal.c to kernel/signal.c.
| 
| Should we change this like copy_siginfo_tu_user() in kernel/signal.c?
| Copying si_pid was added in kernel/signal.c.
| 
| BTW, it seems same __ST_KILL and default.

Hiroshi, to be fair -- I just don't know what the
right solution would be ;-) I just noticed that
default: here a bit useless since we do 'testing'
the (from->si_code >> 16) after default: anyway.

So choose one /since I'm not really familiar with
process management in kernel/ :)

		-- Cyrill --
