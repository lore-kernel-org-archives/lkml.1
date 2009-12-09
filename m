Return-Path: <linux-kernel-owner+w=401wt.eu-S966975AbZLIAWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966975AbZLIAWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966952AbZLIAWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:22:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56772 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966949AbZLIAWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:22:36 -0500
Message-ID: <4B1EEE42.6090202@gmail.com>
Date: Wed, 09 Dec 2009 01:24:34 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
References: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com> <4B1BBE71.70305@gmail.com> <b6fcc0a0912071030y4ca0deabk1635ec2f3e7ffe26@mail.gmail.com> <4B1D988E.2000305@gmail.com> <20091208015148.GK14381@ZenIV.linux.org.uk>
In-Reply-To: <20091208015148.GK14381@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Dec 08, 2009 at 01:06:38AM +0100, Emese Revfy wrote:
> 
>> DEBUG_RODATA catches the unwanted write attempt at runtime whereas
>> my patch will catch it at compile time. I think it's better to detect
>> an error as early as possible.
> 
> Not when the price is readability.  

If constifying the function pointer fields reduces readability,
what would you say for turning then into typedefs, something like this:

typedef int (* super_ops_statfs) (struct dentry *, struct kstatfs *);
struct super_operations {
...
	const super_ops_statfs statfs;
...
};

> Moreover, you *still* are not
> covering the real policy - these suckers should be statically allocated,
> not just never modified.

If the super ops are allocated on the stack then they will be overwritten
during later syscalls and will eventually crash the system on a future
dereference, that is, this kind of problem manifests during development.

If the super ops are allocated by kmalloc/etc, then they will have to be
explicitly initialised by writing to specific fields, my patch would prevent
that.

So in the end the programmer is forced to allocate and initialise super ops
statically.
---
Emese
