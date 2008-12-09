Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYLIQgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYLIQgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYLIQfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:35:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYLIQfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:35:53 -0500
Subject: Re: [RFC/PATCH] No get_user/put_user while holding mmap_sem in
 do_pages_stat?
From: Peter Zijlstra <peterz@infradead.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <493BDBE6.9040600@inria.fr>
References: <493B3179.7030204@inria.fr>
	 <20081206185050.544f67fc.akpm@linux-foundation.org>
	 <493BDBE6.9040600@inria.fr>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Dec 2008 17:35:46 +0100
Message-Id: <1228840546.12654.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-07 at 15:21 +0100, Brice Goglin wrote:
> Andrew Morton wrote:
> > Was lockdep able to tell you about this in any way?
> >   
> 
> With CONFIG_PROVE_LOCKING (assuming that it's enough), it doesn't detect
> the problem for real. It just says "possible recursive locking detected"
> between do_page_fault and sys_move_pages.

That is real - how much more real do you need a description of a
recursive deadlock to be?

>  I actually understood the
> problem after hitting sysrq-t and always getting the following backtraces:
> * thread 1
> [<ffffffff80430cb8>] __down_write_nested+0x9c/0xb4
> [<ffffffff8028c2c4>] sys_mprotect+0xcc/0x230
> * thread 2
> [<ffffffff80430d73>] __down_read+0x9c/0xb4
> [<ffffffff80223f5c>] do_page_fault+0x551/0x9d9
> [...]
> [<ffffffff8043111a>] error_exit+0x0/0x70
> [<ffffffff802f5bec>] cap_task_movememory+0x0/0x3
> [<ffffffff8032b99d>] __put_user_4+0x1d/0x30
> [<ffffffff802a091f>] sys_move_pages+0x453/0x4c0

