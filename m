Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbZLPLtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbZLPLtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 06:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbZLPLtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 06:49:12 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56485 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbZLPLtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 06:49:11 -0500
Date: Wed, 16 Dec 2009 06:49:03 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
	includes when defining CREATE_TRACE_POINTS
Message-ID: <20091216114903.GA29609@hmsreliant.think-freely.org>
References: <1259849726.12870.123.camel@gandalf.stny.rr.com> <20091203193549.GA18664@hmsreliant.think-freely.org> <1260216282.4845.3.camel@gandalf.stny.rr.com> <20091207201829.GG8073@hmsreliant.think-freely.org> <1260218831.3518.3.camel@gandalf.stny.rr.com> <1260218966.3518.4.camel@gandalf.stny.rr.com> <20091207205341.GH8073@hmsreliant.think-freely.org> <20091214195058.GB31323@hmsreliant.think-freely.org> <20091215160852.GA18710@hmsreliant.think-freely.org> <1260936829.2146.447.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260936829.2146.447.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -3.8 (---)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:13:49PM -0500, Steven Rostedt wrote:
> On Tue, 2009-12-15 at 11:08 -0500, Neil Horman wrote:
> 
> Hi Neil,
> 
> I was playing with this, and I got really nasty errors in the trace
> parsing tools. Then I noticed why:
> 
> > -DECLARE_TRACE(napi_poll,
> > +TRACE_EVENT(napi_poll,
> > +
> >  	TP_PROTO(struct napi_struct *napi),
> > -	TP_ARGS(napi));
> > +
> > +	TP_ARGS(napi),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(        struct napi_struct *,	napi)
> > +        ),
> > +
> > +        TP_fast_assign(
> > +                __entry->napi = napi;
> > +        ),
> > +
> > +        TP_printk("napi poll on napi struct %p for device %s",
> > +		__entry->napi, __entry->napi->dev->name)
> 
> You can't trust this! That "__entry" happens to reside on the ring
> buffer. If for some reason the device goes away, this blows up when you
> read the trace.
> 
> If you need to save the name of the device, then store it in the ring
> buffer. You can do it with a dynamic array:
> 
> 	TP_STRUCT__entry(
> 		__field(	struct napi_struct *, napi)
> 		__string(	dev_name, napi->dev->name)
> 	),
> 
> 	TP_fast_assign(
> 		__entry->napi = napi;
> 		__assign_str(dev_name, napi->dev->name);
> 	),
> 
> 	TP_printk("napi poll on napi struct %p for device %s",
> 		__entry->napi, __get_string(dev_name))
> 
> -- Steve
> 
> > +);
> >  
> >  #endif
> 
> 
> 
Ok, thanks, I'll resubmit shortly.
Neil

