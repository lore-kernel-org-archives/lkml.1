Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZFYSC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZFYSC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZFYSCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:02:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59271 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbZFYSCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:02:17 -0400
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not  mounted
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 25 Jun 2009 11:02:14 -0700
In-Reply-To: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com> (Denys Vlasenko's message of "Thu\, 25 Jun 2009 01\:00\:56 +0200")
Message-ID: <m17hz0i449.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: vda.linux@googlemail.com, vapier@gentoo.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> writes:

> In some circumstances running process needs to re-execute
> its image.
>
> Among other useful cases, it is _crucial_ for NOMMU arches.
>
> They need it to perform daemonization. Classic sequence
> of "fork, parent dies, child continues" can't be used
> due to lack of fork on NOMMU, and instead we have to do
> "vfork, child re-exec itself (with a flag to not daemonize)
> and therefore unblocks parent, parent dies".

Why?

I would expect a simple assembly wrapper around clone would work.
I.e.  Create a new process but share the MM and reuse the same
stack. When clone returns if we are the parent exit, otherwise
continue on with life.

> Another crucial use case on NOMMU is POSIX shell support.
> Imagine a shell command of the form "func1 | func2 | func3".
> This can be implemented on NOMMU by vforking thrice,
> re-executing the shell in every child in the form
> "<shell> -c 'body of funcN'", and letting parent wait and collect
> exitcodes and such. As far as I can see, it's the only way
> to implement it correctly on NOMMU.
>
> The program may re-execute itself by name if it knows the name,
> but we generally may be unsure about it. Binary may be renamed,
> or even deleted while it is being run.

It really sounds like you want to implement fork for NOMMU.
If you have a base address register which everything is relative
to I can't imagine it would be too hard.  Heck you might even be
able to do it in user space.  

Eric

