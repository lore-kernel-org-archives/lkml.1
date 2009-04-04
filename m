Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbZDDAWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbZDDAWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759565AbZDDAVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:21:54 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60852 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZDDAVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:21:53 -0400
Message-ID: <49D6A81B.8030004@linux.vnet.ibm.com>
Date: Fri, 03 Apr 2009 17:21:47 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 6/6] perf_counter: kerneltop: output event support
References: <20090325113021.781490788@chello.nl> <20090325113317.192910290@chello.nl>
In-Reply-To: <20090325113317.192910290@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I was stealing code from kerneltop today to use in the PAPI profiling 
implementation, I ran across the code below:

Peter Zijlstra wrote:
> Teach kerneltop about the new output ABI.
> 
> XXX: anybody fancy integrating the PID/TID data into the output?
> 
> Bump the mmap_data pages a little because we bloated the output and
> have to be more careful about overruns with structured data.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
[snip]

> 
> @@ -1147,28 +1152,75 @@ static void mmap_read(struct mmap_data *
>  	unsigned int head = mmap_read_head(md);
>  	unsigned int old = md->prev;
>  	unsigned char *data = md->base + page_size;
> +	int diff;
> 
>  	gettimeofday(&this_read, NULL);
> 
> -	if (head - old > md->mask) {
> +	/*
> +	 * If we're further behind than half the buffer, there's a chance
> +	 * the writer will bite our tail and screw up the events under us.
> +	 *
> +	 * If we somehow ended up ahead of the head, we got messed up.
> +	 *
> +	 * In either case, truncate and restart at head.
> +	 */
> +	diff = head - old;
> +	if (diff > md->mask / 2 || diff < 0) {
>  		struct timeval iv;
>  		unsigned long msecs;
> 
>  		timersub(&this_read, &last_read, &iv);
>  		msecs = iv.tv_sec*1000 + iv.tv_usec/1000;
> 
> -		fprintf(stderr, "WARNING: failed to keep up with mmap data.  Last read %lu msecs ago.\n", msecs);
> +		fprintf(stderr, "WARNING: failed to keep up with mmap data."
> +				"  Last read %lu msecs ago.\n", msecs);
> 
[snip]

The test for diff < 0 looks incorrect to me.  This shouldn't be an 
error, because it will frequently be the case that the head has wrapped 
around back to the beginning of the mmap'd pages, while old is near the end.

What it needs to find out, I think, is if the modulo distance between 
old and head is greater than 1/2 of the span of the mmap'd pages. 
Here's a suggested change:

-	diff = head - old;
+	diff = (head - old) & md->mask;
-	if (diff > md->mask / 2 || diff < 0) {
+	if (diff > md->mask / 2) {


What do you think?

- Corey

