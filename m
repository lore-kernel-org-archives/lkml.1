Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0BWPmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:42:36 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:64770 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab0BWPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:42:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uXxCg7Gd/d8T3vk6mZp0GgHEd+iyB/f2S3G2VLk7z/115f6y3rLUczOEMtPbpha7a7
         +UmbuSagfe+9V4f+qqQtcptGwy+8atU6OUa2Q8kVyhdUtWGAZzh0tThOpTzy5tqWJJZf
         MqfYmvwrhh8eEFeARUxOoEJgIhnuKLvWPVLz8=
Date: Tue, 23 Feb 2010 23:45:19 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dongdong Deng <dongdong.deng@windriver.com>, linux-kernel@vger.kernel.org,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND PATCH] module param_call: fix potential NULL pointer
	dereference
Message-ID: <20100223154519.GA4779@hack>
References: <1266835251-15457-1-git-send-email-dongdong.deng@windriver.com> <201002231426.45886.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201002231426.45886.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 02:26:45PM +1030, Rusty Russell wrote:
>On Mon, 22 Feb 2010 09:10:51 pm Dongdong Deng wrote:
>> The param_set_fn() function will get a parameter which is a NULL
>> pointer when insmod module via bare params as following method:
>> 
>> $insmod foo.ko foo
>> 
>> If the param_set_fn() function didn't check that parameter and used
>> it directly, it could caused an OOPS due to NULL pointer dereference.
>> 
>> The solution is simple:
>> Using "" to replace NULL parameter, thereby the param_set_fn()
>> function will never get a NULL pointer.
>
>This changes the value of booleans, and loses checking for int params, etc.
>
>I liked Americo's approach; I've combined the two approaches below.
>
>Since I'm going away, can Andrew take this?
>
>Subject: params: don't hand NULL values to param.set callbacks.
>
>An audit by Dongdong Deng revealed that most driver-author-written param
>calls don't handle val == NULL (which happens when parameters are specified
>with no =, eg "foo" instead of "foo=1").
>
>The only real case to use this is boolean, so handle it specially for that
>case and remove a source of bugs for everyone else as suggested by Americo.
>
>Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>Cc: Dongdong Deng <dongdong.deng@windriver.com>
>Cc: Américo Wang <xiyou.wangcong@gmail.com>
>
>diff --git a/kernel/params.c b/kernel/params.c
>--- a/kernel/params.c
>+++ b/kernel/params.c
>@@ -59,6 +59,9 @@ static int parse_one(char *param,
> 	/* Find parameter */
> 	for (i = 0; i < num_params; i++) {
> 		if (parameq(param, params[i].name)) {
>+			/* Noone handled NULL, so do it here. */
>+			if (!val && params[i].set != param_set_bool)
>+				return -EINVAL;

Sorry, after rethinking about this, I think it might be wrong.

With this patch, when I use non-standard bool functions, I will not
have a chance to use '!val' which should be valid for all bool
functions. Or am I missing something?

Thanks.

