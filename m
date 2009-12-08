Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbZLHILN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbZLHILN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZLHILL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:11:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:31606 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZLHILL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:11:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VArktqnDpQlMiy1GHw3Ku2N5UWZNSC4fOyMC+TeGMlIOXf3s4HBN+csEMr+1dn0i/5
         jXm7Wo1SHaEPpbdxMA/wCLVKKrznE2H5U/+8kOi6UWfowt4EPiJvFYLQP4iefi0ywVEW
         1dGy/lC4dw1eV7J5chDIDCTLNDDbMkWqoxCHo=
Date: Tue, 8 Dec 2009 09:11:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/13] tracing: Move a printk out of
	ftrace_raw_reg_event_foo()
Message-ID: <20091208081112.GF4989@nowhere>
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC4AC.802@cn.fujitsu.com> <20091208074342.GB4989@nowhere> <4B1E0507.2060403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E0507.2060403@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 03:49:27PM +0800, Li Zefan wrote:
> >> -static void ftrace_event_enable_disable(struct ftrace_event_call *call,
> >> +static int ftrace_event_enable_disable(struct ftrace_event_call *call,
> >>  					int enable)
> >>  {
> >> +	int ret = 0;
> >> +
> >>  	switch (enable) {
> >>  	case 0:
> >>  		if (call->enabled) {
> >> @@ -131,12 +133,19 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
> >>  		break;
> >>  	case 1:
> >>  		if (!call->enabled) {
> >> +			ret = call->regfunc(call);
> >> +			if (ret) {
> >> +				pr_info("event trace: Could not enable event "
> >> +					"%s\n", call->name);
> >> +				break;
> >> +			}
> >>  			call->enabled = 1;
> >>  			tracing_start_cmdline_record();
> >> -			call->regfunc(call);
> > 
> > That seems to open a tiny window during which we'll lose
> > some pid -> comm resolution records.
> > 
> > We should probably keep the previous call order.
> > 
> 
> Hm, actually the tiny window is already there in that
> tracing_stop_cmdline_record() is called before call->unregfunc()..
> 
> So I can send a fix-up patch later.


The presence of a previous race window doesn't justify we add
a new one :)

I'll fix that while applying the patch.

Thanks.

