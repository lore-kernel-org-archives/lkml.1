Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbYLPOKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbYLPOKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYLPOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:10:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48299 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYLPOKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:10:44 -0500
Date: Tue, 16 Dec 2008 12:10:03 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: trace_seq_printf/.print_line question
Message-ID: <20081216141003.GK14518@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, just a FYI about this stuff, not yet ready for reviewing.

Hi Frédéric, Steven,

	Have you guys ever get into this kind of situation?

[root@mica linux-2.6-tip]# cat /sys/kernel/debug/tracing/trace | tail
       kjournald-480   [000]   593.219805:   C   W 2149459 + 8 [0]
          <idle>-0     [000]   593.219849:   A  WS 2149467 + 8 <- (8,2) 44952
       kjournald-480   [000]   607.210959:   Q  WS 2149467 + 8
       kjournald-480   [000]   607.210960:   G  WS 2149467 + 8
       kjournald-480   [000]   607.210963:   P   N
       kjournald-480   [000]   607.210964:   I   W 2149467 + 8
       kjournald-480   [000]   607.210965:   D   W 2149467 + 8
       kjournald-480   [000]   607.210967:   U   N 1
       kjournald-480   [000]   607.210971:   C   W 2149467 + 8 [0]
          <idle>-0     [000]   607.211049: [root@mica linux-2.6-tip]# 

[root@mica linux-2.6-tip]# head /sys/kernel/debug/tracing/trace
# tracer: blk
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
  A   W 2147707 + 8 <- (8,2) 43192
       kjournald-480   [000]   254.428659:   Q   W 2147707 + 8
       kjournald-480   [000]   254.428661:   G   W 2147707 + 8
       kjournald-480   [000]   254.428663:   I   W 100410211 + 8
         pdflush-261   [000]   147.328259:   P   N
       kjournald-480   [000]   254.428664:   I   W 2147707 + 8
[root@mica linux-2.6-tip]# 

This is happening in an experiment I'm doing in porting blktrace to the
tracing/ring_buffer infrastructure, the problem always happens at this
function:

static int blk_log_remap(struct trace_seq *s, struct blk_io_entry *t)
{
        char rwbs[6];
        struct blk_io_trace_remap r = { .device = 0, };

        get_pdu_remap(t, &r);
        t->device = r.device_from;
        fill_rwbs(rwbs, t);
        return trace_seq_printf(s, "  A %3s %llu + %u <- (%d,%d) %llu\n",
                                rwbs, (unsigned long long)t->sector,
                                t_sec(t), MAJOR(r.device), MINOR(r.device),
                                (unsigned long long)r.sector);
}

And the registered .print_line routine does check the return of
trace_seq_printf:

               if (!ret)
                        return TRACE_TYPE_PARTIAL_LINE;
        }
        default:
                return TRACE_TYPE_UNHANDLED;
        }

        return TRACE_TYPE_HANDLED;
}

Full patch, still WIPish:
http://oops.ghostprotocols.net:81/acme/blkftrace.patch

- Arnaldo
