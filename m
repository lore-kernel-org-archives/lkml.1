Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYLPQTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYLPQTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757626AbYLPQSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:18:37 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:59874 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552AbYLPQSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:18:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hAE5Bc5H7W0xs4OuRVOEoMad9rftoLB0sPd9H4neXgJD9Bpmn+dtm7bjqduawkYo7t
         fRFkpJPswlmWggE57JH1gWhyhss6hGKhzUk99Oe96byaHSHIPMgeKEq7H6JHfYJJJ3SG
         Xhh6nJQYyv4eIHNxoQS28BqRGZEiPZgIFhjvU=
Message-ID: <c62985530812160818g49cb2aa8k9800ead254faebcd@mail.gmail.com>
Date: Tue, 16 Dec 2008 17:18:33 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: trace_seq_printf/.print_line question
In-Reply-To: <20081216141003.GK14518@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081216141003.GK14518@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/16 Arnaldo Carvalho de Melo <acme@redhat.com>:
> Jens, just a FYI about this stuff, not yet ready for reviewing.
>
> Hi Frédéric, Steven,
>
>        Have you guys ever get into this kind of situation?
>
> [root@mica linux-2.6-tip]# cat /sys/kernel/debug/tracing/trace | tail
>       kjournald-480   [000]   593.219805:   C   W 2149459 + 8 [0]
>          <idle>-0     [000]   593.219849:   A  WS 2149467 + 8 <- (8,2) 44952
>       kjournald-480   [000]   607.210959:   Q  WS 2149467 + 8
>       kjournald-480   [000]   607.210960:   G  WS 2149467 + 8
>       kjournald-480   [000]   607.210963:   P   N
>       kjournald-480   [000]   607.210964:   I   W 2149467 + 8
>       kjournald-480   [000]   607.210965:   D   W 2149467 + 8
>       kjournald-480   [000]   607.210967:   U   N 1
>       kjournald-480   [000]   607.210971:   C   W 2149467 + 8 [0]
>          <idle>-0     [000]   607.211049: [root@mica linux-2.6-tip]#
>
> [root@mica linux-2.6-tip]# head /sys/kernel/debug/tracing/trace
> # tracer: blk
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>  A   W 2147707 + 8 <- (8,2) 43192
>       kjournald-480   [000]   254.428659:   Q   W 2147707 + 8
>       kjournald-480   [000]   254.428661:   G   W 2147707 + 8
>       kjournald-480   [000]   254.428663:   I   W 100410211 + 8
>         pdflush-261   [000]   147.328259:   P   N
>       kjournald-480   [000]   254.428664:   I   W 2147707 + 8
> [root@mica linux-2.6-tip]#


Actually, if you implement a print_line callback for your tracer,
you're not supposed to see the
task-pid, cpu number and time printed before your traces. You should
only see what you print with your tracer.

task-pid/cpu/timespamp are only printed by the default printing
functions in trace.c, ie: used by
the function tracer, the stack tracer, the sched tracer... or when a
tracer's print_line
returns TRACE_TYPE_UNHANDLED.

And that's what is happening with your tracer.
If you look at the following:

> +static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
> +{
> +       struct trace_seq *s = &iter->seq;
> +       struct trace_entry *entry = iter->ent;
> +
> +       switch (entry->type) {
> +       case TRACE_BLOCK: {
> +               int ret, act;
> +               struct blk_io_entry *t;
> +
> +               trace_assign_type(t, entry);
> +               act = what_action(t);
> +
> +               switch (act) {
> +                case __BLK_TA_ISSUE:
> +                        ret = blk_log_generic(s, t, "D");
> +                        break;
> +               case __BLK_TA_INSERT:
> +                        ret = blk_log_generic(s, t, "I");
> +                       break;
> +               case __BLK_TA_QUEUE:
> +                        ret = blk_log_generic(s, t, "Q");
> +                        break;
> +                case __BLK_TA_BOUNCE:
> +                        ret = blk_log_generic(s, t, "B");
> +                        break;
> +               case __BLK_TA_BACKMERGE:
> +                       ret = blk_log_generic(s, t, "M");
> +                       break;
> +               case __BLK_TA_FRONTMERGE:
> +                       ret = blk_log_generic(s, t, "F");
> +                       break;
> +                case __BLK_TA_GETRQ:
> +                        ret = blk_log_generic(s, t, "G");
> +                        break;
> +                case __BLK_TA_SLEEPRQ:
> +                        ret = blk_log_generic(s, t, "S");
> +                        break;
> +                case __BLK_TA_REQUEUE:
> +                        ret = blk_log_with_error(s, t, "R");
> +                        break;
> +                case __BLK_TA_COMPLETE:
> +                        ret = blk_log_with_error(s, t, "C");
> +                        break;
> +               case __BLK_TA_PLUG:
> +                        ret = blk_log_action(s, t, "P");
> +                       break;
> +               case __BLK_TA_UNPLUG_IO:
> +                        ret = blk_log_unplug(s, t, "U");
> +                       break;
> +               case __BLK_TA_UNPLUG_TIMER:
> +                        ret = blk_log_unplug(s, t, "UT");
> +                       break;
> +                case __BLK_TA_REMAP:
> +                        ret = blk_log_remap(s, t);
> +                        break;
> +               case __BLK_TA_SPLIT:
> +                        ret = blk_log_split(s, t, "X");
> +                        break;
> +                default:
> +                        ret = trace_seq_printf(s, "Bad pc action %x\n", act);
> +                       break;
> +               }
> +               if (!ret)
> +                       return TRACE_TYPE_PARTIAL_LINE;
> +       }
> +       default:
> +               return TRACE_TYPE_UNHANDLED;
> +       }
> +
> +       return TRACE_TYPE_HANDLED;
> +}


You are always returning TRACE_TYPE_UNHANDLED because you missed a
break statement at the
end of your TRACE_BLOCK case :-)

So you are printing your trace, and then the default printing
functions on trace.c, assuming you haven't
handled it, will print task/cpu/timestamp for a function trace or a
stack trace or whatever...
Hence the weird output :-)
