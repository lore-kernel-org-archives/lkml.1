Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYC1ADg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYC1ADg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYC1ADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:03:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:8248 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbYC1ADR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:03:17 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Date: Fri, 28 Mar 2008 01:01:29 +0100
User-Agent: KMail/1.8.2
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20080327132057.449831367@polymtl.ca>
In-Reply-To: <20080327132057.449831367@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803280101.30026.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 March 2008 14:20, Mathieu Desnoyers wrote:
> Hi Andrew,
> 
> After a few RFC rounds, I propose these markers for 2.6.26. They include
> work done after comments from the memory management community. Most of them have
> been used by the LTTng project for about 2 years.

Not in this patch, but I noticed:

#define __trace_mark(name, call_private, format, args...)               \
        do {                                                            \
                static const char __mstrtab_##name[]                    \
                __attribute__((section("__markers_strings")))           \
                = #name "\0" format;                                    \
                static struct marker __mark_##name                      \
                __attribute__((section("__markers"), aligned(8))) =     \
                { __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],   \
                0, 0, marker_probe_cb,                                  \
                { __mark_empty_function, NULL}, NULL };                 \
                __mark_check_format(format, ## args);                   \
                if (unlikely(__mark_##name.state)) {                    \
                        (*__mark_##name.call)                           \
                                (&__mark_##name, call_private,          \
                                format, ## args);                       \
                }                                                       \
        } while (0)

In this call:

                        (*__mark_##name.call)                           \
                                (&__mark_##name, call_private,          \
                                format, ## args);                       \

you make gcc allocate duplicate format string. You can use
&__mstrtab_##name[sizeof(#name)] instead since it holds the same string,
or drop ", format," above and "const char *fmt" from here:

        void (*call)(const struct marker *mdata,        /* Probe wrapper */
                void *call_private, const char *fmt, ...);

since mdata->format is the same and all callees which need it can take it there.
--
vda
