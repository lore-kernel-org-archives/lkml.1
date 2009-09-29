Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbZI2Fz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbZI2Fz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 01:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZI2Fz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 01:55:57 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:40990 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbZI2Fz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 01:55:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XL8M6H/leacGhh6ent2sJwG8AeXaygkMk3o6OsCcSKsY948MclIRLLDmLVlKh2W08b
         VFmbs3Collzwag4MSY2UShOyWuujVZU06oTnCrO8vs5w2SQolO38K7moH62xB2Da2qXM
         SalJIZrp0nxuQ6v4tEplSEdNB/Pis9a5J3Ca8=
MIME-Version: 1.0
In-Reply-To: <20090926205336.77bc5b21@infradead.org>
References: <20090926204951.424e567e@infradead.org>
	 <20090926205336.77bc5b21@infradead.org>
Date: Tue, 29 Sep 2009 15:55:49 +1000
Message-ID: <21d7e9970909282255y6718b11cvadafae0e1648817c@mail.gmail.com>
Subject: Re: [PATCH 7/9] Simplify bound checks in capabilities for 
	copy_from_user
From: Dave Airlie <airlied@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       jmorris@nami.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 4:53 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH 7/9] Simplify bound checks in capabilities for copy_from_user
> CC: James Morris <jmorris@namei.org>
>
> The capabilities syscall has a copy_from_user() call where gcc currently
> cannot prove to itself that the copy is always within bounds.
>
> This patch adds a very explicity bound check to prove to gcc that
> this copy_from_user cannot overflow its destination buffer.
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 4e17041..204f11f 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -238,7 +241,7 @@ SYSCALL_DEFINE2(capget, cap_user_header_t, header, cap_user_data_t, dataptr)
>  SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
>  {
>        struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
> -       unsigned i, tocopy;
> +       unsigned i, tocopy, copybytes;
>        kernel_cap_t inheritable, permitted, effective;
>        struct cred *new;
>        int ret;
> @@ -255,8 +258,11 @@ SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
>        if (pid != 0 && pid != task_pid_vnr(current))
>                return -EPERM;
>
> -       if (copy_from_user(&kdata, data,
> -                          tocopy * sizeof(struct __user_cap_data_struct)))
> +       copybytes = tocopy * sizeof(struct __user_cap_data_struct);
> +       if (copybytes > _KERNEL_CAPABILITY_U32S)
> +               return -EFAULT;

This is broken, it breaks dbus at least for me. you compare bytes
to u32s wrongly.

Dave.

> +
> +       if (copy_from_user(&kdata, data, copybytes))
>                return -EFAULT;
>
>        for (i = 0; i < tocopy; i++) {
>
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
