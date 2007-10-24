Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbXJXSKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbXJXSKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbXJXSKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:10:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41517 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbXJXSKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:10:03 -0400
Message-ID: <471F8A24.70907@oracle.com>
Date: Wed, 24 Oct 2007 14:08:36 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Corporate Architecture team, Oracle USA
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] NET: Make ts_recent_stamp unsigned
References: <20071023154428.28115.10406.stgit@ingres.1015granger.net> <20071023.210006.28787642.davem@davemloft.net>
In-Reply-To: <20071023.210006.28787642.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------030708090605070902070602"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030708090605070902070602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> Date: Tue, 23 Oct 2007 11:44:28 -0400
> 
>> The get_seconds() function returns an unsigned long.  To prevent incorrect
>> comparison results between values saved in ts_recent_stamp and later
>> invocations of get_seconds(), change the type of ts_recent_stamp to match
>> the return type of get_seconds().
>>
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> Cc: <netdev@vger.kernel.org>
> 
> I see two potential problems with this patch:
> 
> 1) If you update struct tcp_options_received you should also
>    update struct tcp_timewait_sock similarly.
> 
>    The fact that you missed this suggests that you didn't
>    grep the tree to see how else this variable is used and
>    this makes me extra concerned about this patch's correctness.

Perhaps the result of wishful thinking on my part.  I was hoping for a 
small and self-contained change.

> 2) There are computations in the TCP stack using this member that
>    probably care about the signedness, such as:
> 
> net/ipv4/tcp_ipv4.c:			     get_seconds() - tcptw->tw_ts_recent_stamp > 1))) {
> include/net/tcp.h:	if (get_seconds() >= rx_opt->ts_recent_stamp + TCP_PAWS_24DAYS)
> include/net/tcp.h:	if (get_seconds() >= rx_opt->ts_recent_stamp + TCP_PAWS_24DAYS)
> 
>    We should make sure we understand what is expected here, and
>    why it would still be correct after making both ts_recent_stamp
>    members unsigned.

Agreed.

I wonder how one could construct a series of mixed case time stamp 
comparisons *on purpose* (and without documentation of this assumption) 
that produces consistently correct results.

 From the invocations of get_seconds() that I sampled, the design of 
these comparisons seems to assume that both sides of the comparison are 
non-negative.  However, they do not seem to account for time crossing zero.

--------------030708090605070902070602
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
email;internet:chuck dot lever at nospam oracle dot com
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------030708090605070902070602--
