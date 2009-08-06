Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZHFB7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZHFB7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZHFB7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:59:54 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:51675 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZHFB7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AkNBxMOwBDVnVhgYk8WuskEqPI4g+AYBVaF3fMy86YFHS8LaB2TTCsHBO/gGyPz82G
         a3zMKl3kz4Z3JSnenxTvanCEMckt1ryFoVffzhKNUusSbV16gvLC8F9Kxb9wGPRkEM61
         ZjqP6ep8jMOXG186Evq9YEW+Jl8IwoXemk4QU=
Date: Thu, 6 Aug 2009 03:59:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 5/5] tracing/filters: Provide support for char *
	pointers
Message-ID: <20090806015949.GB24609@nowhere>
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com> <1249111408-8657-6-git-send-email-fweisbec@gmail.com> <4A768A87.6090800@cn.fujitsu.com> <20090805230257.GI5025@nowhere> <4A7A336B.4040708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7A336B.4040708@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 09:35:39AM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > On Mon, Aug 03, 2009 at 02:58:15PM +0800, Li Zefan wrote:
> >> Frederic Weisbecker wrote:
> >>> Provide support for char * pointers in the filtering framework.
> >>> Usually, char * entries are dangerous in traces because the string
> >>> can be released whereas a pointer to it can still wait to be read from
> >>> the ring buffer. But sometimes we can assume it's safe, like in case
> >>> of RO data (eg: __file__ or __line__, used in bkl trace event). If
> >>> these RO data are in a module and so is the call to the trace event,
> >>> then it's safe, because the ring buffer will be flushed once this
> >>> module get unloaded.
> >>>
> >> The problem is we don't distinguish dangerous char * from
> >> safe char *... They are both defined as:
> >> 	__field(char *, str)
> >>
> >> So for those dangerous ones, a string filter still can be applied,
> >> which will dereference those pointers.
> > 
> > Yeah, but only reviewing can distinguish them. It depends on the
> > context.
> > IMO, a __builtin_constant check would be wrong. I don't remember who
> > posted recently tracepoints with char * types that were safe although he
> > didn't use string constants.
> > 
> 
> IMO it's really bad to rely on review to prevent wrong use of
> an API..
> 
> Other developers won't know this restriction, and not all tracepoint
> patches go through -tip tree, and not all trace_event source files
> are in include/trace/events/.
> 
> How about add __field_type()? So we can define:
> 
> 	__field_type(char *, str, FILTER_PTR_STR)
> 
> the advantage is he who wrote the code really knows this field is safe
> to be used in filtering as a string.
> 
> I had some patches that does similar job. I can rewrite and post them.


Ah good idea. That may even be useful for further typedef'ed types which
filter process match existing supported types.

Just one neat however: __field_type looks too much ambiguous. __field() is
already here to define a typed field. This seems confusing.

Why not __field_ext() for "extended"? We may probably add more flags
than FILTER_PTR_STR in the future to define options for filtering or even
for larger scope.

I then wait for your patches to be posted and I'll integrate them in the
current queue.

Thanks a lot!

