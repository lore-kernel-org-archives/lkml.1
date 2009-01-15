Return-Path: <linux-kernel-owner+w=401wt.eu-S1764070AbZAOKcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764070AbZAOKcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760660AbZAOKcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:32:21 -0500
Received: from mail-bw0-f20.google.com ([209.85.218.20]:38252 "EHLO
	mail-bw0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761638AbZAOKcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:32:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BWjJEo/N6k2FDYDg+LDQZQ3P72ib8s86wkOAVPrLnJwLl0ebi3tYBkw7pjWk0I4Z8m
         MqI2yHbHWSwfleQ4Ms4KbkSvZRjeBZ23lk3usNsBOSRE+O46dJ27xTm2JcTGgJ3TnvAs
         RYGeziFUg3VTM1YydpC8mOGiDf832ZM4NV5W4=
Message-ID: <c62985530901150232j5623ace0uc458dd3686ed105e@mail.gmail.com>
Date: Thu, 15 Jan 2009 11:32:17 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] tracing/ftrace: add missing unlock in register_stat_tracer()
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <496E91CC.4020209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496E91CC.4020209@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/15 Li Zefan <lizf@cn.fujitsu.com>:
> We should unlock all_stat_sessions_mutex before returning failure.


Ouch.... Thanks Li!


> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>
> I noticed Ingo tend to delete the impact line from my changelog
> if it added nothing new to the title, so no impact line for this
> patch. :)
>
> ---
>  kernel/trace/trace_stat.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
> index cb29282..8669f3c 100644
> --- a/kernel/trace/trace_stat.c
> +++ b/kernel/trace/trace_stat.c
> @@ -73,8 +73,10 @@ int register_stat_tracer(struct tracer_stat *trace)
>        /* Already registered? */
>        mutex_lock(&all_stat_sessions_mutex);
>        list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
> -               if (node->ts == trace)
> +               if (node->ts == trace) {
> +                       mutex_unlock(all_stat_sessions_mutex);
>                        return -EINVAL;
> +               }
>        }
>        mutex_unlock(&all_stat_sessions_mutex);
>
> --
> 1.5.4.rc3
>
