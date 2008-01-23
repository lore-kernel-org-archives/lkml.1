Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYAWLkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYAWLkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 06:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYAWLkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 06:40:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34011 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750807AbYAWLkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:40:41 -0500
Date: Wed, 23 Jan 2008 11:38:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove BKL from sysctl(2)
Message-ID: <20080123113800.1cecbc59@lxorguk.ukuu.org.uk>
In-Reply-To: <p73k5m0lrxq.fsf@crumb.suse.de>
References: <20080122202727.GB1975@martell.zuzino.mipt.ru>
	<20080123105140.3406e25b@lxorguk.ukuu.org.uk>
	<p73k5m0lrxq.fsf@crumb.suse.de>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 Jan 2008 12:09:05 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > 
> > There are cases that updating the corepath name and dumping a core at the
> > same moment can result in the wrong thing being exec()'d or a file being
> > opened which is a mix of the old and new name and could go anywhere.
> > 
> > I see two variants on your patch that work
> > 
> > #1	Replace the lock_kernel with a sysctl_update mutex and fix both
> > paths
> > #2	Add locking specifically to the corename path
> 
> Doesn't that apply to pretty much all proc_dostring users, not just
> corename? 
> 
> Some of them might be already broken if their readers don't take BKL.
> Also possibly some of the proc_dointvec for multiple numbers.

Yes - that's why I am wondering if we want a general 'sysctl' mutex or
just to fix the specific case. The corename case is nasty as it is timing
dependant against user activity rather than the less interesting "root
can be silly" type of problem.

If we have a general lock we can then fix the string cases, or even add a
sysctl_string_get() type function.

