Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbXFLLVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbXFLLVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 07:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXFLLVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 07:21:08 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:7583 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXFLLVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 07:21:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QD9EitCJMNRJh0s4O6N7DlqlvrdWs7+vdJtassqeN5CZ3v6hz4gFAdwMWkTZu/BDRX4SJSL+p4ldJTtKxUZOfISBTtzcoTtlVPbM9dJrLwvcdfxXHTWiqO4mUyBOASJjk1VsnbGYhRc13uYZdDlYnHjQk+FQ6Yyu0164j1vxzJM=
Message-ID: <a781481a0706120421l94f8d8dk864f288d63c01b1a@mail.gmail.com>
Date: Tue, 12 Jun 2007 16:51:04 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] fix improper .init-type section references
Cc: "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org
In-Reply-To: <466E89EB.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466E66AE.76E4.0078.0@novell.com>
	 <a781481a0706120242o5bcabee1ke67c96d5a7dd6cb0@mail.gmail.com>
	 <466E89EB.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Jan Beulich <jbeulich@novell.com> wrote:
> >> -static __init void kthreadd_setup(void)
> >> +static noinline __init_refok void kthreadd_setup(void)
> >>  {
> >>         struct task_struct *tsk = current;
> >
> >This isn't ok. There isn't any __init function that is (safely) referenced
> >by kthreadd_setup(), so we shouldn't really be marking it as such.
> >Also, kthreadd_setup() is really only ever called at init time, so we'd
> >want it to remain __init.
>
> Oh, I see, I misunderstood the purpose of the tag - I assumed it would
> mark an __init function that is known to only be referenced from init-only
> code paths inside non-init functions (i.e. I didn't pay attention that the
> resulting section's name is .text.init.refok, not .init.text.refok).
>
> I have to admit I have some difficulty understanding when the tags
> are going to be useful the way they are implemented right now.

Yup, I had discussed precisely the same issue (whether to associate
__init_refok with callers or callees) with Sam earlier, but he thought
it'd be more useful to have normal-caller-can-ref-init-callees semantics
for the same.

> >I believe the correct fix to silence modpost here would be to mark its
> >caller kthreadd() also as __init, because it too is used only at init time?
>
> I don't think so - it is my understanding that this is the body of a thread
> that never dies.

Ugh, yes, I'm smoking God-knows-what, and you're absolutely correct!

So we should be marking kthreadd() as __init_refok instead, it seems.

Satyam
