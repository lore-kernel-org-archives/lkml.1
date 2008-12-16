Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYLPJiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYLPJiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYLPJhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:37:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbYLPJhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:37:54 -0500
Date: Tue, 16 Dec 2008 01:37:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 6/9] oprofile: port to the new ring_buffer
Message-Id: <20081216013725.33ccd1ab.akpm@linux-foundation.org>
In-Reply-To: <1229013723-8191-7-git-send-email-robert.richter@amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
	<1229013723-8191-7-git-send-email-robert.richter@amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 17:42:00 +0100 Robert Richter <robert.richter@amd.com> wrote:

> -static inline
> -struct op_sample *cpu_buffer_read_entry(struct oprofile_cpu_buffer *cpu_buf)
> +static inline struct op_sample *cpu_buffer_read_entry(int cpu)
>  {
> -	return &cpu_buf->buffer[cpu_buf->tail_pos];
> +	struct ring_buffer_event *e;
> +	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
> +	if (e)
> +		return ring_buffer_event_data(e);
> +	if (ring_buffer_swap_cpu(op_ring_buffer_read,
> +				 op_ring_buffer_write,
> +				 cpu))
> +		return NULL;
> +	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
> +	if (e)
> +		return ring_buffer_event_data(e);
> +	return NULL;
>  }

This file has some really large inlined functions.
cpu_buffer_read_entry() has three callsites..
