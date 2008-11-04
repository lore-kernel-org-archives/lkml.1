Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbYKDShj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbYKDShj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYKDShb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:37:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:59941 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYKDSha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:37:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IMcVz0wWPglt/TSjb/MsKJvozZgMV64qfDz3xUs/jp+LvIiePz/M+v4DZvVqKPupVL
         lJKSVYnv1qZpYOlte7RFRoqMbGCRwfiV/F7keJTTcemy7X3hAPG/jFRcmxECwVfKqgPk
         VQXBOwThwhaPGK0SQBQ2uWQWMbXYT6RK2dkh0=
Message-ID: <49109657.3000601@gmail.com>
Date: Tue, 04 Nov 2008 20:37:11 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
 belongs to. Store thread group leader id, and use it to lookup the address
 in the process's map. We could have looked up the address on thread's map,
 but the thread might not exist by the time we are called. The process might
 not exist either, but if you are reading trace_pipe, that is unlikely.
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081102212512.GF28946@ZenIV.linux.org.uk> <490E1B74.6010904@gmail.com> <20081102214042.GG28946@ZenIV.linux.org.uk> <20081103073257.GA13727@elte.hu> <20081104182628.GA6666@infradead.org>
In-Reply-To: <20081104182628.GA6666@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-04 20:26, Christoph Hellwig wrote:
> On Mon, Nov 03, 2008 at 08:32:57AM +0100, Ingo Molnar wrote:
>   
>> could you please help out with such a helper? This is really about 
>> visualization, not to rely on it.
>>     
>
> Is this kindergarten?  Take a look at seq_path - what you want
> is the combination of d_path + mangle_path and the combination of two
> would be rather trivial.  In fact I'd say you don't even need the helper
> but just make mangle_path global (and document it while you're at it)
> and then use it.

Hmm, this is just for visualizing things in /sys/kernel/debug/, can't I
use something simpler than mangle_path, such as a simple while loop like
the one below?

+ static int
+trace_seq_path(struct trace_seq *s, struct path *path)
+{
+       char *p;
+
+       if (s->len >= (PAGE_SIZE - 1))
+               return 0;
+       p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
+       if (!IS_ERR(p)) {
+               size_t i = s->len;
+               char c;
+               while ((c = *p++)) {
+                       if (c != '\n')
+                               s->buffer[i++] = c;
+               }
+               s->len = i;
+               return 1;
+       } else {
+               s->buffer[s->len++] = '?';
+               return 1;
+       }
+
+       return 0;
+}
