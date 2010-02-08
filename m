Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab0BHRVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 12:21:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:26101 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab0BHRVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:21:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=yT/NyagoBqvJ0SZACg0SuYBpxHQagT29AKTiQL/E9l4dba8y8P9QWXyIcfqOTi9QO
	nNK5Zxb1mb6wPJPw5xN+g==
MIME-Version: 1.0
In-Reply-To: <1265646612.11509.13.camel@laptop>
References: <4b703875.0a04d00a.7896.ffffb824@mx.google.com>
	 <1265646612.11509.13.camel@laptop>
Date: Mon, 8 Feb 2010 18:21:46 +0100
Message-ID: <bd4cb8901002080921p311e29fbmcdf0841b0af558a@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf_events: added new start/stop PMU callbacks
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 8, 2010 at 5:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-02-08 at 17:06 +0200, Stephane Eranian wrote:
>>       In certain situations, the kernel may need to stop and start the
>>       same event rapidly. The current PMU callbacks do not distinguish
>>       between stop and release  (i.e., stop + free the resource). Thus,
>>       a counter may be released, then it will be immediately re-acquired.
>>       Event scheduling will again take place with no guarantee to assign
>>       the same counter. On some processors, this may event yield to failure
>>       to assign the event back due to competion between cores.
>>
>>       This patch is adding a new pair of callback to stop and restart a
>>       counter without actually release the underlying counter resource.
>>       On stop, the counter is stopped, its values saved and that's it.
>>       On start, the value is reloaded and counter is restarted (on x86,
>>       actual restart is delayed until perf_enable()).
>>
>>       Note this patch does not provide support for non-X86 PMU. This needs
>>       to be added.
>>
>>       Signed-off-by: Stephane Eranian <eranian@google.com>
>> --
>
> I think we can do this much easier by adding a list_head to
> hw_perf_event and make event_list into a proper list, then we can remove
> that funny loop on remove and instead move the event to a remove_list
> when there's a put_event_constraint() method and iterate that list on
> hw_perf_enable().

Not sure why it's easier. It saves memory for sure, but that problem
is independent of the issue I was trying to address.

>
> But before we do that, I think we need to look at the /* hardware */
> part of struct hw_perf_event, and make that arch specific, we've been
> growing that a lot lately and I don't think !x86 uses any of that.
>
It is clear it will need to grow much more to host non-counting features.
I have played with that myself a few weeks back. So, yes the saved state
needs to be arch specific.
