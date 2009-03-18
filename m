Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZCRVOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZCRVOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZCRVOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:14:18 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:40397 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756799AbZCRVOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:14:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fBwXWVCquH7xJcCYYD+NV4yA2byViU7RjKkp1aNnTvjG+RynQC6DW++RYApQ1bgDQwmRyv/CB2QdgP4ou2UfMoUTj3KouRrxuK6Ch/Ic8Nd6P1FH6Iz9jFN/CMekL9D95cJtR0bnlWMMCxtd19iwvgTDivOgkHIoOjcxaad8IrU=  ;
X-YMail-OSG: .P5CTywVM1k32g_io.64uSHHDnh7rmpBeqSlmeLjbXEwd4Mr8jVs7SB3dSQ.npnIS6l574D6G2Q6cQk0MM4gKkP_ReWrmKyFBP_OYpNwQOO4sEDFV0Rpha8EpvVK.yBZFbIV91NnZIFm0r27tgQY1UH6HUyFsNP1vqe.KdAHP3RhSWYOsIQPpsKx3Ny2
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc8 regulator-next] regulator: init fixes (v4)
Date: Wed, 18 Mar 2009 14:14:14 -0700
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200903111743.34708.david-b@pacbell.net> <200903181225.11444.david-b@pacbell.net> <20090318203317.GA6299@sirena.org.uk>
In-Reply-To: <20090318203317.GA6299@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903181414.14563.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, Mark Brown wrote:

> > That self-inconsistency doesn't seem to concern you much.
>
> I think it's more that I'm viewing the use count as being useful
> information which the API can take advantage of ("do any consumers
> actually want this on right now?").

In that case, I don't understand why you didn't like
the previous versions of this patch ... which just
forced the regulator off (at init time) if that count
was zero.


> I think we should be able to handle 
> this without changing the use count and that this is preferable because
> otherwise we make more work with shared consumers, which should be the
> simplest case.

That's what the earlier versions of this patch did,
but you rejected that approach ... patches against
both mainline (which is where the bug hurts TODAY),
and against regulator-next.

Also, I don't see why you'd think a shared consumer
would be the "simplest", given all the special rules
that you've already noted as only needing to kick in
for those cases.


> The trick is getting the non-shared regulators into sync with the
> internal status,

I don't see why that should need any tricks.  At
init time you have that state and the regulator;
and you know there are no consumers.  Put it into
a self-consistent state at that time ... done.

There are really only two ways to make that state
self-consistent.  And you have rejected both.


> ideally without doing things like bouncing supplies 
> during init.  I think either using regulator_force_disable() or saying

The force_disable() thing looks to me like an API design
botch.  As you said at one point, it has no users.  And
since the entire point is to bypass the entire usecount
scheme ... it'd be much better to remove it.


> that the consmer wants exclusive access on get and then bumping the use
> count for it if the regulator is already enabled ought to cover it.
> I've not thought the latter option through fully, though.

The problem I have with your approach here is that you
have rejected quite a few alternative bugfixes applying
to a common (and simple!!) configuration, but you haven't
provided an alternative that can work for MMC init.

I'm really at a loss to see a way out here.

