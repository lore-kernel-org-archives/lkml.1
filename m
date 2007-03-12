Return-Path: <linux-kernel-owner+w=401wt.eu-S965400AbXCLJIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400AbXCLJIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965404AbXCLJIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:08:23 -0400
Received: from phpmyadmin.profiwh.com ([85.93.165.67]:42588 "EHLO
	cacti.profiwh.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965397AbXCLJIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:08:22 -0400
Message-ID: <45F5188D.4030106@gmail.com>
Date: Mon, 12 Mar 2007 10:08:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>  <45E996A0.6070700@gmail.com> <45E99A45.9030506@gmail.com>  <20070303094125.838ce04d.akpm@linux-foundation.org>  <45F13791.8040408@gmail.com> <d120d5000703090613v2923e9c1k8389b566257daa43@mail.gmail.com> <Pine.LNX.4.64.0703091531280.26904@twin.jikos.cz> <Pine.LNX.4.64.0703091658350.26904@twin.jikos.cz> <45F4770F.4090902@gmail.com> <Pine.LNX.4.64.0703112243560.26904@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0703112243560.26904@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina napsal(a):
> On Sun, 11 Mar 2007, Jiri Slaby wrote:
> 
>>> -	/* make sure the unused bits in the last byte are zeros */
>>> -	if (count > 0 && size > 0)
>>> -		data[(offset+count*size-1)/8] = 0;
>>> -
>> No, this doesn't help -- -rc3-mm2 minus this behaves exactly the same. 
[...]
> Otherwise, would you care to bisect?

Bisecting figured out the culprit:
Commit: 17230acdc71137622ca7dfd789b3944c75d39404
Author: Alan Stern <stern@rowland.harvard.edu> Mon, 19 Feb 2007 15:52:45 -0500

     UHCI: Eliminate asynchronous skeleton Queue Headers

     This patch (as856) attempts to improve the performance of uhci-hcd by
     removing the asynchronous skeleton Queue Headers.  They don't contain
     any useful information but the controller has to read through them at
     least once every millisecond, incurring a non-zero DMA overhead.

     Now all the asynchronous queues are combined, along with the period-1
     interrupt queue, into a single list with a single skeleton QH.  The
     start of the low-speed control, full-speed control, and bulk sublists
     is determined by linear search.  Since there should rarely be more
     than a couple of QHs in the list, the searches should incur a much
     smaller total load than keeping the skeleton QHs.

     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


-mm minus (only) this one is OK.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
