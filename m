Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbYKRHtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbYKRHtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYKRHtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:49:31 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:56579 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYKRHt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:49:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RqkwQaKvA38iP0xZuM036Wu7hJoG4uJBdtqJGLrHCBv/U4Wc0L43mwdP/6CvTXrXmt
         D+RDG0vTgxT6U+wczZMVPzRd2VI+zB8CVwlDMm7EB3srPPa8WVS7VTrSBsrxOvAbo1Q0
         GLCzhOl2ueHK2885p+cN+LKnNzEEcDkE0yndQ=
Date: Tue, 18 Nov 2008 07:49:22 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Ferenc Wagner <wferi@niif.hu>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softirq: Use local_irq_save() in local_bh_enable()
Message-ID: <20081118074922.GB4440@ff.dom.local>
References: <20081117133548.GC6345@ff.dom.local> <1226931509.3902.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226931509.3902.16.camel@johannes.berg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 03:18:28PM +0100, Johannes Berg wrote:
> On Mon, 2008-11-17 at 13:35 +0000, Jarek Poplawski wrote:
> > This report: http://marc.info/?l=linux-netdev&m=122599341430090&w=2
> > shows local_bh_enable() is used in the wrong context (irqs disabled).
> > It happens when a usual network receive path is called by netconsole,
> > which simply turns off irqs around this all. Probably this is wrong,
> > but it worked like this long time, and it's not trivial to fix this.
> 
> Unfortunately my brain lacks the magic to decrypt x86 stack traces, so
> I'm unable to read much from that report other than that it hit the
> WARN_ON. That looks more like the TX path to me?

OK, this looks like both paths (which is probably common in networking).

> Anyway, my patch made
> that trigger for everybody rather than just on NOPREEMPT/UP (or
> something like that) and made the code easier to understand by removing
> the flags that are pointless anyway if the API is used correctly.
> 
> You can find discussion around the patch at
> http://lkml.org/lkml/2008/6/17/259

Yes, it's very interesting.

> 
> > Anyway, a commit 0f476b6d91a1395bda6464e653ce66ea9bea7167 "softirq:
> > remove irqs_disabled warning from local_bh_enable" can break things
> > after changing from local_irq_save() to local_irq_disable(). Before
> > this commit there was only a warning, now a lockup is possible, so
> > it could be treated as a regression. This patch reverts the change
> > in irqs.
> 
> Do we have evidence of this actually hitting often? This is the first
> report of anything going wrong that I've seen ever since a single one
> right after this commit went into testing five months ago.
> 
> IFF we want to add this back (and I'm not in favour) then please add a
> big comment that this is only to accomodate broken users.

Yes, it seems there should be more such reports from netconsole users.
But, I guess we kind of expect this if we still use WARN_ON and not
BUG_ON here?

Jarek P.
