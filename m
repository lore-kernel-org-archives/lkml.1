Return-Path: <linux-kernel-owner+w=401wt.eu-S932170AbXIESh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbXIESh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 14:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXIEShS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 14:37:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:19202 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXIEShO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 14:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EOUhDy5zl0eiRshEeJlnBBFcDzvfoqTpMcC4hlqcG/Kjqxlk8Yi7JZxXLWX6VPuaJ3sSxjUf6Nu+26TcKBy9K0Os40i5/rhlVYGvGJOfPCzUoE9E/5gr0uQUE1o8A5/UoyupEqg7aHu/gKGVyyop22Z4/e1Wlasz/dlaEF401rE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Date: Wed, 5 Sep 2007 19:37:03 +0100
User-Agent: KMail/1.9.1
Cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <1189009748.4442.19.camel@imap.mvista.com>
In-Reply-To: <1189009748.4442.19.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709051937.04014.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2007 17:29, Daniel Walker wrote:
> On Wed, 2007-09-05 at 14:43 +0100, Denys Vlasenko wrote:
> > Build system: section garbage collection for vmlinux
> > 
> > 
> > Newer gcc and binutils can do dead code and data removal
> > at link time. It is achieved using combination of
> > -ffunction-sections -fdata-sections options for gcc and
> > --gc-sections for ld.
> > 
> > Theory of operation:
> > 
> > Option -ffunction-sections instructs gcc to place each function
> > (including static ones) in it's own section named .text.function_name
> > instead of placing all functions in one big .text section.
> > 
> > At link time, ld normally coalesce all such sections into one
> > output section .text again. It is achieved by having *(.text.*) spec
> > along with *(.text) spec in built-in linker scripts.
> 
> You version doesn't work with CONFIG_MODULES right?

It works with CONFIG_MODULES.

> Also, why do you need this patch,
> 
> [PATCH 1/3] build system: section garbage collection for vmlinux

Because otherwise, for example, .data.percpu sections we already have
get picked up by *(.data.*), and then *(.data.percpu) end up empty:

                __per_cpu_start = .;
                       *(.data.percpu)
                       *(.data.percpu.shared_aligned)
                __per_cpu_end = .;

and all hell breaks loose.

We need to stop using sections named like

.text.xxxx
.data.xxxx
.rodata.xxxx
.bss.xxxx

--
vda
