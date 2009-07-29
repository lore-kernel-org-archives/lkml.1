Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZG2ItS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZG2ItS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZG2ItR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:49:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:11010 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZG2ItQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rPQWsKKjp7CDItZ+M2bsdpTT7AjuUcMntsTx1LkrstKS+ZptY4dkCwXa7BPh+pnWfx
         Dnu7vL9e/vLTNqxT9Gl0G64vmuhQVRu4Ad+IEJ1R9dsuP6jDGwgZzWUsKnl1R2jO8KnK
         y6o83hsPVd2OKEurSX6P7my1NAVjyhPQZZsOk=
Date: Wed, 29 Jul 2009 16:51:29 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: fix set_binfmt() vs sys_delete_module() race
Message-ID: <20090729085129.GE5856@cr0.nay.redhat.com>
References: <20090724171943.GA10778@redhat.com> <20090728071949.GD6036@cr0.nay.redhat.com> <20090728145817.GB6664@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728145817.GB6664@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 04:58:17PM +0200, Oleg Nesterov wrote:
>On 07/28, Amerigo Wang wrote:
>>
>> On Fri, Jul 24, 2009 at 07:19:43PM +0200, Oleg Nesterov wrote:
>> >sys_delete_module() can set MODULE_STATE_GOING after search_binary_handler()
>> >does try_module_get(). In this case set_binfmt()->try_module_get() fails but
>> >since none of the callers check the returned error, the task will run with
>> >the wrong old ->binfmt.
>> >
>> >The proper fix should change all ->load_binary() methods, but we can rely
>> >on fact that the caller must hold a reference to binfmt->module and use
>> >__module_get() which never fails.
>> >
>>
>> Sounds reasonable.
>>
>> Would like to put the last words as comments into code below?
>
>Yes, thanks.
>
>Rusty pointed out this too, and I already sent the updated patch.
>But due to my mistake (I forgot to CC lkml) this was discussed
>off-list.

I see...

>
>> >-int set_binfmt(struct linux_binfmt *new)
>> >+void set_binfmt(struct linux_binfmt *new)
>> > {
>> >-	struct linux_binfmt *old = current->binfmt;
>> >+	if (current->binfmt)
>> >+		module_put(current->binfmt->module);
>> >
>> >-	if (new) {
>> >-		if (!try_module_get(new->module))
>> >-			return -1;
>> >-	}
>> > 	current->binfmt = new;
>> >-	if (old)
>> >-		module_put(old->module);
>> >-	return 0;
>> >+	if (new)
>> >+		__module_get(new->module);
>>
>>
>> I prefer to put the 'current->binfmt = new;' line as the last
>> statement within this function, since this is more readable for me.
>
>Perhaps... but this is purely cosmetic, and the patch is already
>in -mm. Unless you have a strong feeleing, I'd prefer to not send
>yet another update.
>

No problem, it's just my personal taste. :-D

Thanks!
