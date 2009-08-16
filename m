Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZHPBRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZHPBRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 21:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZHPBRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 21:17:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbZHPBRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 21:17:32 -0400
Date: Sat, 15 Aug 2009 18:15:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Guillaume Knispel <gknispel@proformatique.com>,
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] poll/select: initialize triggered field of struct
 poll_wqueues
Message-Id: <20090815181559.d73f0da6.akpm@linux-foundation.org>
In-Reply-To: <4A875874.20401@kernel.org>
References: <20090815193024.121926e6@xilun.lan.proformatique.com>
	<4A875874.20401@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009 09:53:08 +0900 Tejun Heo <tj@kernel.org> wrote:

> Guillaume Knispel wrote:
> > poll/select: initialize triggered field of struct poll_wqueues
> > 
> > The triggered field of struct poll_wqueues introduced in commit
> > 5f820f648c92a5ecc771a96b3c29aa6e90013bba "poll: allow f_op->poll to
> > sleep" was set to 1 in pollwake() (now __pollwake() ), tested and
> > later set to 0 in poll_schedule_timeout(), but not initialized before.
> > As a result when the process needs to sleep, triggered was likely to be
> > non-zero even if pollwake() is not called before the first
> > poll_schedule_timeout(), meaning schedule_hrtimeout_range() would not
> > be called and an extra loop calling all ->poll() would be done.
> > 
> > This patch initialize triggered to 0 in poll_initwait() so the ->poll()
> > are not called twice before the process goes to sleep when it needs to.
> > 
> > Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
> 
> Ah... nice spotting.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 

OK, thanks.

I tagged this for -stable backporting.  That isn't strictly needed, as
there's no particular harm caused here.  But using an uninitialised
variable in the core poll/select code is pretty gross.

