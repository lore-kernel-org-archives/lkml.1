Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbZDAMwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbZDAMwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZDAMwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:52:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51876 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZDAMwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:52:24 -0400
Date: Wed, 1 Apr 2009 09:52:05 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] blktrace: fix output of BLK_TC_PC events
Message-ID: <20090401125205.GD25493@ghostprotocols.net>
References: <49D3236D.3090705@cn.fujitsu.com> <49D32387.9040106@cn.fujitsu.com> <20090401110016.GA15442@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401110016.GA15442@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 01, 2009 at 01:00:16PM +0200, Ingo Molnar escreveu:
> 
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > +	} else {
> > +		if (t_sec(ent))
> > +			return trace_seq_printf(s, "%llu + %u [%d]\n",
> > +						t_sector(ent),
> > +						t_sec(ent), t_error(ent));
> > +		return trace_seq_printf(s, "%llu [%d]\n",
> > +					t_sector(ent), t_error(ent));
> > +	}
> >  }
> >  
> >  static int blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
> 
> Neat shortcut - packet command requests can be quite large in 
> special cases, right?
> 
> Sidenote. Right now we reserve the full packet length in the trace 
> buffer, then copy the full packet into the trace buffer:
> 
>                 if (pdu_len)
>                         memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
> 
> ... just to scan it a second time during output and discard much of 
> it later on if it has a lot of trailing zeroes.
> 
> It might make sense to pre-compress: by extending the trace record 
> format with a trailing-zeroes field.

You mean something like asking, at tracer registration time to do this
kind of compression and have it done on the core tracing code? Looks
worthy if we can find a second tracer that would benefit from the space
savings at the cost of using more CPU at each event.

But perhaps providing a "memcpy" replacement to be used in such things
and leaving this to the user to decide, i.e. it may be interesting in
certain scenarios to be able to do:

echo 1 > /sys/kernel/debug/tracing/options/compress

And have the payload compressed.
 
> But that would make it more complex and key to tracers is simplicity 
> of data acquisition.
> 
> Dunno, probably not worth it, except if data stream bloat becomes a 
> real issue (which i'd not expect them to become in this case).
> 
> Anyway - Jens, the two patches look good to me, do they look fine to 
> you too?

To me too,

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

to this one too.

- Arnaldo
