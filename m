Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYH2QhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYH2QhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYH2QhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:37:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:57850 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbYH2QhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wrZ2uEfgaCGZcUYCG6AJ7DHqVzLHSIY++oZeU8S9AV2FBaWtCbGj6KYXKG0xEZgjTW
         4YEVmRy4gu/GVkxnphgkm8Rbia4VQuBncUJJcymJESH1c1Ly41V/Qegs0emfBzmrTPBo
         ZATgsTEhELgIwdn9e/X2zXLAldRmqzsuzS9WY=
Message-ID: <86802c440808290937y468a4368y9b6ed57ca0cb9896@mail.gmail.com>
Date: Fri, 29 Aug 2008 09:37:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 - fix
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0808290854000.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219997592-9975-1-git-send-email-yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0808290854000.3300@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 9:05 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 29 Aug 2008, Yinghai Lu wrote:
>>
>> try to insert_resource second time, by expand the resource...
>
> I would hold off on this unless it's shown to actually be needed. And _if_
> it is needed, I would just make a new function for doing this all:
> "insert_resource_expand_to_fit()"
>
> That said, I think the insert_resource()/__insert_resource() change is
> pretty ok. However, it doesn't follow the rules, and is racy. The rules
> for resources are:
>
>  - the "internal" version (with the "__" prepended) is static to
>   resource.c, because it must not be called from outside, which is in
>   turn because:
>
>  - it must be called with the lock taken by the caller, because otherwise
>   returning a "struct resource *" is racy - the resource is not protected
>   by anything!
>
> So the "insert_resource_expand_to_fit()" thing would look something like
> this:
>
>        void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
>        {
>                write_lock(&resource_lock);
>                while (new->start && new->parent) {
>                        struct resource *conflict;
>
>                        conflict = __insert_resource(root, new);
>                        if (!conflict)
>                                break;
>                        if (conflict->start < new->start)
>                                new->start = conflict->start;
>                        if (conflict->end > new->end)
>                                new->end = conflict->end;
>                }
>                write_unlock(&resource_lock);
>        }
>
> but the above is obviously _totally_ untested.
>

good, will build one test stub to test it.

YH
