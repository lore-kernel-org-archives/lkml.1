Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbZEQU0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbZEQU0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZEQU0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:26:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:33376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZEQU0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:26:44 -0400
Date: Sun, 17 May 2009 13:26:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: tom.leiming@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Message-ID: <20090517132613.688da272@infradead.org>
In-Reply-To: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 23:13:42 +0800
tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> The async_schedule* may not be called in atomic contexts if out of
> memory or if there's too much work pending already, because the
> async function to be called may sleep.
> 
> This patch fixes the comment of async_schedule*, and introduces
> async_schedules*_atomic to allow them called from atomic contexts
> safely.

(sorry for the late response; have been away from most of my email for
a few days)

I like the general idea; I was hoping to do it a little bit different
though, API wise.
I don't mind the parameter for "don't do blocking things" (we should
use that to also use GFP_KERNEL/GFP_NOFS or whatever for the
allocation), it makes sense.

What I would like to see is the option to pass in memory that was
externally kmalloc'd. So that you can do

foo = kmalloc(..)
spin_lock(bar)
...
async_schedule_atomic(...);

spin_unlock(bar);
if (not_used_foo)
    kfree(foo);

in cases where you don't want to fail while in the atomic portion,
but can fail better earlier.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
