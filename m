Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbZLUCEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbZLUCEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 21:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZLUCEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 21:04:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40015 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZLUCE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 21:04:29 -0500
Date: Mon, 21 Dec 2009 03:04:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] [0/11] SYSCTL: Use RCU to avoid races with string
	sysctls
Message-ID: <20091221020427.GA25372@basil.fritz.box>
References: <20091221220.243954235@firstfloor.org> <m1eimpm6hs.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1eimpm6hs.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 05:59:59PM -0800, Eric W. Biederman wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> > With BKL-less sysctls most of the writable string sysctls are racy. There
> > is no locking on the reader side, so a reader could see an inconsistent
> > string or worse miss the terminating null and walk of beyond it.
> 
> The walk will only extend up to the maximum length of the string.
> So the worst case really is inconsistent data.

It could still miss the 0 byte and walk out, can't it?

> This is an unfortunate corner case.  This is not a regression as this
> has been the way things have worked for years.  So probably 2.6.34
>  material.

The one that's a clear regression is the core pattern one, that 
was protected before by the BKL. A lot of others were always
broken yes.

> 
> > This patch kit adds a new "rcu string" variant to avoid these 
> > problems and convers the racy users. One the writer side the strings are 
> > always copied to new memory and the readers use rcu_read_lock()
> > to get a stable view. For readers who access the string over
> > sleeps the reader copies the string. 
> 
> I will have to look more after the holidays.  This rcu_string looks like
> it introduces allocations on paths that did not use them before, which
> has me wondering a bit.

On the reader side about all of them allocated before, e.g. for
call_usermodehelper.

If the strings were made a bit smaller this could be also 
put on the stack, but I didn't dare for 256 bytes. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
