Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbYKXT2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbYKXT2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYKXT2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:28:48 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:59776 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYKXT2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:28:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=iABgn6rcyK12ErLGTwH2rZCqYla/18G70tTJAhQwSVP0PWvlmASAtx+1j1UD85oe6q
         6hMZbjf49oWVSgQHHNKH8k2s/K8ZcX8crrl6Pk+My07BQ34nB41ZeD6qp0PyVjifUGYv
         6pjD1L1zH8Ytme45Q2BDdRKXGCu7l+If/J86E=
From: Eric Lacombe <goretux@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [x86] do_arch_prctl
Date: Mon, 24 Nov 2008 20:28:40 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.7; KDE/4.1.3; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200811181835.07360.goretux@gmail.com> <200811241324.54606.goretux@gmail.com> <492AF0DA.3060702@goop.org>
In-Reply-To: <492AF0DA.3060702@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811242028.40865.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 24 novembre 2008 19:22:18 Jeremy Fitzhardinge, vous avez écrit :
> Eric Lacombe wrote:
> > Hello,
> >
> > Does the "doit case" (line 822 in ARCH_GET_FS, function do_arch_prctl)
> > exist for performance reasons? Else, why "task->thread.fs" (line 824)
> > does not contain the fs base in the "doit case"?
>
> "doit" gets set when you're operating on yourself.  If you're operating
> on another process, then you need to use their task structure values
> rather than the current process's values.  If you're doing it to
> yourself, then the task structure may be out of date because its only
> updated on a context switch.

The task_struct is also updated in sys_arch_prctl (ARCH_SET_FS and 
ARCH_SET_GS), so not just on a context switch.
How the task structure could be out of date wrt thread.gs and thread.fs?
What could be a typical scenario that could induced gs or fs to be modified and 
not thread.gs and thread.fs?

Why we have a difference between ARCH_GET_GS :

> 833                 else if (doit) {
> 834                         asm("movl %%gs,%0" : "=r" (gsindex));
> 835                         if (gsindex)
> 836                                 rdmsrl(MSR_KERNEL_GS_BASE, base);
> 837                         else
> 838                                 base = task->thread.gs;
> 839                 }

and ARCH_GET_FS :

> 821                 else if (doit)
> 822                         rdmsrl(MSR_FS_BASE, base);

If I follow what you say, why can't we have the same optimization with in 
ARCH_GET_FS?

thanks,

	Eric


