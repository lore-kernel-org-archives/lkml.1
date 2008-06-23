Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbYFWSgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbYFWSgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbYFWSga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:36:30 -0400
Received: from relay2.sgi.com ([192.48.171.30]:55318 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754611AbYFWSg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:36:29 -0400
Message-ID: <485FED2C.8030102@sgi.com>
Date: Mon, 23 Jun 2008 11:36:28 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com>	<485947A8.8060801@goop.org> <4859511E.5050605@sgi.com>	<48596315.6020104@goop.org> <48596893.4040908@sgi.com>	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>	<485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com> <m1skv7onvh.fsf@frodo.ebiederm.org> <485FD56B.1090303@sgi.com> <485FDE80.1010700@goop.org> <485FE5C9.3050305@sgi.com>
In-Reply-To: <485FE5C9.3050305@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>>
>>>> To initialize the percpu data you do want to talk to the virtual address
>>>> at __per_coup_load.  But it is absolute Ugh. 
>>>> It might be worth saying something like.
>>>> .data.percpu.start : AT(.data.percpu.dummy - LOAD_OFFSET) {
>>>>     DATA(0)                       . = ALIGN(align);
>>>>         __per_cpu_load = . ;                   }
>>>> To make __per_cpu_load a relative symbol. ld has a bad habit of taking
>>>> symbols out of empty sections and making them absolute.  Which is why
>>>> I added the DATA(0).

The syntax error is at this "DATA(0)" statement.  I don't find this as a
linker script command or a macro.  What is it we're trying to do with this?

Thanks,
Mike
...
>>> I'm not sure I understand the linker lingo enough to fill in the rest
>>> of the blanks... I've tried various versions around this framework and
>>> none have been accepted yet.
>>>
>>> #ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
>>> #define PERCPU(align)                                                   \
>>>         .data.percpu.start : AT(.data.percpu.dummy - LOAD_OFFSET) {     \
>>>                 DATA(0)                                                 \
>>>                 . = ALIGN(align);                                       \
>>>                 __per_cpu_load = .;                                     \
>>>                 *(.data.percpu.first)                                   \
>>>                 *(.data.percpu.shared_aligned)                          \
>>>                 *(.data.percpu)                                         \
>>>                 *(.data.percpu.page_aligned)                            \
>>>                 ____per_cpu_size = . - __per_cpu_load                   \
>>>         }                                                               \
>>> #else
