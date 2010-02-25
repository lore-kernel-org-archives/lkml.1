Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab0BYBsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:48:25 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:41439 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0BYBsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:48:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O65X5WioibdbP/i25pQ7cGqOvMPCKfETgccZiuGl/Abt/k2X7LgxU0F8yveySukG8e
         M0AWO3AdZxqM+H6LfeEF2024a907azmLpurRTJwAN3K3qF7Uk1mSlSXKr0j7fe42c8Tt
         2l0illKJCAQH/ZGJves2gC8UL51r+enEtSJA4=
MIME-Version: 1.0
In-Reply-To: <201002241131.16766.rusty@rustcorp.com.au>
References: <1266835251-15457-1-git-send-email-dongdong.deng@windriver.com>
	 <201002231426.45886.rusty@rustcorp.com.au>
	 <20100223154519.GA4779@hack>
	 <201002241131.16766.rusty@rustcorp.com.au>
Date: Thu, 25 Feb 2010 09:48:22 +0800
Message-ID: <2375c9f91002241748h151b9592y246ccb0bcdb3a7b5@mail.gmail.com>
Subject: Re: [RESEND PATCH] module param_call: fix potential NULL pointer 
	dereference
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dongdong Deng <dongdong.deng@windriver.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 9:01 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wed, 24 Feb 2010 02:15:19 am Américo Wang wrote:
>> On Tue, Feb 23, 2010 at 02:26:45PM +1030, Rusty Russell wrote:
>> >On Mon, 22 Feb 2010 09:10:51 pm Dongdong Deng wrote:
>> >> The param_set_fn() function will get a parameter which is a NULL
>> >> pointer when insmod module via bare params as following method:
>> >>
>> >> $insmod foo.ko foo
>> >>
>> >> If the param_set_fn() function didn't check that parameter and used
>> >> it directly, it could caused an OOPS due to NULL pointer dereference.
>> >>
>> >> The solution is simple:
>> >> Using "" to replace NULL parameter, thereby the param_set_fn()
>> >> function will never get a NULL pointer.
>> >
>> >This changes the value of booleans, and loses checking for int params, etc.
>> >
>> >I liked Americo's approach; I've combined the two approaches below.
>> >
>> >Since I'm going away, can Andrew take this?
>> >
>> >Subject: params: don't hand NULL values to param.set callbacks.
>> >
>> >An audit by Dongdong Deng revealed that most driver-author-written param
>> >calls don't handle val == NULL (which happens when parameters are specified
>> >with no =, eg "foo" instead of "foo=1").
>> >
>> >The only real case to use this is boolean, so handle it specially for that
>> >case and remove a source of bugs for everyone else as suggested by Americo.
>> >
>> >Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>> >Cc: Dongdong Deng <dongdong.deng@windriver.com>
>> >Cc: Américo Wang <xiyou.wangcong@gmail.com>
>> >
>> >diff --git a/kernel/params.c b/kernel/params.c
>> >--- a/kernel/params.c
>> >+++ b/kernel/params.c
>> >@@ -59,6 +59,9 @@ static int parse_one(char *param,
>> >     /* Find parameter */
>> >     for (i = 0; i < num_params; i++) {
>> >             if (parameq(param, params[i].name)) {
>> >+                    /* Noone handled NULL, so do it here. */
>> >+                    if (!val && params[i].set != param_set_bool)
>> >+                            return -EINVAL;
>>
>> Sorry, after rethinking about this, I think it might be wrong.
>>
>> With this patch, when I use non-standard bool functions, I will not
>> have a chance to use '!val' which should be valid for all bool
>> functions. Or am I missing something?
>
> Sure, at that point we'd need something more sophisticated.  But to
> fix this properly we want a flags word, and thus something like this
> which I worked on earlier:
>
> http://ozlabs.org/~rusty/kernel/rr-latest/param:param_ops.patch
>

Thanks, Rusty!

I love that patch, but since 2.6.33 is already out, can we try to get it
merged for 2.6.34?
