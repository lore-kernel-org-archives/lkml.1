Return-Path: <linux-kernel-owner+w=401wt.eu-S1751019AbZHHQEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbZHHQEL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 12:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbZHHQEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 12:04:10 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:63075 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZHHQEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 12:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UP8jeRpK+KpemPX4Mji6fopSU1re6ONqF5JxRWpMtvyCzk6Fm/lK9v2IYfp0hGAmFz
         i61fv3CIi7Vopj8xXOF0PM1NdxDflMI62OdMUgWISWuXpD+O7eJMGkv6Nc5L2ORY3AfE
         n0t+HoUPa5cvylGpm29sCUbFKs0dJ1wWbcz6E=
Subject: Re: [2.6.31 PATCH] tracing/filters: always free pred on
 filter_add_subsystem_pred() failure
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090808160211.GM28892@elte.hu>
References: <1249746593.6453.32.camel@tropicana>
	 <20090808160211.GM28892@elte.hu>
Content-Type: text/plain
Date: Sat, 08 Aug 2009 11:04:07 -0500
Message-Id: <1249747447.6453.34.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-08 at 18:02 +0200, Ingo Molnar wrote:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > If filter_add_subsystem_pred() fails due to ENOSPC or ENOMEM, the 
> > pred doesn't get freed, while as a side effect it does for other 
> > errors. Make it so the caller always frees the pred for any error.
> 
> thanks, i've queued this up for .31.
> 
> Just to make sure: tracing/core has the filter code changed 
> substantially, and this issue seems to be moot there - correct?
> 

Right, the subsystem preds are gone in tip, so nothing to fix there.

> So the total impact from both patches on -tip is the patch below - 
> right?
> 

Right.

Tom

> 	Ingo
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 27c2dbe..490337a 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -1050,6 +1050,8 @@ static int replace_preds(struct event_subsystem *system,
>  
>  		pred = create_pred(elt->op, operand1, operand2);
>  add_pred:
> +		if (!pred)
> +			return -ENOMEM;
>  		if (call)
>  			err = filter_add_pred(ps, call, pred, false);
>  		else

