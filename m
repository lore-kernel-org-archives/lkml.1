Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZCVPJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZCVPJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 11:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZCVPJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 11:09:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36575 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbZCVPJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 11:09:39 -0400
Date: Sun, 22 Mar 2009 12:09:20 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] blktrace: remove blk_probe_mutex
Message-ID: <20090322150920.GC5677@ghostprotocols.net>
References: <49C2F599.3060306@cn.fujitsu.com> <49C2F5EA.8060606@cn.fujitsu.com> <20090320130309.GJ30407@ghostprotocols.net> <49C5D4DE.30002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C5D4DE.30002@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 22, 2009 at 02:04:14PM +0800, Li Zefan escreveu:
> Arnaldo Carvalho de Melo wrote:
> > Em Fri, Mar 20, 2009 at 09:48:26AM +0800, Li Zefan escreveu:
> >> blk_register_tracepoints() always returns 0, so make it return void, thus
> >> we don't need to use blk_probe_mutex to protect blk_probes_ref.
> >>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > 
> > Historic reasons, when I first worked on this I found all those WARN_ONs
> > in blk_register_tracepoints a bogosity that should be later fixed, but
> > to reduce the patch size I never got around to submit the proper patch,
> > so I don't think that the fix is what you suggests, here it is what I
> > had before I removed the non-essential parts of the patch:
> > 
> 
> I though register_trace_xxx() will fail only when there is a name collision,
> in this case WARN_ON() and return 0 should be reasonable. But I just dig into
> the code and found it may allocate memory and thus might return ENOMEM, so
> I guess it's better to check the return value, though it will hardly happen
> in real-life..

Well, I disagree with that, if it can fail, it will fail someday, if
failing is such a disastrous thing, register_trace_xxx() should return
void and do the WARN_ON directly :-)

- Arnaldo
 
> > +static void blk_tracer_error(const char *name)
> > +{
> > +	pr_info("blk trace: Couldn't activate tracepoint "
> > +		"probe to block_%s\n", name);
> > +}
> > +
> > +#define register_trace_block(tpoint)				     \
> > +	ret = register_trace_block_##tpoint(blk_add_trace_##tpoint); \
> > +	if (ret) { 						     \
> > +		blk_tracer_error(#tpoint);			     \
> > +		goto *exit_point;		  		     \
> > +	} else							     \
> > +		exit_point = &&fail_deprobe_##tpoint;
> > +	
> > +
> > +#define fail_trace_block(tpoint)	\
> > +	fail_deprobe_##tpoint:		\
> > +		unregister_trace_block_##tpoint(blk_add_trace_##tpoint)
> > +
> > +static int tracing_blk_register(void)
> > +{
> > +	int ret;
> > +	void *exit_point = &&error;
> > +
> > +	register_trace_block(rq_abort);
> > +	register_trace_block(rq_insert);
> > +	register_trace_block(rq_issue);
> > +	register_trace_block(rq_requeue);
> > +	register_trace_block(rq_complete);
> > +	register_trace_block(bio_bounce);
> > +	register_trace_block(bio_backmerge);
> > +	register_trace_block(bio_frontmerge);
> > +	register_trace_block(bio_queue);
> > +	register_trace_block(getrq);
> > +	register_trace_block(sleeprq);
> > +	register_trace_block(plug);
> > +	register_trace_block(unplug_timer);
> > +	register_trace_block(unplug_io);
> > +	register_trace_block(split);
> > +	register_trace_block(remap);
> > +
> > +	return 0;
> > +
> > +	fail_trace_block(remap);
> > +	fail_trace_block(split);
> > +	fail_trace_block(unplug_io);
> > +	fail_trace_block(unplug_timer);
> > +	fail_trace_block(plug);
> > +	fail_trace_block(sleeprq);
> > +	fail_trace_block(getrq);
> > +	fail_trace_block(bio_queue);
> > +	fail_trace_block(bio_frontmerge);
> > +	fail_trace_block(bio_backmerge);
> > +	fail_trace_block(bio_bounce);
> > +	fail_trace_block(rq_complete);
> > +	fail_trace_block(rq_requeue);
> > +	fail_trace_block(rq_issue);
> > +	fail_trace_block(rq_insert);
> > +	fail_trace_block(rq_abort);
> > +error:
> > +	return ret;
> > +}
> > +
> > +static void tracing_blk_unregister(void)
> > +{
> > +	unregister_trace_block_remap(blk_add_trace_remap);
> > +	unregister_trace_block_split(blk_add_trace_split);
> > +	unregister_trace_block_unplug_io(blk_add_trace_unplug_io);
> > +	unregister_trace_block_unplug_timer(blk_add_trace_unplug_timer);
> > +	unregister_trace_block_plug(blk_add_trace_plug);
> > +	unregister_trace_block_sleeprq(blk_add_trace_sleeprq);
> > +	unregister_trace_block_getrq(blk_add_trace_getrq);
> > +	unregister_trace_block_bio_queue(blk_add_trace_bio_queue);
> > +	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge);
> > +	unregister_trace_block_bio_backmerge(blk_add_trace_bio_backmerge);
> > +	unregister_trace_block_bio_complete(blk_add_trace_bio_complete);
> > +	unregister_trace_block_bio_bounce(blk_add_trace_bio_bounce);
> > +	unregister_trace_block_rq_complete(blk_add_trace_rq_complete);
> > +	unregister_trace_block_rq_requeue(blk_add_trace_rq_requeue);
> > +	unregister_trace_block_rq_issue(blk_add_trace_rq_issue);
> > +	unregister_trace_block_rq_insert(blk_add_trace_rq_insert);
> > +	unregister_trace_block_rq_abort(blk_add_trace_rq_abort);
> > +	tracepoint_synchronize_unregister();
> > +}
> > 
> > Regards,
> > 
> > - Arnaldo
> > 
> > 
