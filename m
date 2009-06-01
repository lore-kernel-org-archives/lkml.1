Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZFAQSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZFAQSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZFAQS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:18:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34645 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbZFAQSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:18:25 -0400
Date: Mon, 1 Jun 2009 18:12:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090601161234.GA10486@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet> <20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, Alan Cox wrote:
>
> On Sun, 31 May 2009 01:33:39 -0400
> Paul Smith <paul@mad-scientist.net> wrote:
>
> > coredump: Retry writes where appropriate
> >
> > Core dump write operations (especially to a pipe) can be incomplete due
> > to signal reception or possibly recoverable partial writes.
>
> NAK this
>
> > Previously any incomplete write in the ELF core dumper caused the core
> > dump to stop, giving short cores in these cases.  Modify the core dumper
> > to retry the write where appropriate.
>
> The existing behaviour is an absolute godsend when you've something like
> a core dump stuck on an NFS mount or something trying to core dump to
> very slow media.

I agree, we should make the coredumping interruptible.

But I don't know which signal should intterrupt. At least SIGKILL should,
I think. As for other unhandled sig_fatal() signals, I am nor sure.
I can make a patch, but first I need to know what this patch should do.
Again, please look at:

	killable/interruptible coredumps
	http://marc.info/?l=linux-kernel&m=121665710711931


And we should not change dump_write(), we should create the new helper
which can be used by all fs/binfmt_*.c.

And of course, the coredumping thread should not play with ->blocked
or ->sighand->action. This is not even needed.

Oleg.

