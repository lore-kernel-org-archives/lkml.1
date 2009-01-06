Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZAFP6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZAFP6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZAFP6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:58:34 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:60788 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbZAFP6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:58:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s3vkWXx+EDIvVE1HcwAHB1pBKME58HLmEt0CBxi+ZJHUEcW4AtWV3nB2SVtxFnmavf
         JohuxucTx7JSWWxlXrsHLSMe2qLOOogRPPGrRl9CIWmqww0ApQUA93oUgttLIBQxFlos
         sCX2GUstQ/sHNByS1719/6/LDwNbQEg/ZuVOg=
Message-ID: <c62985530901060758m4206fd10u99816302a1e251c6@mail.gmail.com>
Date: Tue, 6 Jan 2009 16:58:29 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: unsigned idx cannot be less than 0
Cc: "Roel Kluin" <roel.kluin@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Liming Wang" <liming.wang@windriver.com>
In-Reply-To: <alpine.DEB.1.10.0901061048260.10871@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495E2987.3070501@gmail.com> <20090102154805.GA6833@nowhere>
	 <alpine.DEB.1.10.0901061048260.10871@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/6 Steven Rostedt <rostedt@goodmis.org>:
>
> [ added Liming to CC ]
>
> On Fri, 2 Jan 2009, Frederic Weisbecker wrote:
>
>> On Fri, Jan 02, 2009 at 03:49:43PM +0100, Roel Kluin wrote:
>> > // vi kernel/trace/ftrace.c +787
>> > struct ftrace_iterator {
>> > ...
>> >         unsigned                idx;
>> > ...
>> > };
>> >
>> > idx is unsigned and cannot be less than 0.
>> >
>> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> > ---
>> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> > index 2f32969..a344add 100644
>> > --- a/kernel/trace/ftrace.c
>> > +++ b/kernel/trace/ftrace.c
>> > @@ -842,7 +842,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
>> >     void *p = NULL;
>> >
>> >     if (*pos > 0) {
>> > -           if (iter->idx < 0)
>> > +           if (iter->idx == 0)
>> >                     return p;
>> >             (*pos)--;
>> >             iter->idx--;
>>
>>
>> Hi Roel,
>>
>> I'm not sure this is the right fix.
>> If you look at t_next, if there is no more page to look at,
>> iter_idx takes -1.
>>
>> A 0 value would mean: we are in the first index on the page, which means
>> there is something to read and we don't want to return NULL.
>>
>> I guess that would be better to turn idx into a signed int.
>
> Correct. This bug was added by:
>
>  50cdaf08a8ec1d7f43987705da7aff7cf949708f
>  ftrace: improve seq_operation of ftrace
>
> So the correct fix is to turn it into a signed int.
>
> Thanks,
>
> -- Steve
>

Both iter->idx and pg->index should be signed int I guess.

Roel is perhaps right, I don't know how is caught an unsigned long
when compared with a signed int if
this int is less than 0.
