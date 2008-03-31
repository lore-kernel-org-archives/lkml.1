Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbYCaVBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbYCaVBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYCaVBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:01:00 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:24907 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbYCaVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FYdwBB1/T7lsGFFoHgBQSquN0+mye1KkYr4QH3ZMQZrbsHxgZUcFMwePpLlkv/FgAq1jO7wL4GAWZWMLq5S2Q+K+RTr8/VArLQED6xoZ/rs5Hdk4vKca6+YhQfskAJTH3ZP1m3EeOJay0M0GuUbRst0SWekc02KU8BK1pYZSSco=
Message-ID: <84144f020803311400s1f34420dx153d197f4752c65e@mail.gmail.com>
Date: Tue, 1 Apr 2008 00:00:55 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>
Subject: Re: [RFC PATCH 25/26] UBIFS: add debugging stuff
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Adrian Hunter" <ext-adrian.hunter@nokia.com>
In-Reply-To: <1206629746-4298-26-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <1206629746-4298-26-git-send-email-Artem.Bityutskiy@nokia.com>
X-Google-Sender-Auth: 9e00a2b44b4bafea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Thu, Mar 27, 2008 at 5:55 PM, Artem Bityutskiy
<Artem.Bityutskiy@nokia.com> wrote:
> The UBIFS code is large, and we have a plenty of debugging stuff
>  in there which helps to catch bugs. Some of the debugging stuff
>  will be deleted later.

Yes please. The code is somewhat noisy on the debugging side.

On Thu, Mar 27, 2008 at 5:55 PM, Artem Bityutskiy
<Artem.Bityutskiy@nokia.com> wrote:
>  +void *dbg_kmalloc(size_t size, gfp_t flags)
>  +
>  +void *dbg_kzalloc(size_t size, gfp_t flags)
>  +
>  +void dbg_kfree(const void *addr)
>  +
>  +void *dbg_vmalloc(size_t size)
>  +
>  +void dbg_vfree(void *addr)
>  +
>  +void dbg_leak_report(void)

Not acceptable for mainline kernel. SLAB already provides leak
detection and it should be straight-forward to port over to SLUB too.

>  +/*
>  + * struct eaten_memory - memory object eaten by UBIFS to cause memory pressure.
>  + * @list: link in the list of eaten memory objects
>  + * @pad: just pads to memory page size
>  + */
>  +struct eaten_memory {
>  +       struct list_head list;
>  +       uint8_t pad[PAGE_CACHE_SIZE - sizeof(struct list_head)];
>  +};

If you need this, please make it a standalone module in mm/.

>  +void dbg_eat_memory(void)
>  +{
>  +       struct eaten_memory *em;
>  +
>  +       em = kmalloc(sizeof(struct eaten_memory), GFP_NOFS);

It's probably better to use the page allocator for this.

>  +#ifdef CONFIG_UBIFS_FS_DEBUG
>  +#define UBIFS_DBG(op) op
>  +#define ubifs_assert(expr)  do {                                               \
>  +
>  +/* Generic debugging message */
>  +#define dbg_msg(fmt, ...) do {                                                 \
>  +
>  +/* Debugging message which prints UBIFS key */
>  +#define dbg_key(c, key, fmt, ...) do {                                         \
>  +
>  +#define dbg_err(fmt, ...) ubifs_err(fmt, ##__VA_ARGS__)
>  +#define dbg_dump_stack() dump_stack()

Please kill these wrappers and use BUG_ON, WARN_ON, and printk() where
appropriate.
