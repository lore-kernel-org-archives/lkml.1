Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbXGQCf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbXGQCf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 22:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXGQCfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 22:35:17 -0400
Received: from smtp-out.google.com ([216.239.45.13]:35000 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbXGQCfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 22:35:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=iN46M3zBPuZEvGQT3xcriJW8ufmzlDTZAJrYrqYtnaNINWvTJZhXjN6jxjcKPkQWb
	5NEZQOT61nrSADs5I2VXQ==
Message-ID: <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com>
Date: Mon, 16 Jul 2007 19:35:01 -0700
From: "=?ISO-2022-JP?B?UGF1bCAoGyRCSnVOXBsoQikgTWVuYWdl?=" 
	<menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Containers: css_put() dilemma
Cc: "Pavel Emelianov" <xemul@sw.ru>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Paul Jackson" <pj@sgi.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <469C2792.6050009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469BBE00.8000709@linux.vnet.ibm.com>
	 <6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com>
	 <469C2792.6050009@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> -       if (notify_on_release(cont)) {
> +       if (atomic_dec_and_test(&css->refcnt) && notify_on_release(cont)) {

This seems like a good idea, as long as atomic_dec_and_test() isn't
noticeably more expensive than atomic_dec(). I assume it shouldn't
need to be, since the bus locking operations are presumably the same
in each case.

>                 mutex_lock(&container_mutex);
>                 set_bit(CONT_RELEASABLE, &cont->flags);
> -               if (atomic_dec_and_test(&css->refcnt)) {
> -                       check_for_release(cont);
> -               }
> +               check_for_release(cont);
>                 mutex_unlock(&container_mutex);
>
> That way we set the CONT_RELEASABLE bit only when the ref count drops
> to zero.
>

That's probably a good idea, in conjunction with another part of my
patch for this that frees container objects under RCU - as soon as you
do the atomic_dec_and_test(), then in theory some other thread could
delete the container (since we're no longer going to be taking
container_mutex in this function). But as long as the container object
remains valid until synchronize_rcu() completes, then we can safely
set the CONT_RELEASABLE bit on it.

>
> Yes, that is correct, the advantage is that with can_destroy() we
> don't need to go through release synchronization each time we do
> a css_put().

I think the amount of release synchronization *needed* is going to be
the same whether you have the refcounting done in the subsystem or in
the framework. But I agree that right now we're doing one more atomic
op than we strictly need to, and can remove it.

Paul
