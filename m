Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab0CCRal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:30:41 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8767 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab0CCRaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:30:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=gqm89MINLJQ7GUT5SOtOcUbxvg18+NF2Nn1+2Isx0BJEGSrNzqY2UlV1Zp7om1zST
	b4bfrweNsU8vkDZaglUhg==
MIME-Version: 1.0
In-Reply-To: <20100303164306.375353163@chello.nl>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.375353163@chello.nl>
Date: Wed, 3 Mar 2010 09:30:31 -0800
Message-ID: <bd4cb8901003030930q4050d074k11a45c3583b96502@mail.gmail.com>
Subject: Re: [RFC][PATCH 07/11] perf: Provide PERF_SAMPLE_REGS
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o23HVLmE020584

This assumes struct pt_regs is somehow exported to userland.Is that the case?
I would clearly spell out that the REGS are the interrupted REGS,not the overflow REGS. Maybe PERF_SAMPLE_IREGS.
On Wed, Mar 3, 2010 at 8:39 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:> Simply copy out the provided pt_regs in a u64 aligned fashion.>> XXX: do task_pt_regs() and get_irq_regs() always clear everything or>     are we now leaking data?>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>> --->  include/linux/perf_event.h |    5 ++++->  kernel/perf_event.c        |   17 +++++++++++++++++>  2 files changed, 21 insertions(+), 1 deletion(-)>> Index: linux-2.6/include/linux/perf_event.h> ===================================================================> --- linux-2.6.orig/include/linux/perf_event.h> +++ linux-2.6/include/linux/perf_event.h> @@ -125,8 +125,9 @@ enum perf_event_sample_format {>        PERF_SAMPLE_PERIOD                      = 1U << 8,>        PERF_SAMPLE_STREAM_ID                   = 1U << 9,>        PERF_SAMPLE_RAW                         = 1U << 10,> +       PERF_SAMPLE_REGS                        = 1U << 11,>> -       PERF_SAMPLE_MAX = 1U << 11,             /* non-ABI */> +       PERF_SAMPLE_MAX = 1U << 12,             /* non-ABI */>  };>>  /*> @@ -392,6 +393,7 @@ enum perf_event_type {>         *      { u64                   period;   } && PERF_SAMPLE_PERIOD>         *>         *      { struct read_format    values;   } && PERF_SAMPLE_READ> +        *      { struct pt_regs        regs;     } && PERF_SAMPLE_REGS>         *>         *      { u64                   nr,>         *        u64                   ips[nr];  } && PERF_SAMPLE_CALLCHAIN> @@ -800,6 +802,7 @@ struct perf_sample_data {>        u64                             period;>        struct perf_callchain_entry     *callchain;>        struct perf_raw_record          *raw;> +       struct pt_regs                  *regs;>  };>>  static inline> Index: linux-2.6/kernel/perf_event.c> ===================================================================> --- linux-2.6.orig/kernel/perf_event.c> +++ linux-2.6/kernel/perf_event.c> @@ -3176,6 +3176,17 @@ void perf_output_sample(struct perf_outp>        if (sample_type & PERF_SAMPLE_READ)>                perf_output_read(handle, event);>> +       if (sample_type & PERF_SAMPLE_REGS) {> +               int size = DIV_ROUND_UP(sizeof(struct pt_regs), sizeof(u64)) -> +                          sizeof(struct pt_regs);> +> +               perf_output_put(handle, *data->regs);> +               if (size) {> +                       u64 zero = 0;> +                       perf_output_copy(handle, &zero, size);> +               }> +       }> +>        if (sample_type & PERF_SAMPLE_CALLCHAIN) {>                if (data->callchain) {>                        int size = 1;> @@ -3273,6 +3284,12 @@ void perf_prepare_sample(struct perf_eve>        if (sample_type & PERF_SAMPLE_READ)>                header->size += perf_event_read_size(event);>> +       if (sample_type & PERF_SAMPLE_REGS) {> +               data->regs = regs;> +               header->size += DIV_ROUND_UP(sizeof(struct pt_regs),> +                                            sizeof(u64));> +       }> +>        if (sample_type & PERF_SAMPLE_CALLCHAIN) {>                int size = 1;>>> -->>


-- Stephane Eranian  | EMEA Software EngineeringGoogle France | 38 avenue de l'Opéra | 75002 ParisTel : +33 (0) 1 42 68 53 00This email may be confidential or privileged. If you received thiscommunication by mistake, pleasedon't forward it to anyone else, please erase all copies andattachments, and please let me know thatit went to the wrong person. Thanks���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
