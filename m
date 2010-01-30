Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201Ab0A3WsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0A3WsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 17:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998Ab0A3Wr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 17:47:59 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:37027 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0A3Wr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 17:47:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JsSIR9xxVTGQQckq/WAkl9wQ1Ko24c7E7NverNK8jZsu/c5eaZUJbB67k9T1KqMDM4
         3CZ0IVIoqIIUcdwHAF0eHomNxGTXK7f+7Rs+AJYLvb6MKeBg79tJ4A3OHf3cl09Pc2Xm
         QkuF8e/pYDZONmI9lktNsHiryHOFg6275RV/E=
Date: Sat, 30 Jan 2010 23:47:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: move static old_tracer to trace_iterator
Message-ID: <20100130224754.GL5675@nowhere>
References: <4B5E998D.9070603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5E998D.9070603@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 03:28:13PM +0800, Lai Jiangshan wrote:
> 
> static old_tracer is global for all processes.
> 
> So there is a potential bug when:
> current_trace and static old_tracer are changed by other processes,
> current_trace and static old_tracer are match with each other.
> but *iter->trace and *current_trace are not match.
> 
> This patch move old_tracer to trace_iterator, and make it not global.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>


We should actually get rid of old_tracer and have iter->trace
to be a pointer so that the check can be summarized with

if (iter->trace != current_trace)


I don't exactly recall why we've made iter->trace a copy
of the current_trace. I remember I did it this uglyness,
but I don't remember exactly why. Probably for bad reasons
that should be fixed another way.

Ok, having a deeper look, I think it was because some tracers
implement callbacks whereas others may not, so the
simple:

if (iter->trace->splice_read)
	ret = iter->trace->splice_read(...)

would be racy if we weren't copying current_trace.

To fix this, I would rather try to ensure every tracers
have stub callbacks for those unimplemented. This is going
to be much proper than this dance between current_tracer,
old_tracer and iter->trace.

What do you think?

