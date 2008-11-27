Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYK0MyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYK0MyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYK0Mx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:53:59 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:62506 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYK0Mx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:53:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O6luk3XGcWz/Jm6gkcAxj9tLPAGkbU0OL0QI6eyP4aVABvml2a3crOqcR2Y3ep8o+7
         r32HWYcWqZjoMarI5CqnkSKug3wlvFGzHLefBvc7ezLsWyv5rvN+PljGSLCtHtaH2c0b
         SrWJxZOpiYaQ+88PyklUNsm9f5j8h/VzhvzUQ=
Message-ID: <c62985530811270453y78506661i859f5f0f56e9ef5@mail.gmail.com>
Date: Thu, 27 Nov 2008 13:53:57 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the trace output
Cc: "Ingo Molnar" <mingo@elte.hu>, "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811262001270.1501@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492DEDE9.9010109@gmail.com>
	 <c62985530811261657t6ba9c8cbwc21fa9d09627e110@mail.gmail.com>
	 <alpine.DEB.1.10.0811262001270.1501@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/27 Steven Rostedt <rostedt@goodmis.org>:
>
>>
>>
>> One detail. If you get a trace through the "trace" file, you will have
>> no problem.
>> But if you cat trace_pipe, leaf functions are considered as nested.
>>
>> This is because iter->buffer_iter[iter->cpu]; is very often (always?)
>> false by using this file.
>> I don't know why yet....
>> But it makes the tracer unable to check the next entry to verify if it
>> matches its own return.
>
> That's because trace_pipe does not use an iterator ;-)  It is live stream.
>
> There's two cases: static read and consume.  On static read we can take
> our time and we iterate over the data in the file. The data does not get
> consumed so we use an iterator to traverse the data.
>
> The consume read will consume each entry as it reads it. We do not need an
> iterator for this because we are always reading the head of the file.
> After we read the data, that data is consumed and we read the next item.
>
> Hmm, I may need to make this apparent to the plugins like yours. This way
> you can do different things whether it is a static read or a consuming
> read.
>
> Perhaps the info now is what you already found out.
> "iter->buffer_iter[iter->cpu] will always be NULL when it is a consuming
> read. Intead you need to use:
>
> ring_buffer_peek instead of ring_buffer_iter_peek
>
> and
>
> ring_buffer_consume instead of ring_buffer_read
>
> This is the way you can use it:
>
> entry = ring_buffer_peek(iter->tr->buffer, iter->cpu, NULL);
> entry = ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);


Ok. Thanks, I will correct it by covering the two cases, like in
trace.c : peek_next_entry()
