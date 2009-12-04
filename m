Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbZLDGux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbZLDGux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 01:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZLDGux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 01:50:53 -0500
Received: from mail-pz0-f184.google.com ([209.85.222.184]:41595 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZLDGuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 01:50:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iXfd4XKP0n4ZhBJO5Uy8blG8FwvKF34HvNWjAXkAU2vBm0uT9fP/POUskEMJw+dnWV
         vermxylb3LF3zqbJ1ZhLmhrSlWzDE8dlyJPqomIs/kvENMjCcwLDBm7NWxOeE+gdkWio
         1cF9snCZM11GCNRJ+L0ep+56+1xCgqrWN300w=
MIME-Version: 1.0
In-Reply-To: <1259900760-6424-1-git-send-email-dfeng@redhat.com>
References: <1259900760-6424-1-git-send-email-dfeng@redhat.com>
Date: Thu, 3 Dec 2009 22:50:58 -0800
Message-ID: <dd18b0c30912032250k7502c751mb8aefe7f915a281b@mail.gmail.com>
Subject: Re: [PATCH] ACPICA: don't cond_resched() when irq_disabled or 
	in_atomic
From: Justin Mattock <justinmattock@gmail.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: lenb@kernel.org, ming.m.lin@intel.com, robert.moore@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 3, 2009 at 8:26 PM, Xiaotian Feng <dfeng@redhat.com> wrote:
> commit 8bd108d adds preemption point after each opcode parse, then
> a sleeping function called from invalid context bug was founded
> during suspend/resume stage. this was fixed in commit abe1dfa by
> don't cond_resched when irq_disabled. But recent commit 138d156 changes
> the behaviour to don't cond_resched when in_atomic. This makes the
> sleeping function called from invalid context bug happen again, which
> is reported in http://lkml.org/lkml/2009/12/1/371.
>
> The fix is to cond_sched() only when preemptible, which means not in
> irq_disabled or in_atomic.
>
> Reported-and-bisected-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> ---
>  include/acpi/platform/aclinux.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> index 9d7febd..5b415ee 100644
> --- a/include/acpi/platform/aclinux.h
> +++ b/include/acpi/platform/aclinux.h
> @@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
>  #include <linux/hardirq.h>
>  #define ACPI_PREEMPTION_POINT() \
>        do { \
> -               if (!in_atomic_preempt_off()) \
> +               if (preemptible()) \
>                        cond_resched(); \
>        } while (0)
>
> --
> 1.6.5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

looks good
kernel compiled without any issues,
echo mem > /sys/power/state
reported no warning message.

Also if you don't mind add:
Reported-and-bisected-by: Justin P. Mattock <justinmattock@gmail.com>

Id like to get some kind of credit for this b*tch.

-- 
Justin P. Mattock
