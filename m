Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYFXACT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYFXACT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYFXACK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:02:10 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54812 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752228AbYFXACJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:02:09 -0400
Message-ID: <4860397F.305@sgi.com>
Date: Mon, 23 Jun 2008 17:02:07 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com>	<485947A8.8060801@goop.org> <4859511E.5050605@sgi.com>	<48596315.6020104@goop.org> <48596893.4040908@sgi.com>	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>	<485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com> <m1skv7onvh.fsf@frodo.ebiederm.org> <485FD56B.1090303@sgi.com> <485FDE80.1010700@goop.org> <485FE5C9.3050305@sgi.com> <485FED2C.8030102@sgi.com> <485FFC61.9030301@goop.org>
In-Reply-To: <485FFC61.9030301@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Mike Travis wrote:
>> The syntax error is at this "DATA(0)" statement.  I don't find this as a
>> linker script command or a macro.  What is it we're trying to do with
>> this?
>>   
> 
> In Eric's sample, it's intended to prevent there being an empty section,
> which can cause linker bugs.  In your case it probably isn't necessary,
> since you're also putting the percpu data in that section.
> 
> "DATA" is probably a typo.  It should be "LONG" or something like that. 
> (See "3.6.5 Output Section Data" in the linker manual.)
> 
>    J

Yes, thanks I did find that.

I now have the version below which seems to have what we need... but it
hasn't had an effect on the boot startup panic.  I'm back to verifying
that the assembler effective addresses are correct in the loaded object.

ffffffff81911000 D __per_cpu_load
0000000000000000 D per_cpu__pda
0000000000000080 D per_cpu__init_tss
.
.
000000000000a2d0 d per_cpu__cookie_scratch
000000000000a470 d per_cpu__cookie_scratch
000000000000a604 D ____per_cpu_size

Btw, the "percpu : { } :percpu" below removes a linker warning about an empty
section.

#ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
#define PERCPU(align)							\
	.data.percpu.abs = .;						\
	percpu : { } :percpu						\
	.data.percpu.header : AT(.data.percpu.abs - LOAD_OFFSET) {	\
		BYTE(0)							\
		. = ALIGN(align);					\
		__per_cpu_load = .;					\
	}								\
	.data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {		\
		*(.data.percpu.first)					\
		*(.data.percpu.shared_aligned)				\
		*(.data.percpu)						\
		*(.data.percpu.page_aligned)				\
		____per_cpu_size = .;					\
	}								\
	. = __per_cpu_load + ____per_cpu_size;
