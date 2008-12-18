Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753339AbYLRKwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbYLRKwD (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYLRKvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:51:52 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:59644 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYLRKvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:51:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kwiPST5YdYCD9GWoN4vQthZ3AwWfQ6QsKGkOF/PsSSt0n+D0k73xO4drl4+qbpGuLv
         fUtOCX+9XHuc90av26pGO2J+OUXZwDdjBLXpB1ghEKHQ9tHQkqSRZDHibwjwrWKb4Fgq
         N2/bsI7IQ3U3Nausz3WxWUs0AtyQACYbk1b1Y=
Message-ID: <c62985530812180251k7fde4f13tce5118a3eac4975b@mail.gmail.com>
Date: Thu, 18 Dec 2008 11:51:50 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer interrupt infinite loop
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081218103459.GD10513@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/18 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Impact: fix a system hang on slow systems
>>
>> While testing the function graph tracer on VirtualBox, I had a system hang
>> immediatly after enabling the tracer.
>>
>> If hrtimer is enabled on kernel, a slow system can spend too much time
>> during tracing the hrtimer_interrupt which will do eternal loops,
>> assuming it always have to retry its process because too much time
>> elapsed during its time update. Now we provide a feature which lurks at
>> the number of retries on hrtimer_interrupt. After 10 retries, the
>> function graph tracer will definetly stop its tracing.
>
> hm, i dont really like this solution - it just works around the problem by
> 'speeding up' the system. If we have a _real_ slow system, there's no such
> way for us to speed it up.


It doesn' speed up the system actually. That's not the goal of this patch.
This patch disables completely the tracing on infinite loop in hrtimer, and
tracing will not be reenabled after it. That's too dangerous.

I'm not really proud of this patch, because it is a tricky hack... But
this is the most lightweight solution I've found....

> Thomas, what do you think - would you expect this lockup to happen on
> really slow systems? If yes, is there a way we could avoid it from
> happening - by driving some sort of 'mandatory interval', that is doubled
> in size every time we detect such a bad hrtimer loop?
>
>        Ingo
>
