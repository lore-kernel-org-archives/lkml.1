Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbYKXLo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbYKXLo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 06:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYKXLoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 06:44:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53714 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYKXLoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 06:44:16 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [ltt-dev] [RFC PATCH] Poll : add poll_wait_set_exclusive (fixing thundering	herd problem in LTTng)
Cc: kosaki.motohiro@jp.fujitsu.com, ltt-dev@lists.casi.polymtl.ca,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <20081124112429.GA15791@Krystal>
References: <20081124112429.GA15791@Krystal>
Message-Id: <20081124203932.26BE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 24 Nov 2008 20:44:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>  static struct poll_table_entry *poll_get_entry(poll_table *_p)
>  {
>  	struct poll_wqueues *p = container_of(_p, struct poll_wqueues, pt);
> @@ -117,8 +135,10 @@ static struct poll_table_entry *poll_get
>  }
>  
>  /* Add a new entry */
> -static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
> -				poll_table *p)
> +static void __pollwait_common(struct file *filp,
> +			      wait_queue_head_t *wait_address,
> +			      poll_table *p,
> +			      int exclusive)
>  {
>  	struct poll_table_entry *entry = poll_get_entry(p);
>  	if (!entry)
> @@ -127,7 +147,23 @@ static void __pollwait(struct file *filp
>  	entry->filp = filp;
>  	entry->wait_address = wait_address;
>  	init_waitqueue_entry(&entry->wait, current);
> -	add_wait_queue(wait_address, &entry->wait);
> +	if (!exclusive)
> +		add_wait_queue(wait_address, &entry->wait);
> +	else
> +		add_wait_queue_exclusive(wait_address, &entry->wait);
> +}


I fully agreed this feature is needed.
Actually, I've made similar patch at one years ago.

http://marc.info/?l=linux-kernel&m=120257050719087&w=2


but, I have one question.
My version have epoll support, but yours donesn't have.
Is it intensionally?

this is just dumb question, it doesn't mean any objection.




