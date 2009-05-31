Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZEaOVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZEaOVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZEaOVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:21:11 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:13058 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbZEaOVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iZxtf9GzpFp2tMngbOI4YFlAVV4lJ/BukH3JA/NgZk7YK9ylz6SDloOW2WS2e6oIYO
         shJk4Io3EU/p+kJUlyBUMCh6Ol22zY2Dkm7oJHujb8DxEkdDz9Kq8PjGb51JIofDPNnI
         fFCnqc5CfMarisFbrvdbnId+9P/YlTOrg9TuQ=
Date: Sun, 31 May 2009 16:21:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/events: fix a typo in __string() format output
Message-ID: <20090531142107.GB6013@nowhere>
References: <4A1F558B.2050705@cn.fujitsu.com> <4A221C7F.70403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A221C7F.70403@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 01:58:23PM +0800, Li Zefan wrote:
> ping..
> 
> Could someone apply this patch? I have a patchset, that
> introduces __dynamic_array(), based on this fix.

I've applied it on
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core

Since we have doubts on the strncmp -> strcmp conversion for static
string arrays. Do you think you could cut your strcmp patch in two parts:

1) fix strncmp use in __string() filters (which drops strncmp for dyn strings)
2) convert static string comparison to use strcmp()

So that I can integrate the fix from 1) and submit it to Ingo with
the fix for __str_loc format I just applied.

And then we can review 2) more carefully.

Thanks,
Frederic.

 
> Or I will include this fix in the patchset.
> 
> Li Zefan wrote:
> > It should be '\t'. Also remove the space before "__str_loc".
> > 
> > Before:
> >  # cat tracing/events/irq/irq_handler_entry/format
> >         ...
> >         field:int irq;  offset:12;      size:4;
> >         field: __str_loc name;  offset:16;tsize:2;
> >         ...
> > 
> > After:
> >  # cat tracing/events/irq/irq_handler_entry/format
> > 	...
> >         field:int irq;  offset:12;      size:4;
> >         field:__str_loc name;   offset:16;      size:2;
> > 	...
> > 
> > [ Impact: fix the output of __string field in format file ]
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  include/trace/ftrace.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > index edb02bc..006af4c 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -187,8 +187,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> >  
> >  #undef __string
> >  #define __string(item, src)						       \
> > -	ret = trace_seq_printf(s, "\tfield: __str_loc " #item ";\t"	       \
> > -			       "offset:%u;tsize:%u;\n",			       \
> > +	ret = trace_seq_printf(s, "\tfield:__str_loc " #item ";\t"	       \
> > +			       "offset:%u;\tsize:%u;\n",		       \
> >  			       (unsigned int)offsetof(typeof(field),	       \
> >  					__str_loc_##item),		       \
> >  			       (unsigned int)sizeof(field.__str_loc_##item));  \
> 

