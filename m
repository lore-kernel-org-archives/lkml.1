Return-Path: <linux-kernel-owner+w=401wt.eu-S1766725AbXEBQq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766725AbXEBQq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766719AbXEBQqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:46:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:60886 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766718AbXEBQqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nb5Iev/afudF2nmDJk2UdmfUO2HMJirarupVm858MhCJBKDiYE73pnhHTYJyHcZvmliAlpU+uL3nuTudO9LDsUkiB0rHx+z8JjMSI4kv9FhX15LVqJiEZZ90suWW6GOkK+yl3Q387OtLab8jYqfW+Gkk76U43i7Qb7mvCn93A6s=
Message-ID: <a36005b50705020946x6cc1cb96r9ddd2b364ba168d7@mail.gmail.com>
Date: Wed, 2 May 2007 09:46:53 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davi Arnaut" <davi@haxent.com.br>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46388677.4050706@haxent.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <20070502053427.123392000@haxent.com.br>
	 <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
	 <46388677.4050706@haxent.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Davi Arnaut <davi@haxent.com.br> wrote:
> It's quite easy to implement this scheme by write()ing the futexes all
> at once but that would break the one futex per fd association. For
> atomicity: if one of the futexes can't be queued, we would rollback
> (unqueue) the others.
>
> Sounds sane?

I don't know how you use "unqueue" in this context.  If a queued futex
is one which is /locked/ by te call, then yes, this is the semantics
needed.  Atomically locking a number of futexes means that if one of
the set cannot be locked all operations done to lock the others have
to be undone.  It's an all-or-nothing situation.

Locking is not as easy as you might think, though.  For non-PI futexes
there is deliberately no protocol in place describing what "locked"
means.  The locking operation has to be customizable.  This is what
the FUTEX_OP_* stuff is about.

And you wrote that currently each futex needs its own file descriptor.
 So this would have to be changed, too.
