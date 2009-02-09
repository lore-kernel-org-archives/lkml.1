Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZBISnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZBISnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZBISnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:43:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZBISnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:43:08 -0500
Date: Mon, 9 Feb 2009 13:43:04 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] tracing: clean up splice code
In-Reply-To: <20090209183754.GB5283@localhost>
Message-ID: <alpine.DEB.1.10.0902091342000.14528@gandalf.stny.rr.com>
References: <20090209172830.087244662@goodmis.org> <20090209172956.970104543@goodmis.org> <20090209182500.GA5283@localhost> <4990754C.7010301@cs.helsinki.fi> <20090209183754.GB5283@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Feb 2009, Eduard - Gabriel Munteanu wrote:

> On Mon, Feb 09, 2009 at 08:26:20PM +0200, Pekka Enberg wrote:
> > Eduard - Gabriel Munteanu wrote:
> >>> @@ -2573,45 +2607,25 @@ static ssize_t tracing_splice_read_pipe(struct 
> >>> file *filp,
> >>>  		ret = iter->trace->splice_read(iter, filp,
> >>>  					       ppos, pipe, len, flags);
> >>>  		if (ret)
> >>> -			goto out;
> >>> +			goto out_err;
> >>>  	}
> >>>   	ret = tracing_wait_pipe(filp);
> >>>  	if (ret <= 0)
> >>> -		goto out;
> >>> +		goto out_err;
> >>>   	if (!iter->ent && !find_next_entry_inc(iter)) {
> >>>  		ret = -EFAULT;
> >>> -		goto out;
> >>> +		goto out_err;
> >>>  	}
> >>>   	/* Fill as many pages as possible. */
> >>>  	for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
> >>>  		pages[i] = alloc_page(GFP_KERNEL);
> >>> +		if (!pages[i])
> >>> +			break;
> >> I believe you should decrement 'i' before breaking, since we fill
> >> spd.nr_pages just after the loop. In case the current page couldn't be
> >> allocated, spd.nr_pages will be one too many (that is, 'i').
> >
> > But, but, if we fail for i == 1, for example, we want ->nr_pages == 1, no?
> >
> > 			Pekka
> 
> Sure, my bad. I even made the same assumption myself about the outer
> 'for' loop when I wrote it ('i' would end up last page + 1). The patch is
> okay. :-)

Heh, I was just about to say, if this is wrong then so is the if below it 
;-)


               pages[i] = alloc_page(GFP_KERNEL);
                if (!pages[i])
                        break;

                rem = tracing_fill_pipe_page(pages[i], rem, iter);

                /* Copy the data into the page, so we can start over. */
                ret = trace_seq_to_buffer(&iter->seq,
                                          page_address(pages[i]),
                                          iter->seq.len);
                if (ret < 0) {
                        __free_page(pages[i]);

Same 'i'.
                        break;
                }


Thanks Eduard!

-- Steve

