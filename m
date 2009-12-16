Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbZLPEN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbZLPEN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 23:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759264AbZLPENy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 23:13:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49130 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbZLPENx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 23:13:53 -0500
X-Authority-Analysis: v=1.0 c=1 a=NF6sa4JFLCQA:10 a=7U3hwN5JcxgA:10 a=20VumVpLYUws9-fuaWYA:9 a=uMjw2Sk46iYs1nWoxSBVWsq7NOMA:4
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
In-Reply-To: <20091215160852.GA18710@hmsreliant.think-freely.org>
References: <20091202191916.GA7589@hmsreliant.think-freely.org>
	 <1259849726.12870.123.camel@gandalf.stny.rr.com>
	 <20091203193549.GA18664@hmsreliant.think-freely.org>
	 <1260216282.4845.3.camel@gandalf.stny.rr.com>
	 <20091207201829.GG8073@hmsreliant.think-freely.org>
	 <1260218831.3518.3.camel@gandalf.stny.rr.com>
	 <1260218966.3518.4.camel@gandalf.stny.rr.com>
	 <20091207205341.GH8073@hmsreliant.think-freely.org>
	 <20091214195058.GB31323@hmsreliant.think-freely.org>
	 <20091215160852.GA18710@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 15 Dec 2009 23:13:49 -0500
Message-ID: <1260936829.2146.447.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 11:08 -0500, Neil Horman wrote:

Hi Neil,

I was playing with this, and I got really nasty errors in the trace
parsing tools. Then I noticed why:

> -DECLARE_TRACE(napi_poll,
> +TRACE_EVENT(napi_poll,
> +
>  	TP_PROTO(struct napi_struct *napi),
> -	TP_ARGS(napi));
> +
> +	TP_ARGS(napi),
> +
> +	TP_STRUCT__entry(
> +		__field(        struct napi_struct *,	napi)
> +        ),
> +
> +        TP_fast_assign(
> +                __entry->napi = napi;
> +        ),
> +
> +        TP_printk("napi poll on napi struct %p for device %s",
> +		__entry->napi, __entry->napi->dev->name)

You can't trust this! That "__entry" happens to reside on the ring
buffer. If for some reason the device goes away, this blows up when you
read the trace.

If you need to save the name of the device, then store it in the ring
buffer. You can do it with a dynamic array:

	TP_STRUCT__entry(
		__field(	struct napi_struct *, napi)
		__string(	dev_name, napi->dev->name)
	),

	TP_fast_assign(
		__entry->napi = napi;
		__assign_str(dev_name, napi->dev->name);
	),

	TP_printk("napi poll on napi struct %p for device %s",
		__entry->napi, __get_string(dev_name))

-- Steve

> +);
>  
>  #endif


