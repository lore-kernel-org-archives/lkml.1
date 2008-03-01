Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbYCAO0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbYCAO0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 09:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYCAO0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 09:26:25 -0500
Received: from mail.codesourcery.com ([65.74.133.4]:43080 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYCAO0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 09:26:24 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2008 09:26:24 EST
Message-ID: <47C96659.80306@codesourcery.com>
Date: Sat, 01 Mar 2008 09:21:13 -0500
From: "Carlos O'Donell" <carlos@codesourcery.com>
Organization: CodeSourcery
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michael Kerrisk <michael.kerrisk@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com, Geoff Clare <gwc@opengroup.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
References: <1204119455.6242.403.camel@lappy>  <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>  <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>  <1204305244.6243.111.camel@lappy>  <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>  <1204307756.6243.121.camel@lappy> <47C84C6C.2000201@gmail.com>  <alpine.LFD.1.00.0802291032370.17889@woody.linux-foundation.org> <c49095e30802291149t7ad01f6bl59b9083bfb41c920@mail.gmail.com> <alpine.LFD.1.00.0802291200580.17889@woody.linux-foundation.org> <alpine.LFD.1.00.0802291350550.17889@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802291350550.17889@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 29 Feb 2008, Linus Torvalds wrote:
>> I do agree that we should at least make the "MAX(stacksize/4, 128k)" 
>> change for backwards compatibility.
> 
> How about something like this?

This is perfect. As the original submitter of the bug my primary 
interest is in having the regression fixed.

> The alternative is to just remove that size check entirely, and depend on 
> get_user_pages() doing the stack limit check (among all the *other* checks 
> it does when it does the acct_stack_growth() thing).
> 
> I'd almost prefer that simpler approach, but I don't have any really 
> strong preferences. Anybody?
> 
> 		Linus
> 
> ---
>  fs/exec.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index a44b142..e91f9cb 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -173,8 +173,15 @@ static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
>  		return NULL;
>  
>  	if (write) {
> -		struct rlimit *rlim = current->signal->rlim;
>  		unsigned long size = bprm->vma->vm_end - bprm->vma->vm_start;
> +		struct rlimit *rlim;
> +
> +		/*
> +		 * We've historically supported up to 32 pages of argument
> +		 * strings even with small stacks
> +		 */
> +		if (size <= 32*PAGE_SIZE)
> +			return page;

Could you use ARG_MAX as defined in include/linux/limits.h?

>  
>  		/*
>  		 * Limit to 1/4-th the stack size for the argv+env strings.
> @@ -183,6 +190,7 @@ static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
>  		 *  - the program will have a reasonable amount of stack left
>  		 *    to work from.
>  		 */
> +		rlim = current->signal->rlim;
>  		if (size > rlim[RLIMIT_STACK].rlim_cur / 4) {
>  			put_page(page);
>  			return NULL;

Cheers,
Carlos.
-- 
Carlos O'Donell
CodeSourcery
carlos@codesourcery.com
(650) 331-3385 x716
