Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYJMHPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYJMHPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 03:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYJMHPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 03:15:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:24685 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYJMHPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 03:15:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=QWPrJfkFCX0CmFV01lesYikO/ECwmNrIHLAayh8w/gcpfVJMUzv3fvycmzu/o6ebu6
         fBJwT0KqQ6WEjgB9IxQxXPdscYI0CWmegnoKKwKm7qbmRyb/r6JkukqNVn12bYtzg1SY
         4hNIAH7AYwc8hrf9wW/zXQcTYaOANbjuwvIyw=
Message-ID: <84144f020810130015j2905e568mb5819c4d4bf27279@mail.gmail.com>
Date: Mon, 13 Oct 2008 10:15:03 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call mechanism
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20081012194427.2e21c22e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081012194427.2e21c22e@infradead.org>
X-Google-Sender-Auth: 007e9e7c5bcac481
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Mon, Oct 13, 2008 at 2:44 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> +void call_async(int pool_number, int argc, ...)
> +{
> +       struct async_item *item;
> +       va_list ap;
> +
> +       if (argc > 4 || argc < 0) {
> +               WARN(1, KERN_ERR "Too many arguments to async function! Skipping...\n");
> +               return;
> +       }
> +
> +       item = kmalloc(sizeof(struct async_item), GFP_ATOMIC);

Why is there no check for NULL here?

> +       item->argument_count = argc;
> +       va_start(ap, argc);
> +       item->func = va_arg(ap, async_func_t_0);
> +       if (argc > 0)
> +               item->arg1 = va_arg(ap, void *);
> +       if (argc > 1)
> +               item->arg2 = va_arg(ap, void *);
> +       if (argc > 2)
> +               item->arg3 = va_arg(ap, void *);
> +       if (argc > 4)
> +               item->arg3 = va_arg(ap, void *);
> +       va_end(ap);
> +
> +       /* If we're not yet or no longer active, just process the work item in place */
> +       if (!async_active) {
> +               do_async_item(item);
> +               kfree(item);
> +               return;
> +       }
> +       spin_lock(&pool_lock);
> +       pool_count[pool_number]++;
> +       list_add_tail(&item->list, &list_pool[pool_number]);
> +       wake_up(&waitqueue_pool[pool_number]);
> +       spin_unlock(&pool_lock);
> +}
> +EXPORT_SYMBOL_GPL(call_async);
