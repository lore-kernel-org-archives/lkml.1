Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZBFWu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZBFWu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbZBFWur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:50:47 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:60356 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZBFWur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:50:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z0sZW2S7gB13rLoSuOhMr0u2/e0fy3HJdwVpkVgOp+IMjDCKHUwy+fYzft47YsTzcg
         y/+nkFXFIiCgajTTJ0dh6wwPAhj4Avpslx3Ohc51mD5jK7cUPTwbwCekKHHTfHLp/aFw
         CTcV7vA7X867bzKZCOCC52VrBuxFlzLry80XU=
MIME-Version: 1.0
In-Reply-To: <20090203215552.38193470@infradead.org>
References: <4e5e476b0901310542n796dafbem5c656da07a2f8a56@mail.gmail.com>
	 <20090202205545.4e1a32ea.akpm@linux-foundation.org>
	 <20090203161648.361a924a@infradead.org>
	 <20090203214609.39c9c6b2.akpm@linux-foundation.org>
	 <20090203215552.38193470@infradead.org>
Date: Fri, 6 Feb 2009 23:50:44 +0100
Message-ID: <4e5e476b0902061450h49a44317sc5a46acfe2af1f37@mail.gmail.com>
Subject: Re: Negative values in /proc/latency_stats
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 6:55 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 3 Feb 2009 21:46:09 -0800
>
>> > + * Negative latencies (caused by time going backwards) are also
>> > explicitly
>> > + * skipped.
>>
>> Are we sure that this was the cause of the problem?
>
> not 100%, but if you add only positive numbers..... the only other
> option is an overflow.. but that would be such a huge latency that that
> is not very believable.
>

I can confirm that those huge latencies were not real. I was using the
machine, and it was responsive when this was measured.
Maybe I can suggest an other option.. To measure a latency, you have
to set up a variable when you enter a wait state, and compute the
difference when you exit the waiting. If you forget to initialize the
variable in one of the paths leading to the waiting, when you do the
difference, you can end up with negative (or more generally,
meaningless) numbers.
Anyway, skipping these numbers is surely better than propagating them
to userspace, if the cause cannot be found.

An other random thought: since tracing can have noticeable overheads,
as Ingo noticed, and is likely that distros will ship with various
tracers enabled in the kernel, I think the scheme used to control them
should be more robust.
Currently, you can enable/disable them by writing 1/0 in a pseudo-file
under /proc, but what happens if the userspace program fails to write
the 0 in the file after it finished tracing (it can even not have
chance to do if it is killed -9)? I propose that tracers like this
one, i.e. that record instantaneous data, should remain enabled only
while the userspace process keeps the fd opened. When it's closed (or
after a grace period), the tracer should be automatically disabled.

Corrado
