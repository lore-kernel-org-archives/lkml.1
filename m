Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZCRPXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZCRPXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZCRPXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:23:24 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54947 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZCRPXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:23:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=rqmVr9tcBOM5Tiu+3jMRm9/2Wnr8iCgOkXpeFC68sK4Au2DOoRBcmzxeWSmBkglrfZ
         KpsdhvRkyCT+TNBvgk8tOT8cSb+MZyY9HSuB1GVkXfNYEFrmj4+7SIYibrz+wd4wzIWw
         A/b47+I7gU9T9StE4YzfNJQdFkb3JKUGc48Cw=
From: =?iso-8859-15?q?G=E1bor_Melis?= <mega@retes.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RT signal queue overflow (Was: Q: SEGSEGV && uc_mcontext->ip (Was: Signal delivery order))
Date: Wed, 18 Mar 2009 16:23:17 +0100
User-Agent: KMail/1.9.9
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
References: <200903141750.37238.mega@retes.hu> <200903181002.07584.mega@retes.hu> <alpine.LFD.2.00.0903180742320.3082@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903180742320.3082@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903181623.17987.mega@retes.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Miércoles 18 Marzo 2009, Linus Torvalds wrote:
> On Wed, 18 Mar 2009, Gábor Melis wrote:
> > It was just a month or so ago when I finally made to change to use
> > a non-real-time signal for signalling stop-for-gc.
>
> Ahh, and that is when you noticed the issue with SIGSEGV?

Unfortunately not immediately because another change was needed make 
context frobbing sigsegvs frequent enough for this to be noticed ...

> One thing you might try is to still use a non-real-time signal, but
> simply depend on the fact that signals are basically peeled off the
> signal bitmask in a signal number order (with the exception that
> fatal signals are handled specially).
>
> IOW, on x86, just about the _only_ normal user-generated signal that
> can happen before SIGSEGV is SIGUSR1, because SIGSEGV is 11, and
> SIGUSR1 is 10.
>
> If you were to use SIGUSR2 (signal #12) you'd probably never see
> this.
>
> Of course, there are other signals with numbers < 11, but they are
> generally meant for other synchronous traps (ie signals like
> SIGTRAP/AIGABRT/SIGFPE/SIGBUS), or for killing the process (signals
> SIGHUP/SIGINT/SIGQUIT).
>
> So maybe you'd be happy with just picking another signal? It's not a
> _pretty_ solution, but it should work across most kernel versions.

So I did already. This is the workaround that I referred to before:

"... I'll stick to the SIGUSR2 workaround that's confirmed by Oleg."

So I'm happy enough that it's fixed in my app, but considering how hard 
it was to figure out what's going on, I thought the kernel people may 
be interested.

> 			Linus
