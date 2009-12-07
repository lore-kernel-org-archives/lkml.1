Return-Path: <linux-kernel-owner+w=401wt.eu-S934969AbZLGQJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969AbZLGQJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934347AbZLGQJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:09:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933577AbZLGQJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:09:30 -0500
Subject: Re: [PATCH 1/2] Does raw_field_ptr() supports __data_loc?
From: Steven Rostedt <srostedt@redhat.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <1260156884-8474-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <20091115022135.GA5427@nowhere>
	 <1260156884-8474-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 07 Dec 2009 11:09:18 -0500
Message-Id: <1260202158.31359.170.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 12:34 +0900, Hitoshi Mitake wrote:
> VERY very sorry for my long silence...
> 
> Please don't commit this patch, Ingo.
> This patch is required to test the next patch for perf lock.
> 
> I have a question for Steven Rostedt and Tom Zanussi.
> Does current raw_field_ptr() support __data_loc?
> 
> At 064739bc4b3d7f424b2f25547e6611bcf0132415 ,
> support for the modifier "__data_loc" of format is added.
> 
> But, when I wanted to parse format of lock_acquired (or some event else),
> raw_field_ptr() did not returned correct pointer.
> 
> So I modified raw_field_ptr() like this patch. Then raw_field_ptr() works well.
> Parser was large so I'd like to ask you about this.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Steven Rostedt <srostedt@redhat.com>
> 
> I have a question
> ---
>  tools/perf/util/trace-event-parse.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index 0302405..494a470 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -1925,6 +1925,13 @@ void *raw_field_ptr(struct event *event, const char *name, void *data)
>  	if (!field)
>  		return NULL;
>  
> +	if (field->flags & FIELD_IS_STRING) {
> +		int offset;
> +		offset = *(int *)(data + field->offset);
> +		offset &= 0xffff;
> +		return data + offset;
> +	}
> +

Hmm, I guess I need to update the code in perf again. The way I did this
was to have FIELD_IS_STRING evaluated in the eval_num_arg.


-- Steve

>  	return data + field->offset;
>  }
>  

