Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbZD0Uh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbZD0Uh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761185AbZD0UhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:37:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10400 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761158AbZD0Ug6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:36:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fKtUzPoHl4DI3BnXtnsqBR0hquz+vY7llqasWF34R7QGTxQycg5eG4fMeE1yHBKgb
	/HC9feue/5bU3C2M6QnoA==
Date: Mon, 27 Apr 2009 13:36:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bart <mmx@riz.pl>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #13112] Oops in drain_array
In-Reply-To: <Pine.LNX.4.64.0904271849590.2455@galaxy.riz.pl>
Message-ID: <alpine.DEB.2.00.0904271327140.11650@chino.kir.corp.google.com>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>  <egHshlwQQFE.A.KjC.JpE9JB@chimera> <alpine.DEB.2.00.0904261314430.18988@chino.kir.corp.google.com> <84144f020904270152o6567e84cj914934120315bf90@mail.gmail.com> <alpine.DEB.1.10.0904271000200.16119@qirst.com>
 <Pine.LNX.4.64.0904271849590.2455@galaxy.riz.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Bart wrote:

> After turning the suggested debuging options I've got tons of these when
> trying to stress the tape device like before:
> 
> Apr 27 16:57:30 fs kernel: [   96.446708] slab error in verify_redzone_free():
> cache `size-128': memory outside object was overwritten
> Apr 27 16:57:30 fs kernel: [   96.446713] Pid: 0, comm: swapper Not tainted
> 2.6.29.1-64 #2
> Apr 27 16:57:30 fs kernel: [   96.446715] Call Trace:
> Apr 27 16:57:30 fs kernel: [   96.446717]  <IRQ>  [<ffffffff8029adc5>]
> __slab_error+0x1f/0x25
> Apr 27 16:57:30 fs kernel: [   96.446728]  [<ffffffff8029b24b>]
> cache_free_debugcheck+0x108/0x1d6
> Apr 27 16:57:30 fs kernel: [   96.446731]  [<ffffffff8029b473>]
> kfree+0x81/0xc2
> Apr 27 16:57:30 fs kernel: [   96.446735]  [<ffffffff802bd311>]
> bio_free_map_data+0xc/0x1e

This appears to be kfree(bmd->iovecs) in bio_free_map_data().  It looks 
like the memcpy size in bio_set_map_data() overrides the kmalloc size; in 
other words, for a redzone error, bio->bi_vcnt > nr_pages in 
bio_copy_user_iov().
