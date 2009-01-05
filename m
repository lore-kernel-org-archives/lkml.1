Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZAEKBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZAEKBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZAEKBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:01:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:26482 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbZAEKBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:01:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=fx+9g/2cEwX99X7tRMaMu3A8+4RLK7lagHQf+Iryb60X0F80lhWP3GYlzGuMsVGhTC
         c4ndUWxwli1LbbXEhLi2Sz3YfUJ4Oyoh8S9u5Emdxg9sJeBvD1lqjxfF01n5zE4cR+j7
         RTX/EFqng1tZcqnKh0wYeRXmIlMTUJyDE+wb0=
Message-ID: <84144f020901050200h3fd6ce71qacd5e2dff282a9@mail.gmail.com>
Date: Mon, 5 Jan 2009 12:00:58 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, "Rik van Riel" <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <20090105094034.GA7645@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090105094034.GA7645@localhost>
X-Google-Sender-Auth: 0a8200feb9c39480
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

On Mon, Jan 5, 2009 at 11:40 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> @@ -980,9 +986,12 @@ extern struct mem_section mem_section[NR
>
>  static inline struct mem_section *__nr_to_section(unsigned long nr)
>  {
> -       if (!mem_section[SECTION_NR_TO_ROOT(nr)])
> +       unsigned long idx = SECTION_NR_TO_ROOT(nr);
> +       WARN_ON_ONCE(idx >= NR_SECTION_ROOTS);
> +
> +       if (idx >=NR_SECTION_ROOTS || !mem_section[idx])
>                return NULL;

Looks good to me but I have minor nitpick. You might want to write the
above like this:

    if (WARN_ON_ONCE(idx >= NR_SECTION_ROOTS))
            return NULL;

to separate the error condition from the normal case where we don't
have a mem section.

> -       return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
> +       return &mem_section[idx][nr & SECTION_ROOT_MASK];
>  }
