Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbZDGTKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbZDGTKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758426AbZDGTJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:09:51 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:40113 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbZDGTJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jF7inaWGQxofL0boAC8As+DX2cjGURARQXO4sO5wDBX+3cbECnLaaBhBVux+Eg3wdD
         9PZH5TDvzDPEEiH5Z6AmLxFB3paPD1tmi3M4q4nLcGEk2Td/Bj23Y9MD3m+/KhvPyeJ0
         eoNxRqz/ypwfJE/ljfn6neDXjceP6FtYpn4og=
MIME-Version: 1.0
In-Reply-To: <49DBA23A.3000106@cs.helsinki.fi>
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>
	 <49DBA23A.3000106@cs.helsinki.fi>
Date: Tue, 7 Apr 2009 22:09:46 +0300
X-Google-Sender-Auth: 95bcda7735aea0e9
Message-ID: <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com>
Subject: Re: [patch] slub: default min_partial to at least highest cpus per 
	node
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
>> The pre-defined MIN_PARTIAL value may not be suitable for machines with a
>> large number of cpus per node.  To avoid excessively allocating new slabs
>> because there is not at least the same number of slabs on a node's
>> partial list as cpus, this will default a cache's min_partial value to be
>> at least the highest number of cpus per node on the system.
>>
>> This default will never exceed MAX_PARTIAL, however, so very large
>> systems don't waste an excessive amount of memory.
>>
>> When remote_node_defrag_ratio allows defragmenting remote nodes, it
>> ensures that nr_partial exceeds min_partial so there will always be a
>> local reserve when a cpu slab is filled to avoid allocating new slabs
>> locally as a result of a remote cpu stealing a partial slab.
>>
>> The cache's min_partial setting may still be changed by writing to
>> /sys/kernel/slab/cache/min_partial.  The only restriction when doing so
>> is that the value be within MIN_PARTIAL and MAX_PARTIAL.
>>
>> Cc: Christoph Lameter <cl@linux-foundation.org>
>> Signed-off-by: David Rientjes <rientjes@google.com>

On Tue, Apr 7, 2009 at 9:58 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hmm, partial lists are per-node, so wouldn't it be better to do the
> adjustment for every struct kmem_cache_node separately? The
> 'min_partial_per_node' global seems just too ugly and confusing to live
> with.

Btw, that requires moving ->min_partial to struct kmem_cache_node from
struct kmem_cache.  But I think that makes a whole lot of sense if
some nodes may have more CPUs than others.

And while the improvement is kinda obvious, I would be interested to
know what kind of workload benefits from this patch (and see numbers
if there are any).

                                  Pekka
