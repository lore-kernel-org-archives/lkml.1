Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZBEWbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZBEWbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZBEWat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:30:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:39566 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbZBEWas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:30:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=moIO2VVGqnNi24mC7MhQORAqby3pupyapoZYDizs73Bk8ba/mF0TU06jnoiUfxl8ij
         xsAJ58WMIHdch3T8FV68rj+4Rn3aNMl7sO9eblyIOxF87xdd0iUYplo5UfTtDpQWJRr9
         QaTJtqS7aox55N/cZPdmfCScJE+Y1O4SyUsQE=
MIME-Version: 1.0
In-Reply-To: <1232326345-3534-2-git-send-email-brgerst@gmail.com>
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
	 <1232326345-3534-1-git-send-email-brgerst@gmail.com>
	 <1232326345-3534-2-git-send-email-brgerst@gmail.com>
Date: Thu, 5 Feb 2009 14:30:45 -0800
X-Google-Sender-Auth: 37213d444bd6b41d
Message-ID: <12c511ca0902051430w78ca10d9rf96804748ce6ea79@mail.gmail.com>
Subject: Re: [PATCH 2/5] percpu: Refactor percpu.h
From: Tony Luck <tony.luck@intel.com>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 4:52 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Refactor the DEFINE_PER_CPU_* macros and add .data.percpu.first
> section.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index 9f2a375..0e24202 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
...

> +#define DEFINE_PER_CPU_SECTION(type, name, section)                    \
> +       __attribute__((__section__(PER_CPU_BASE_SECTION section)))      \
>        PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name

Brian,

This causes errors for CONFIG_SMP=n builds on ia64.  If you look
at arch/ia64/include/asm/percpu.h you'll see that the !SMP case has


#define PER_CPU_ATTRIBUTES      __attribute__((__section__(".data.percpu")))

So we end up with section attributes of both ".data" and
".data.percpu" for every
DEFINE_PER_CPU used.  The compiler doesn't like that at all :-(


Perhaps PER_CPU_BASE_SECTION needs to be defined by <asm/percpu.h>
so ia64 can avoid the section conflict?

-Tony
