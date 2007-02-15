Return-Path: <linux-kernel-owner+w=401wt.eu-S964964AbXBOHW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964AbXBOHW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 02:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964965AbXBOHW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 02:22:26 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37665 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964964AbXBOHWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 02:22:25 -0500
Date: Wed, 14 Feb 2007 23:21:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, systemtap@sources.redhat.com,
       ltt-dev@shafik.org
Subject: Re: [PATCH 02/05] Linux Kernel Markers, architecture independant
 code.
Message-Id: <20070214232137.7aa86259.akpm@linux-foundation.org>
In-Reply-To: <11712242074091-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca>
	<11712242074091-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Feb 2007 15:03:24 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Linux Kernel Markers, architecture independant code.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> ...
>
> +
> +#ifndef MARK
> +#define MARK GEN_MARK
> +#define MARK_ENABLE_TYPE GEN_MARK_ENABLE_TYPE
> +#define MARK_ENABLE_IMMEDIATE_OFFSET GEN_MARK_ENABLE_IMMEDIATE_OFFSET
> +#endif

Also perhaps this nastiness can go away once each architecture has
asm/marker.h?

> +#ifdef MARK_POLYMORPHIC

What's this?  Is it commented somewhere?  (It should be...)

> +static int marker_set_ins_enable(void *address, char enable)
> +{
> +#ifdef CONFIG_X86_32
> +	return arch_marker_set_ins_enable(address, enable);
> +#else
> +	char newi[MARK_ENABLE_IMMEDIATE_OFFSET+1];
> +	int size = MARK_ENABLE_IMMEDIATE_OFFSET+sizeof(MARK_ENABLE_TYPE);
> +
> +	memcpy(newi, address, size);
> +	MARK_ENABLE(&newi[0]) = enable;
> +	memcpy(address, newi, size);
> +	flush_icache_range((unsigned long)address, size);
> +	return 0;
> +#endif //CONFIG_X86_32
> +}

eww.  Can we put a suitable arch_marker_set_ins_enable() into each arch's
marker.h?

> +#else
> +static int marker_set_ins_enable(void *address, char enable)
> +{
> +	return -EPERM;
> +}
> +#endif //MARK_POLYMORPHIC
> +
>
> ...
>

