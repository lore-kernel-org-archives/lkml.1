Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZDMBgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZDMBgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 21:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZDMBgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 21:36:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52282 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZDMBge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 21:36:34 -0400
Message-ID: <49E2974D.6080105@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 09:37:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] tracing/filters: allow user to specify a filter	val
 to be string
References: <49E04C22.4040608@cn.fujitsu.com> <49E04C61.10209@cn.fujitsu.com> <20090411143533.GA5977@nowhere>
In-Reply-To: <20090411143533.GA5977@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, IMHO, it would be rather better to just echo 'parent_comm == 123'
> and let it answer depending of which filter_pred_*() callback we have
> for the concerned field.
> 
> The culprit is this part in filter_parse():
> 
> pred->val = simple_strtoull(val_str, &tmp, 10);
> if (tmp == val_str) {
> 	pred->str_val = kstrdup(val_str, GFP_KERNEL);
> 	if (!pred->str_val)
> 		return -ENOMEM;
> }
> 
> The idea would be to not anymore base the check on simple_strtoull to
> guess whether this is a number or a string, making it act subsequently
> to this assumption, which is not the good assumption we must base our
> parsing yet.
> 
> Instead, we could let filter_parse only do the job of extracting the tokens
> and then fill the whole pred struct without yet bothering about the type
> of the value.
> 
> Thereafter we may defer the real value type checking on filter_add_pred()
> depending on the type of the concerned field:
> 
> if (is_string_field()) {
> 	add it as a string value;
> } else {
> 	do the check with simple_strtoull
> 	looks good? Then go to the number size switch....
> 	...
> }
> 
> You see?
> 

Right! Actually I thought about this, then I found one issue, suppose event
foo and event bar both have a field named fb but one is string and one is
integer. Now do this:
  # echo 'fb == 123' > events/foo-bar/filter

This will set both filters, but not only the integer one.

But now I think this hardly happen in real-life, and it's not a big issue
if it does happen. So I agree with you on this issue.

Thanks.

> I think it would be a saner basis of parsing.
> 
