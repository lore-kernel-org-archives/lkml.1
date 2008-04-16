Return-Path: <linux-kernel-owner+w=401wt.eu-S1765790AbYDPVAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765790AbYDPVAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbYDPVA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:00:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbYDPVA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:00:27 -0400
Date: Wed, 16 Apr 2008 13:48:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: penberg@cs.helsinki.fi, zanussi@comcast.net, dwilder@us.ibm.com,
       systemtap@sources.redhat.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com
Subject: Re: [PATCH -mm] relayfs: support larger relay buffer take 3
Message-Id: <20080416134805.fdd139c1.akpm@linux-foundation.org>
In-Reply-To: <480658DC.6030507@redhat.com>
References: <4804C95F.2080204@redhat.com>
	<1208319769.7893.16.camel@charm-linux>
	<48063F80.9060404@redhat.com>
	<Pine.LNX.4.64.0804162110070.19171@sbz-30.cs.Helsinki.FI>
	<480646B2.9000905@redhat.com>
	<480658DC.6030507@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 15:51:56 -0400
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> +static struct page **relay_alloc_page_array(unsigned int n_pages)
> +{
> +	struct page **array;
> +	unsigned int pa_size = n_pages * sizeof(struct page *);
> +
> +	if (pa_size > PAGE_SIZE) {
> +		array = vmalloc(pa_size);
> +		if (array)
> +			memset(array, 0, pa_size);
> +	} else {
> +		array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
> +	}
> +	return array;
> +}

It's a bit odd to multiply n_pages*sizeof() and to then call kcalloc(),
which needs to do the same multiplication.

The compiler will presumably optimise that away, but still, how about this?

--- a/kernel/relay.c~relayfs-support-larger-relay-buffer-take-3-cleanup
+++ a/kernel/relay.c
@@ -71,14 +71,14 @@ static struct vm_operations_struct relay
 static struct page **relay_alloc_page_array(unsigned int n_pages)
 {
 	struct page **array;
-	unsigned int pa_size = n_pages * sizeof(struct page *);
+	size_t pa_size = n_pages * sizeof(struct page *);
 
 	if (pa_size > PAGE_SIZE) {
 		array = vmalloc(pa_size);
 		if (array)
 			memset(array, 0, pa_size);
 	} else {
-		array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
+		array = kzalloc(pa_size, GFP_KERNEL);
 	}
 	return array;
 }
_


size_t is strictly the correct type for pa_size here.  Even though
vmalloc() takes a ulong.

