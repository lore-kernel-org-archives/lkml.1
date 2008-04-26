Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbYD0KAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbYD0KAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbYD0KAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:00:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:28751 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbYD0KAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:00:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=sKdfKZF3YC0DmvKm4gX3QIcStNGfEPlu0U+Nbmiw+50MSGM5QNnNkY/hqmHllyG6DFsTB6yPklL1fOZjhXUU9q1h1A7pIsz3SgjGb7Qh/+FurGQBhBZev7BIme17Kf0d7pmflo9iAn++vAdDlhOr+lAGeaRRrkAb4sQ0hTT0GoA=
Date: Sat, 26 Apr 2008 20:33:06 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] ftrace: add trace pipe header pluggin
Message-ID: <20080426203306.2e41fb55@daedalus.pq.iki.fi>
In-Reply-To: <20080421212128.360075568@goodmis.org>
References: <20080421210935.460817943@goodmis.org>
	<20080421212128.360075568@goodmis.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 17:09:37 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> This patch adds a method for open_pipe and open_read to the pluggins
> so that they can add a header to the trace pipe call.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

In addition to this, I think I need tracer::close method called on
tracing_release_pipe(). Use case: the reader closes the pipe before
I have printed all of my header, i.e. walked through all PCI devices,
so I need to properly destroy trace_iterator::private.

I also intend to use trace_iterator::seq for printing my header, so I
am looking if I can reuse code from tracing_read_pipe(). Looks like I'll
extract the "return any leftover data" part into a separate function.

To check trace_iterator::overrun, I'd like to be able to use
for_each_tracing_cpu(), but that is local to trace.c.

What happens when the tracing cpu mask changes? Mmiotrace does not take
that into account and will continue to record with all CPUs, will this
lead to problems, when mmiotrace starts to support SMP properly?

Now that I think of it, I probably want to use for_each_online_cpu()
in checking for overruns... but that's not good either, if someone
enables/disables a cpu during tracing. I guess you will have to / had to
deal with this case in tracing core, too.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
