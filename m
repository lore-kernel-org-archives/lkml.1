Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZA1Adm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZA1Adm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZA1Adb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:33:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:45643 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZA1Adb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:33:31 -0500
Message-ID: <497FA7DD.5000105@kernel.org>
Date: Wed, 28 Jan 2009 09:33:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] x86: uv cleanup
References: <E1LRy9o-0005WD-7N@eag09.americas.sgi.com>
In-Reply-To: <E1LRy9o-0005WD-7N@eag09.americas.sgi.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 00:33:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman wrote:
> I appreciate your consolidation and cleanup of the UV code, relative
> to 32 vs 64.
> 
> I have a question about the addition of the
>         WARN_ON(!in_atomic());
> in uv_flush_tlb_others().
> The patch is
> http://marc.info/?l=linux-kernel&m=123252788121855&w=2
> 
> I expect this function to always entered preemptable.  
> Could you explain a bit about your thought behind this WARN_ON?

The function needs to return modified cpumask.  Before the patch, this
was achieved by the caller disabling preemption and pass modifiable
per-cpu cpumask and allowing uv code to modify it in place.  After the
patch, to put uv code in uv proper (so that the generic code doesn't
have to allocate percpu cpumask for it), this is moved into the uv
function.  The caller disables preemtion and uses the returned cpumask
which might or might not be the same array it gave to the function and
the array is guaranteed to be valid until preemption is re-enabled.
The meachnism itself isn't different.  Only what's done where has
changed to make it more modular.  More specifically, when uv is not
needed, the generic code can simply omit the uv related part including
the percpu cpumask allocation.

Thanks.

-- 
tejun
