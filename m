Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYFTTGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYFTTGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYFTTGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:06:46 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34557 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752819AbYFTTGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:06:46 -0400
Message-ID: <485BFFC5.6020404@sgi.com>
Date: Fri, 20 Jun 2008 12:06:45 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org> <Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com> <485BF8F5.6010802@goop.org>
In-Reply-To: <485BF8F5.6010802@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>
> 
> BTW, I think __per_cpu_load will cause trouble if you make a relocatable
> kernel, being an absolute symbol.  But I have relocation off at the moment.
> 
...
Here's where it's defined (in include/asm-generic/vmlinux.lds.h):

#ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
#define PERCPU(align)                                                   \
        . = ALIGN(align);                                               \
        percpu : { } :percpu                                            \
        __per_cpu_load = .;                                             \
        .data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {             \
                *(.data.percpu.first)                                   \
                *(.data.percpu.shared_aligned)                          \
                *(.data.percpu)                                         \
                *(.data.percpu.page_aligned)                            \
                ____per_cpu_size = .;                                   \
        }                                                               \
        . = __per_cpu_load + ____per_cpu_size;                          \
        data : { } :data
#else

Can we generate a new symbol which would account for LOAD_OFFSET?
