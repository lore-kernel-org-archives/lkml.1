Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbYLAGtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbYLAGtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYLAGtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:49:40 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:27036 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYLAGtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=mETSxFEKc96uNLRrtar2N+J9RaRs/prG4d0lq2MTADleQylKAHmOAQo1NJQpWCw3FK
         llPkLbtRYupCKi1oocw19ze7XdLzm+NdS3MBu0rctarE1N38K33qGJOiNWoxBU6qGSyp
         ZVTOkVB1ucpAIcU0ygBr/2iRzANRq/Yh6RliM=
Message-ID: <84144f020811302249i7587662ewa621d0a81f5426a2@mail.gmail.com>
Date: Mon, 1 Dec 2008 08:49:38 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
Cc: "Catalin Marinas" <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081201142824.D552.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
	 <20081129104312.16726.36218.stgit@pc1117.cambridge.arm.com>
	 <20081201142824.D552.E1E9C6FF@jp.fujitsu.com>
X-Google-Sender-Auth: d14bd90721ad615d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, Dec 1, 2008 at 7:39 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> +/*
>> + * Insert a pointer into the pointer hash table.
>> + */
>> +static inline void create_object(unsigned long ptr, size_t size, int ref_count)
>> +{
>> +     unsigned long flags;
>> +     struct memleak_object *object;
>> +     struct prio_tree_node *node;
>> +     struct stack_trace trace;
>> +
>> +     object = kmem_cache_alloc(object_cache, GFP_ATOMIC);
>> +     if (!object)
>> +             panic("kmemleak: cannot allocate a memleak_object structure\n");
>
> IIRC, GFP_ATOMIC allocation sometimes fails. (ex. when page cache occupies all
> area). It seems to be easy to panic. Is it intended?

Yup, GFP_ATOMIC can fail as can any memory allocation on out-of-memory
conditions unless you specify GFP_NOFAIL which will either succeed or
lock up the box. I think you can just WARN_ON() here? However, it's
probably safer to pass gfp flags from the callers here; otherwise we
end up doing tons of GFP_ATOMIC allocations which is not healthy in
general.

Also, I see some other BUG_ON() calls in the code which probably
should be converted to WARN_ON() as well.
