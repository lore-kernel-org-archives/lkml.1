Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZDMDpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZDMDpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZDMDpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:45:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42519 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbZDMDpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:45:39 -0400
Date: Mon, 13 Apr 2009 05:45:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] tracing/filters: allow user to specify a filter val
	to be string
Message-ID: <20090413034531.GC11652@elte.hu>
References: <49E04C22.4040608@cn.fujitsu.com> <49E04C61.10209@cn.fujitsu.com> <20090411143533.GA5977@nowhere> <49E2974D.6080105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E2974D.6080105@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> > Well, IMHO, it would be rather better to just echo 'parent_comm == 123'
> > and let it answer depending of which filter_pred_*() callback we have
> > for the concerned field.
> > 
> > The culprit is this part in filter_parse():
> > 
> > pred->val = simple_strtoull(val_str, &tmp, 10);
> > if (tmp == val_str) {
> > 	pred->str_val = kstrdup(val_str, GFP_KERNEL);
> > 	if (!pred->str_val)
> > 		return -ENOMEM;
> > }
> > 
> > The idea would be to not anymore base the check on simple_strtoull to
> > guess whether this is a number or a string, making it act subsequently
> > to this assumption, which is not the good assumption we must base our
> > parsing yet.
> > 
> > Instead, we could let filter_parse only do the job of extracting the tokens
> > and then fill the whole pred struct without yet bothering about the type
> > of the value.
> > 
> > Thereafter we may defer the real value type checking on filter_add_pred()
> > depending on the type of the concerned field:
> > 
> > if (is_string_field()) {
> > 	add it as a string value;
> > } else {
> > 	do the check with simple_strtoull
> > 	looks good? Then go to the number size switch....
> > 	...
> > }
> > 
> > You see?
> > 
> 
> Right! Actually I thought about this, then I found one issue, 
> suppose event foo and event bar both have a field named fb but one 
> is string and one is integer. Now do this:
>
>   # echo 'fb == 123' > events/foo-bar/filter
> 
> This will set both filters, but not only the integer one.
> 
> But now I think this hardly happen in real-life, and it's not a 
> big issue if it does happen. So I agree with you on this issue.

Yeah, good point. I think we should avoid such field name aliasing. 
Even without the filter assignment ambiguity problem it would be 
confusing to users to have two same-name but different-type fields 
in two separate events.

	Ingo
