Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462Ab0A3VTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0A3VTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 16:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131Ab0A3VTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 16:19:47 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:34579 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab0A3VTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 16:19:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=trjdCj3OEbSwJAQKYrhgyE4GqcfsSvyiMWHZ/6cKXl4fudzS3mqFBPxAcgpOrZ+VUP
         Ja4S4t5UWF1V2Eqr0YObHhebV1XRhU1YjU69/Ks74ao4N9wJoEh2eTB7KJ9YBUxHtxgs
         aM26BDs+bNlAPW1O4o9QK3E+AuYXva4P2E6ro=
Date: Sat, 30 Jan 2010 22:19:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH 09/10] tracing: Use the hashlist for graph function
Message-ID: <20100130211942.GH5675@nowhere>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-10-git-send-regression-fweisbec@gmail.com> <4B5D5B68.6020806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5D5B68.6020806@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 04:50:48PM +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > When we set a filter to start tracing from a given function in
> > the function graph tracer, the filter is stored in a linear array.
> > 
> > It doesn't scale very well, we even limited the number of such
> > functions to 32.
> > 
> > Now that we have a hashlist of functions, lets put a field inside
> > each function node so that we can check if a function is one of
> > these filters using the hashlist, not a linear array.
> 
> The linear array @ftrace_graph_funcs is still used in this patch.
> we still limit the number of such functions to 32?
> 
> [...]



Heh, that's right. I should probably make it a list. The array
is only used when we touch set_graph_function file.



> >  #define FTRACE_GRAPH_MAX_FUNCS		32
> >  extern int ftrace_graph_count;
> >  extern unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS];
> > -
> > -static inline int ftrace_graph_addr(unsigned long addr)
> > -{
> > -	int i;
> > -
> > -	if (!ftrace_graph_count)
> > -		return 1;
> 
> Here return 1.
> 
> [...]
> > +static inline int ftrace_graph_addr(unsigned long addr)
> > +{
> > +	struct func_node *rec;
> > +	struct func_hlist *hlist;
> > +
> > +	if (!ftrace_graph_count)
> > +		return 0;
> > +
> 
> But in this patch, return 0 here, the behave will be changed.


Yeah, I've inverted the check from the tracing callback.

It seems to me that:

	if (ftrace_graph_addr(addr))

more logically means that we trace this addr. Making it
a boolean would make the things more clear perhaps?

