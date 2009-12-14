Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbZLNOea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbZLNOea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZLNOe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:34:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZLNOe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:34:28 -0500
Message-ID: <4B264CCA.5010609@redhat.com>
Date: Mon, 14 Dec 2009 09:33:46 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 4/8] Use prepare_to_wait_exclusive() instead prepare_to_wait()
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com> <20091214212936.BBBA.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091214212936.BBBA.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 07:30 AM, KOSAKI Motohiro wrote:
> if we don't use exclusive queue, wake_up() function wake _all_ waited
> task. This is simply cpu wasting.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

>   		if (zone_watermark_ok(zone, sc->order, low_wmark_pages(zone),
>   					0, 0)) {
> -			wake_up(wq);
> +			wake_up_all(wq);
>   			finish_wait(wq,&wait);
>   			sc->nr_reclaimed += sc->nr_to_reclaim;
>   			return -ERESTARTSYS;

I believe we want to wake the processes up one at a time
here.  If the queue of waiting processes is very large
and the amount of excess free memory is fairly low, the
first processes that wake up can take the amount of free
memory back down below the threshold.  The rest of the
waiters should stay asleep when this happens.

-- 
All rights reversed.
