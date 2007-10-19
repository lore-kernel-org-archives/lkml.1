Return-Path: <linux-kernel-owner+w=401wt.eu-S935766AbXJSToU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935766AbXJSToU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764556AbXJSToM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:44:12 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:65050 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764810AbXJSToK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LfXOaM5IQIAytyvIOjzTZIjdVhmiXJUyQNJ92CePzd/93NQDqRvPMmsGVSO9/IM8whzrsghDUAAtdBUaLuWv0UrYCJoEOUPdXe/gymKbIcrbfvt6PvAqXYtnB/c5/rC/iAcu6sUoCKSWFhGuWTcyoWQncosnmKQYCJCrtcnITCE=
Message-ID: <70318cbf0710191244v59bed9fekbef0ae1fcda22a6a@mail.gmail.com>
Date: Fri, 19 Oct 2007 12:44:09 -0700
From: "Chris Li" <christ.li@gmail.com>
To: "Alexey Dobriyan" <adobriyan@sw.ru>
Subject: Re: sparse breakage triggered by rcu_read_lock() lockdep annotations
Cc: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071016105521.GB6352@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071016105521.GB6352@localhost.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Err,

Sparse does not support the local label syntax yet. It just treats the
second label "x:" as the same as the first one. Then the linearize
code gets serious confused when it saw one label get define in two
places.

The fix seems not trivial from the first look.

Chris

On 10/16/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> FWIW, commit 851a67b825540a8e00c0be3ee25e4627ba8b133b
> aka "lockdep: annotate rcu_read_{,un}lock{,_bh}"
> causes sparse to trigger internal assertion in quite a few places over
> allyesconfig run.
>
>         sparse: flow.c:805: rewrite_parent_branch: Assertion `changed' failed.
>
> Trimmed down testcase:
>
>         void f(unsigned long ip);
>         static void g(void)
>         {
>                 if (1) {
>                       f(({ __label__ x; x: (unsigned long)&&x; }));
>                 }
>                 f(({ __label__ x; x: (unsigned long)&&x; }));
>         }
>
> #0  0x4001c410 in __kernel_vsyscall ()
> (gdb) bt
> #0  0x4001c410 in __kernel_vsyscall ()
> #1  0x40050701 in raise () from /lib/libc.so.6
> #2  0x40051e38 in abort () from /lib/libc.so.6
> #3  0x40049fcc in __assert_fail () from /lib/libc.so.6
> #4  0x08064947 in pack_basic_blocks (ep=0x411a1c6c) at flow.c:812
> #5  0x0805ffbf in linearize_symbol (sym=0x4103ec8c) at linearize.c:2154
> #6  0x080492a3 in main (argc=Cannot access memory at address 0x274d) at sparse.c:266
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
