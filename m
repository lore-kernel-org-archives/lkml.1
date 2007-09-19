Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbXISWSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbXISWSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbXISWS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:18:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbXISWS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:18:26 -0400
Date: Wed, 19 Sep 2007 15:17:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: use pagevec to rotate reclaimable page
Message-Id: <20070919151745.1e12a671.akpm@linux-foundation.org>
In-Reply-To: <6.0.0.20.2.20070918193944.038e2ea0@172.19.0.2>
References: <6.0.0.20.2.20070907113025.024dfbb8@172.19.0.2>
	<20070913193711.ecc825f7.akpm@linux-foundation.org>
	<6.0.0.20.2.20070918193944.038e2ea0@172.19.0.2>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 19:41:14 +0900
Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

>  >
>  >So I do think that for safety and sanity's sake, we should be taking a ref
>  >on the pages when they are in a pagevec.  That's going to hurt your nice
>  >performance numbers :(
>  >
> 
> I did ping test again to observe performance deterioration caused by taking 
> a ref.
> 
> 	-2.6.23-rc6-with-modifiedpatch
> 	--- testmachine ping statistics ---
> 	3000 packets transmitted, 3000 received, 0% packet loss, time 53386ms
> 	rtt min/avg/max/mdev = 0.074/0.110/4.716/0.147 ms, pipe 2, ipg/ewma 
> 17.801/0.129 ms
> 
> The result for my original patch is as follows.
> 
> 	-2.6.23-rc5-with-originalpatch
> 	--- testmachine ping statistics ---
> 	3000 packets transmitted, 3000 received, 0% packet loss, time 51924ms
> 	rtt min/avg/max/mdev = 0.072/0.108/3.884/0.114 ms, pipe 2, ipg/ewma 
> 17.314/0.091 ms
> 
> 
> The influence to response was small.

well.. that's not really the test which will show up any regressions.

The extra get_page/put_page will affect things like kernel CPU utilisation
on fast writeout on a single CPU.  Say, run a huge write against a fast
storage system on a single pentium 4 CPU and see how much the system CPU
time is increased.

The kernel's internal cpu accounting probably won't be accurate enough to
get believeable numbers from a test like this - better to use the
subtractive approach: see http://www.zipworld.com.au/~akpm/linux/#zc
