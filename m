Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYKTAW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYKTAW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 19:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYKTAWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 19:22:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:27071 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYKTAWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 19:22:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=p6tx40658MRq9igW24Bne80AFQJePI/O2PH5SYknLAq4EkWBKTf1S8LkBBlBEeHEg7
         J/Q1ndYY4xK60/o7Kh39iVAIjJh5/oHy3Wbnj2JgK5LQKvZ65lQ0tnD7Z0hsD/JbTdF1
         hWlsBtoH7eUC7YPnhcNpRaw5tHwTGjRF7Zbg8=
From: Eric Lacombe <goretux@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [x86] do_arch_prctl
Date: Thu, 20 Nov 2008 01:22:07 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.5; KDE/4.1.3; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200811181835.07360.goretux@gmail.com> <200811200035.57509.goretux@gmail.com> <4924AA4E.4090001@goop.org>
In-Reply-To: <4924AA4E.4090001@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811200122.07694.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 novembre 2008 01:07:42 Jeremy Fitzhardinge, vous avez écrit :
> Eric Lacombe wrote:
> > Thanks for your answer, I've got one last question ;)
> > In the ARCH_GET_GS, can you explain the line 834 to 838?
> >
> > In fact, at first sight I thought that just the line 836 was sufficient,
> > but I obviously miss the case where MSR_KERNEL_GS_BASE does not reflect
> > the value requested, hence my question.
>
> I think the rationale is that rdmsr is slow, so reading the value from
> the task context is faster where possible.

But in this case why not doing instead:

828 case ARCH_GET_GS: {
829                 unsigned long base;
830                 unsigned gsindex;
831                 if (task->thread.gsindex == GS_TLS_SEL)
832                         base = read_32bit_tls(task, GS_TLS);
840                 else
841                         base = task->thread.gs;

> > 828 case ARCH_GET_GS: {
> > 829                 unsigned long base;
> > 830                 unsigned gsindex;
> > 831                 if (task->thread.gsindex == GS_TLS_SEL)
> > 832                         base = read_32bit_tls(task, GS_TLS);
> > 833                 else if (doit) {
> > 834                         asm("movl %%gs,%0" : "=r" (gsindex));
> > 835                         if (gsindex)
> > 836                                 rdmsrl(MSR_KERNEL_GS_BASE, base);
> > 837                         else
> > 838                                 base = task->thread.gs;
> > 839                 }
> > 840                 else
> > 841                         base = task->thread.gs;

and as I see with ARCH_GET_FS we have :

817         case ARCH_GET_FS: {
818                 unsigned long base;
819                 if (task->thread.fsindex == FS_TLS_SEL)
820                         base = read_32bit_tls(task, FS_TLS);
821                 else if (doit)
822                         rdmsrl(MSR_FS_BASE, base);
823                 else
824                         base = task->thread.fs;
825                 ret = put_user(base, (unsigned long __user *)addr);
826                 break;
827         }

So it seems that the "rdmsrl(MSR_FS_BASE, base);" could be faster than an 
access to the memory, else why bother with the "doit" case?

Regards,

	Eric

