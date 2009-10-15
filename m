Return-Path: <linux-kernel-owner+w=401wt.eu-S1762614AbZJOJtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762614AbZJOJtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761028AbZJOJtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:49:03 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:48301 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067AbZJOJtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:49:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aSTuiDxHF0VGHUfihaekdO9Xer84j+EVFBrXOvy1t9jwp8Ee65M2jLHKkOrlgj+zKB
         7jAaTG9qr7dsKcXFT6Znk4UgUod/16kOv10hQUXPIH1mZzPbpmINW78zJx9XPHICxX9o
         hcSsKmUMkp1+0lJnjsF5C7MqwUwhXGJpSOWSQ=
MIME-Version: 1.0
In-Reply-To: <4AD69546.8050401@cn.fujitsu.com>
References: <4AD694B8.2020206@cn.fujitsu.com> <4AD69546.8050401@cn.fujitsu.com>
Date: Thu, 15 Oct 2009 17:47:54 +0800
Message-ID: <2375c9f90910150247u5ccb8e2at58c764e385ffa490@mail.gmail.com>
Subject: Re: [PATCH 3/4] tracing/profile: Add filter support
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 11:21 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> - Add an ioctl to allocate a filter for a perf event.
>
> - Free the filter when the associated perf event is to be freed.
>
> - Do the filtering in perf_swevent_match().
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

{snip}

> +int ftrace_profile_set_filter(struct perf_event *event, int event_id,
> +                             char *filter_str)
> +{
> +       int err;
> +       struct event_filter *filter;
> +       struct filter_parse_state *ps;
> +       struct ftrace_event_call *call = NULL;
> +
> +       mutex_lock(&event_mutex);
> +
> +       list_for_each_entry(call, &ftrace_events, list) {
> +               if (call->id == event_id)
> +                       break;
> +       }
> +       if (!call)
> +               return -EINVAL;
> +
> +       if (event->filter)
> +               return -EEXIST;
> +
> +       filter = __alloc_preds();
> +       if (IS_ERR(filter))
> +               return PTR_ERR(filter);


Just return will leave &event_mutex locked...

Am I missing something here?

> +
> +       err = -ENOMEM;
> +       ps = kzalloc(sizeof(*ps), GFP_KERNEL);
> +       if (!ps)
> +               goto free_preds;
> +
> +       parse_init(ps, filter_ops, filter_str);
> +       err = filter_parse(ps);
> +       if (err)
> +               goto free_ps;
> +
> +       err = replace_preds(call, filter, ps, filter_str, false);
> +       if (!err)
> +               event->filter = filter;
> +
> +free_ps:
> +       filter_opstack_clear(ps);
> +       postfix_clear(ps);
> +       kfree(ps);
> +
> +free_preds:
> +       if (err)
> +               __free_preds(filter);
> +
> +       mutex_unlock(&event_mutex);
> +
> +       return err;
> +}
> +
