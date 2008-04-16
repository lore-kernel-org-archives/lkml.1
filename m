Return-Path: <linux-kernel-owner+w=401wt.eu-S1764686AbYDPVDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764686AbYDPVDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYDPVC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:02:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYDPVC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:02:57 -0400
Message-ID: <480668D8.1080706@redhat.com>
Date: Wed, 16 Apr 2008 17:00:08 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: penberg@cs.helsinki.fi, zanussi@comcast.net, dwilder@us.ibm.com,
       systemtap@sources.redhat.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com
Subject: Re: [PATCH -mm] relayfs: support larger relay buffer take 3
References: <4804C95F.2080204@redhat.com>	<1208319769.7893.16.camel@charm-linux>	<48063F80.9060404@redhat.com>	<Pine.LNX.4.64.0804162110070.19171@sbz-30.cs.Helsinki.FI>	<480646B2.9000905@redhat.com>	<480658DC.6030507@redhat.com> <20080416134805.fdd139c1.akpm@linux-foundation.org>
In-Reply-To: <20080416134805.fdd139c1.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton wrote:
> On Wed, 16 Apr 2008 15:51:56 -0400
> Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> +static struct page **relay_alloc_page_array(unsigned int n_pages)
>> +{
>> +	struct page **array;
>> +	unsigned int pa_size = n_pages * sizeof(struct page *);
>> +
>> +	if (pa_size > PAGE_SIZE) {
>> +		array = vmalloc(pa_size);
>> +		if (array)
>> +			memset(array, 0, pa_size);
>> +	} else {
>> +		array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
>> +	}
>> +	return array;
>> +}
> 
> It's a bit odd to multiply n_pages*sizeof() and to then call kcalloc(),
> which needs to do the same multiplication.
> 
> The compiler will presumably optimise that away, but still, how about this?

Sure, it looks good to me.
Thank you so much,

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> --- a/kernel/relay.c~relayfs-support-larger-relay-buffer-take-3-cleanup
> +++ a/kernel/relay.c
> @@ -71,14 +71,14 @@ static struct vm_operations_struct relay
>  static struct page **relay_alloc_page_array(unsigned int n_pages)
>  {
>  	struct page **array;
> -	unsigned int pa_size = n_pages * sizeof(struct page *);
> +	size_t pa_size = n_pages * sizeof(struct page *);
>  
>  	if (pa_size > PAGE_SIZE) {
>  		array = vmalloc(pa_size);
>  		if (array)
>  			memset(array, 0, pa_size);
>  	} else {
> -		array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
> +		array = kzalloc(pa_size, GFP_KERNEL);
>  	}
>  	return array;
>  }
> _
> 
> 
> size_t is strictly the correct type for pa_size here.  Even though
> vmalloc() takes a ulong.

Thanks for the advice,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

