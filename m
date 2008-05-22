Return-Path: <linux-kernel-owner+w=401wt.eu-S934890AbYEVNYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934890AbYEVNYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762498AbYEVNYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:24:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:57996 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762362AbYEVNYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NXhsGspxucVXNnDs0TdPZt80kSnQDFw705G7VooHWQIthLS4PbfS3iN8SXksjR+E1LBPwAx2pVAL1jtFOS2hzAEPdS0h4ELSikFTPGsFXHggRpSLaQr3dZjZdAIKw3+DbT4qCMD0cw7YaJTVs3qEfWnrZbc4RCPsmpdNI1H7+Qs=
Message-ID: <3877989d0805220624i259a9d1j708795c65c636ca0@mail.gmail.com>
Date: Thu, 22 May 2008 21:24:11 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <20080522111826.BB90326FA24@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <1211446045.5610.33.camel@elijah.suse.cz>
	 <3877989d0805220216o5add20ddye2a1fde98a0c1e69@mail.gmail.com>
	 <20080522111826.BB90326FA24@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 7:18 PM, Roland McGrath <roland@redhat.com> wrote:
> I really cannot figure out from anything you've said what the failure mode
> is or how you think it should be affected.

Sorry for confusion, Let me try to explain it more:

For ia64,the code path is like:
ptrace_notify (to let the debugger run)--> ptrace_stop
-->spin_unlock_irq->arch_ptrace_stop (ia64_ptrace_stop) ->[sync rbs
and set NOTIFY_RESUME.....]-->spin_lock_irq->set TASK_TRACED flag (to
let the debugger run)

For x86, the code path is like:
ptrace_notify (to let the debugger run) ->ptrace_stop->set TASK_TRACED
flag (to let the debugger run)-->spin_unlock_irq

If TASK_TRACED is not set earlier before arch_ptrace_stop on ia64
ptrace_notify code path, some signals would be delivered without
letting debugger run.. (i.e. PTRACED logica in get_signal_to_deliver
would be ignored totally!). These should cause the test case hang on
ia64. And x86 just works..

If you have any question , I would dig further..

Thanks,
Luming
