Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbZLJSWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbZLJSWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761293AbZLJSWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:22:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43233 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761211AbZLJSWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:22:19 -0500
Message-ID: <4B213CD5.1070403@gmail.com>
Date: Thu, 10 Dec 2009 19:24:21 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
References: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com> <4B1BBE71.70305@gmail.com> <b6fcc0a0912071030y4ca0deabk1635ec2f3e7ffe26@mail.gmail.com> <4B1D988E.2000305@gmail.com> <20091208015148.GK14381@ZenIV.linux.org.uk> <4B1EEE42.6090202@gmail.com> <20091209004734.GO14381@ZenIV.linux.org.uk>
In-Reply-To: <20091209004734.GO14381@ZenIV.linux.org.uk>
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
> On Wed, Dec 09, 2009 at 01:24:34AM +0100, Emese Revfy wrote:
> 
>> If constifying the function pointer fields reduces readability,
>> what would you say for turning then into typedefs, something like this:
>>
>> typedef int (* super_ops_statfs) (struct dentry *, struct kstatfs *);
>> struct super_operations {
>> ...
>> 	const super_ops_statfs statfs;
>> ...
>> };
> 
> Even worse, since one has to go back to typedef to figure out WTF is
> going on.
>  
>>> Moreover, you *still* are not
>>> covering the real policy - these suckers should be statically allocated,
>>> not just never modified.
>> If the super ops are allocated on the stack then they will be overwritten
>> during later syscalls and will eventually crash the system on a future
>> dereference, that is, this kind of problem manifests during development.
>>
>> If the super ops are allocated by kmalloc/etc, then they will have to be
>> explicitly initialised by writing to specific fields, my patch would prevent
>> that.
>>
>> So in the end the programmer is forced to allocate and initialise super ops
>> statically.
> 
> ... unless they go ahead and use memcpy(), etc.
> 
> What you really want is
> 	* no conversions to any other pointer types for pointers to it
> and to any aggregate types containing it
> 	* no conversions from any other pointer types for the same set of
> types
> 	* all objects of that type have static storage duration
> 	* no lvalues of that type are modifiable
> 
> Which is not a job for C compiler.  Yes, (4) means that memcpy() et.al.
> give undefined behaviour.  And you get fsck-all satisfaction from knowing
> that, since C compiler is not going to warn you about it.  sparse might,
> if we teach it to do so.  Preferably - with minimal intrusiveness of
> syntax being used.

I think, all these instruments (constification, sparse, etc.) are not 
for preventing a programmer from circumventing the policy (that's impossible),
but to make it easy for the reviewer to notice it when he does so.
My patch achieves this in a very simple way for the currently uncovered case of dynamically
allocated ops structures.
--
Emese
