Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZHNSqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZHNSqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 14:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZHNSqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 14:46:49 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:38454 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbZHNSqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 14:46:48 -0400
X-Greylist: delayed 3305 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Aug 2009 14:46:48 EDT
Message-ID: <4A85B167.5000803@colorfullife.com>
Date: Fri, 14 Aug 2009 20:48:07 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: npiggin@suse.de
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] ipc: sem optimise simple operations
References: <20090811110902.255877673@suse.de> <20090811111607.310739140@suse.de>
In-Reply-To: <20090811111607.310739140@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 01:09 PM, npiggin@suse.de wrote:
> @@ -438,23 +448,94 @@ again:
>   			continue;
>
>   		list_del(&q->list);
> +		if (q->nsops == 1)
> +			list_del(&q->simple_list);
> +		else
> +			sma->complex_count--;
> +
> +		alter = q->alter;
> +		wake_up_sem_queue(q, error);
>    
Unlink approach one: list_del() only if q->nsops!=1.

@@ -532,6 +613,9 @@ static void freeary(struct ipc_namespace
>   	/* Wake up all pending processes and let them fail with EIDRM. */
>   	list_for_each_entry_safe(q, tq,&sma->sem_pending, list) {
>   		list_del(&q->list);
> +		list_del(&q->simple_list);
> +		if (q->nsops>  1)
> +			sma->complex_count--;
>    
Unlink approach two: list_del() even if q->nsops==1.
[i.e.: rely on list_del() on an empty list is permitted].

I would merge that into a helper function.

--
     Manfred
