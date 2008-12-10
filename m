Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbYLJAgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbYLJAgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 19:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYLJAgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 19:36:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64961 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYLJAgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 19:36:41 -0500
Message-ID: <493F0E57.7090206@cn.fujitsu.com>
Date: Wed, 10 Dec 2008 08:33:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Tom Zanussi <zanussi@comcast.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Relay : fix cpu offline problem
References: <20081209162512.GB24039@Krystal>
In-Reply-To: <20081209162512.GB24039@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mathieu Desnoyers

I have fixed this problem in mainline.
http://lkml.org/lkml/2008/11/14/74

Lai

Mathieu Desnoyers wrote:
> Here is a fix for how relay handles cpu hotplug in the allocation error path. If
> a cpu goes down while allocating, it may result in a buffer never being freed.
> 
> Lai Jiangshan originally identified this problem in the LTTng fork of
> relay (ltt-relay-alloc). Here is the fix which applies to the original
> kernel/relay.c.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Lai Jiangshan <laijs@cn.fujitsu.com>
> CC: Tom Zanussi <zanussi@comcast.net>
> ---
>  kernel/relay.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6-lttng/kernel/relay.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/relay.c	2008-12-09 10:58:45.000000000 -0500
> +++ linux-2.6-lttng/kernel/relay.c	2008-12-09 11:09:58.000000000 -0500
> @@ -611,10 +611,9 @@ struct rchan *relay_open(const char *bas
>  	return chan;
>  
>  free_bufs:
> -	for_each_online_cpu(i) {
> -		if (!chan->buf[i])
> -			break;
> -		relay_close_buf(chan->buf[i]);
> +	for_each_possible_cpu(i) {
> +		if (chan->buf[i])
> +			relay_close_buf(chan->buf[i]);
>  	}
>  
>  	kref_put(&chan->kref, relay_destroy_channel);


