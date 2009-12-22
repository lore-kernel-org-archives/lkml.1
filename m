Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbZLVSEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbZLVSEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 13:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZLVSEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 13:04:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52944 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZLVSEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 13:04:07 -0500
X-Authority-Analysis: v=1.0 c=1 a=NF6sa4JFLCQA:10 a=7U3hwN5JcxgA:10 a=eIZWIM8TV_a6JJOlsM8A:9 a=8auuo2K5QBP98dCC0GaHRbKahy8A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
 includes when defining CREATE_TRACE_POINTS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20091216160452.GC29609@hmsreliant.think-freely.org>
References: <20091203193549.GA18664@hmsreliant.think-freely.org>
	 <1260216282.4845.3.camel@gandalf.stny.rr.com>
	 <20091207201829.GG8073@hmsreliant.think-freely.org>
	 <1260218831.3518.3.camel@gandalf.stny.rr.com>
	 <1260218966.3518.4.camel@gandalf.stny.rr.com>
	 <20091207205341.GH8073@hmsreliant.think-freely.org>
	 <20091214195058.GB31323@hmsreliant.think-freely.org>
	 <20091215160852.GA18710@hmsreliant.think-freely.org>
	 <1260936829.2146.447.camel@gandalf.stny.rr.com>
	 <20091216114903.GA29609@hmsreliant.think-freely.org>
	 <20091216160452.GC29609@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 22 Dec 2009 13:03:59 -0500
Message-ID: <1261505039.25193.1342.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 11:04 -0500, Neil Horman wrote:


> +#if !defined(_TRACE_NAPI_H_) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_NAPI_H_
>  

Ug, I'm still getting panics because of this. I found out that it's
because napi->dev can be NULL.

Here's what I did to solve it:


>  #include <linux/netdevice.h>
>  #include <linux/tracepoint.h>
> +#include <linux/ftrace.h>
> +

#define NO_DEV		"(no device)"

> +TRACE_EVENT(napi_poll,
>  
> -DECLARE_TRACE(napi_poll,
>  	TP_PROTO(struct napi_struct *napi),
> -	TP_ARGS(napi));
> +
> +	TP_ARGS(napi),
> +
> +	TP_STRUCT__entry(
> +		__field(        struct napi_struct *,	napi)
> +		__string(	dev_name, napi->dev->name)

		__string(	dev_name, napi->dev ? napi->dev->name, NO_DEV )

> +        ),
> +
> +        TP_fast_assign(
> +                __entry->napi = napi;
> +		__assign_str(dev_name, napi->dev->name);

		__assign_str(dev_name, napi->dev ? napi->dev->name, NO_DEV);

> +        ),
> +
> +        TP_printk("napi poll on napi struct %p for device %s",
> +		__entry->napi, __get_str(dev_name))
> +);

#undef NO_DEV

-- Steve


>  
>  #endif
> +
> +#include <trace/define_trace.h>


