Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYICAnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYICAnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYICAnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:43:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYICAnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:43:03 -0400
Date: Tue, 2 Sep 2008 17:42:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make taint bit reliable
Message-Id: <20080902174246.0587a04a.akpm@linux-foundation.org>
In-Reply-To: <20080901164632.GA18159@basil.nowhere.org>
References: <20080901164632.GA18159@basil.nowhere.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 18:46:32 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Make taint bit reliable
> 
> It's somewhat unlikely that it happens, but right now a race window 
> between interrupts or machine checks or oopses could corrupt the tainted 
> bitmap because it is modified in a non atomic fashion.
> 
> Convert the taint variable to an unsigned long and use only atomic bit
> operations on it.
> 
> Unfortunately this means the intvec sysctl functions cannot be used on 
> it anymore.
> 
> It turned out the taint sysctl handler could actually be simplified
> a bit (since it only increases capabilities) so this patch actually
> removes code.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/kernel.h |    2 -
>  kernel/panic.c         |    5 ++-
>  kernel/sysctl.c        |   67 +++++++++++++++++++++----------------------------
>  3 files changed, 33 insertions(+), 41 deletions(-)

You missed one:

./arch/x86/kernel/smpboot.c:                    tainted &= ~TAINT_UNSAFE_SMP;


To prevent reoccurrences we could/should rename `tainted' to something else.

Also, it would end up with a beter result if we were to change 

- #define TAINT_PROPRIETARY_MODULE        (1<<0)
- #define TAINT_FORCED_MODULE             (1<<1)
...
+ #define TAINT_PROPRIETARY_MODULE        0
+ #define TAINT_FORCED_MODULE             1
...


and remove that ungainly log2() you had to add, and just prevent all
open-coded access to the 'tainted' global.  ie: add `int get_taint(void)'?

