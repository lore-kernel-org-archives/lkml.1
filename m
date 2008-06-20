Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYFTGlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYFTGlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 02:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYFTGky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 02:40:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:28985 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbYFTGkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 02:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=i/HjrAv+0gvA2jFeNQ2fRMV1c3FW/qwerun93mSNsPwkI7/4gmiQ5VH45f+U/q+k5b
         LFujgUTx7qaOKevedxNgzxhMLcBAuiQV2RnpaFuyTgQkm/VMTpK1BQjhVKE4nWlNzRMQ
         OKzsNPjGbmYlk5naGdvem1jVb4EEmO28+8H1k=
Message-ID: <485B50F1.2020802@gmail.com>
Date: Fri, 20 Jun 2008 08:40:49 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Eli Cohen <eli@dev.mellanox.co.il>, general@lists.openfabrics.org
Subject: Re: wait_for_completion_timeout() spurious failure under heavy load?
References: <ada63s5w088.fsf@cisco.com>
In-Reply-To: <ada63s5w088.fsf@cisco.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier napsal(a):
> It seems that the current implementaton of wait_for_completion_timeout()
> has a small problem under very high load for the common pattern:
> 
> 	if (!wait_for_completion_timeout(&done, timeout))
> 		/* handle failure */
> 
> because the implementation very roughly does (lots of code deleted to
> show the basic flow):
> 
> 	static inline long __sched
> 	do_wait_for_common(struct completion *x, long timeout, int state)
> 	{
> 		if (x->done)
> 			return timeout;
> 
> 		do {
> 			timeout = schedule_timeout(timeout);
> 	
> 			if (!timeout)
> 				return timeout;
> 	
> 		} while (!x->done);
> 	
> 		return timeout;
> 	}
> 
> so if the system is very busy and x->done is not set when
> do_wait_for_common() is entered, it is possible that the first call to
> schedule_timeout() returns 0 because the task doing wait_for_completion

Sorry, but how can schedule_timeout return 0 before the timeout expiration?
