Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZD2TK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZD2TK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZD2TKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:10:48 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:23466 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZD2TKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:10:47 -0400
Message-ID: <49F8A5FE.9010305@oracle.com>
Date: Wed, 29 Apr 2009 12:09:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       rostedt@goodmis.org, fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca,
       wcohen@redhat.com
Subject: Re: [PATCH 3/3] add irq tracepoint documentation
References: <200904291745.n3THjX3g019550@ns3.rdu.redhat.com>
In-Reply-To: <200904291745.n3THjX3g019550@ns3.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.49F8A5B4.00F3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> Document irqs for the newly created docbook.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  Documentation/DocBook/tracepoint.tmpl |    5 +++
>  include/trace/events/irq.h            |   46 ++++++++++++++++++++++++++++++---
>  2 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/DocBook/tracepoint.tmpl b/Documentation/DocBook/tracepoint.tmpl
> index 2639a8b..8b7fb48 100644
> --- a/Documentation/DocBook/tracepoint.tmpl
> +++ b/Documentation/DocBook/tracepoint.tmpl
> @@ -81,4 +81,9 @@
>     </para>
>    </chapter>
>  
> +  <chapter id="irq">
> +   <title>IRQ</title>
> +!Iinclude/trace/events/irq.h
> +  </chapter>
> +
>  </book>
> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index 7686864..bb5bbec 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -7,8 +7,16 @@
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM irq
>  
> -/*
> - * Tracepoint for entry of interrupt handler:
> +/**
> + * irq_handler_entry - called immediately before the irq action handler
> + * @irq: irq number
> + * @action: pointer to struct irqaction
> + *
> + * The struct irqaction pointed to by the 'action' parameter contains

Parameters are usually written as:           @action
etc....

Otherwise looks good.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> + * various information about the handler, including the device name,
> + * action->name, and the device id, action->dev_id. When used in
> + * conjunction with the irq_handler_exit tracepoint, we can figure
> + * out irq handler latencies.
>   */
>  TRACE_EVENT(irq_handler_entry,
>  
> @@ -29,8 +37,16 @@ TRACE_EVENT(irq_handler_entry,
>  	TP_printk("irq=%d handler=%s", __entry->irq, __get_str(name))
>  );
>  
> -/*
> - * Tracepoint for return of an interrupt handler:
> +/**
> + * irq_handler_exit - called immediately after the irq action handler returns
> + * @irq: irq number
> + * @action: pointer to struct irqaction
> + * @ret: return value
> + *
> + * If the 'ret' value is set to IRQ_HANDLED, then we know that the corresponding
> + * action->handler scuccessully handled this irq. Otherwise, the irq might be
> + * a shared irq line, or the irq was not handled successfully. Can be used in
> + * conjunction with the irq_handler_entry to understand irq handler latencies.
>   */
>  TRACE_EVENT(irq_handler_exit,
>  
> @@ -52,6 +68,17 @@ TRACE_EVENT(irq_handler_exit,
>  		  __entry->irq, __entry->ret ? "handled" : "unhandled")
>  );
>  
> +/**
> + * softirq_entry - called immediately before the softirq handler
> + * @h: pointer to struct softirq_action
> + * @vec: pointer to first struct softirq_action in softirq_vec array
> + *
> + * The 'h' parameter, contains a pointer to the struct softirq_action
> + * which has a pointer to the action handler that is called. By subtracting
> + * the 'vec' pointer from the 'h' pointer, we can determine the softirq
> + * number. Also, when used in combination with the softirq_exit tracepoint
> + * we can determine the softirq latency.
> + */
>  TRACE_EVENT(softirq_entry,
>  
>  	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> @@ -71,6 +98,17 @@ TRACE_EVENT(softirq_entry,
>  	TP_printk("softirq=%d action=%s", __entry->vec, __get_str(name))
>  );
>  
> +/**
> + * softirq_exit - called immediately after the softirq handler returns
> + * @h: pointer to struct softirq_action
> + * @vec: pointer to first struct softirq_action in softirq_vec array
> + *
> + * The 'h' parameter contains a pointer to the struct softirq_action
> + * that has handled the softirq. By subtracting the 'vec' pointer from
> + * the 'h' pointer, we can determine the softirq number. Also, when used in
> + * combination with the softirq_exit tracepoint we can determine the softirq
> + * latency.
> + */
>  TRACE_EVENT(softirq_exit,
>  
>  	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),


-- 
~Randy
